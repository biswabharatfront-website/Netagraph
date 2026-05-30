-- Migration: Coordinated suspicious activity flagging system
-- Date: 2026-05-30
-- Platform: Supabase / PostgreSQL

-- 1. Create PostGIS and Crypto extensions if not exist
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 2. Alter reports table to add new audit fields
ALTER TABLE public.reports 
ADD COLUMN IF NOT EXISTS ip_address_hash TEXT,
ADD COLUMN IF NOT EXISTS device_fingerprint TEXT,
ADD COLUMN IF NOT EXISTS location_area TEXT;

-- 3. Create suspicious_activity_flags table
CREATE TABLE IF NOT EXISTS public.suspicious_activity_flags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    report_id UUID REFERENCES public.reports(id) ON DELETE CASCADE,
    user_id UUID,                                       -- References auth.users(id) if user is flagged
    flag_type TEXT NOT NULL,                            -- 'ip_burst', 'text_similarity', 'geo_burst', 'coordinated'
    reason TEXT NOT NULL,
    severity INTEGER DEFAULT 1 CHECK (severity IN (1, 2, 3)), -- 1=Low, 2=Medium, 3=High
    flagged_by UUID,                                    -- References auth.users(id) if manual admin flag
    status TEXT DEFAULT 'Pending' CHECK (status IN ('Pending', 'Confirmed', 'Dismissed')),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Enable Row Level Security (RLS) for Flags Table
ALTER TABLE public.suspicious_activity_flags ENABLE ROW LEVEL SECURITY;

-- 5. Create Security Policies (Only Admins and Moderators can view/modify flags)
CREATE POLICY "Admins and moderators can view flags" 
ON public.suspicious_activity_flags
FOR SELECT
USING (
  auth.uid() IN (
    -- Select UIDs of admin/moderator roles from a custom profile table (assumes standard setup)
    -- Or check if auth.jwt() claims contain moderator/admin roles
    SELECT id FROM public.profiles WHERE role IN ('admin', 'moderator')
  )
);

CREATE POLICY "Admins and moderators can modify flags"
ON public.suspicious_activity_flags
FOR ALL
USING (
  auth.uid() IN (
    SELECT id FROM public.profiles WHERE role IN ('admin', 'moderator')
  )
)
WITH CHECK (
  auth.uid() IN (
    SELECT id FROM public.profiles WHERE role IN ('admin', 'moderator')
  )
);

-- 6. Helper Privacy Function: Hash IP addresses using SHA-256
CREATE OR REPLACE FUNCTION public.hash_ip_address(ip_addr TEXT)
RETURNS TEXT AS $$
BEGIN
    RETURN encode(digest(ip_addr, 'sha256'), 'hex');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 7. Server Function: Rules Engine for Automated Incident Flags
CREATE OR REPLACE FUNCTION public.detect_suspicious_activity()
RETURNS TRIGGER AS $$
DECLARE
    ip_burst_count INTEGER;
    geo_burst_count INTEGER;
    duplicate_count INTEGER;
    area_name TEXT;
BEGIN
    -- Check if IP hash is provided
    IF NEW.ip_address_hash IS NOT NULL THEN
        -- Check Rule A: IP Range Burst (If >5 reports from same IP in last 2 hours)
        SELECT COUNT(*)
        INTO ip_burst_count
        FROM public.reports
        WHERE ip_address_hash = NEW.ip_address_hash
          AND created_at >= NOW() - INTERVAL '2 hours';

        IF ip_burst_count > 5 THEN
            INSERT INTO public.suspicious_activity_flags (report_id, flag_type, reason, severity, notes)
            VALUES (
                NEW.id,
                'ip_burst',
                'Coordinated IP Burst detected. ' || ip_burst_count || ' reports submitted from the same hashed IP in the last 2 hours.',
                3, -- High Severity
                'Automated Rule Trigger: IP range burst threshold exceeded.'
            );
        END IF;
    END IF;

    -- Check Rule B: Geo Burst (If many reports from same area in a short time)
    IF NEW.location_area IS NOT NULL THEN
        SELECT COUNT(*)
        INTO geo_burst_count
        FROM public.reports
        WHERE location_area = NEW.location_area
          AND created_at >= NOW() - INTERVAL '2 hours';

        IF geo_burst_count > 10 THEN
            INSERT INTO public.suspicious_activity_flags (report_id, flag_type, reason, severity, notes)
            VALUES (
                NEW.id,
                'geo_burst',
                'Hyperlocal Geo Burst detected. ' || geo_burst_count || ' reports submitted in the same area (' || NEW.location_area || ') in the last 2 hours.',
                2, -- Medium Severity
                'Automated Rule Trigger: Geo burst spatial threshold exceeded.'
            );
        END IF;
    END IF;

    -- Check Rule C: Text Similarity / Duplicates (Compare new report with recent reports)
    SELECT COUNT(*)
    INTO duplicate_count
    FROM public.reports
    WHERE id <> NEW.id
      AND category = NEW.category
      AND (
          similarity(title, NEW.title) > 0.8
          OR similarity(description, NEW.description) > 0.85
      )
      AND created_at >= NOW() - INTERVAL '6 hours';

    IF duplicate_count > 0 THEN
        INSERT INTO public.suspicious_activity_flags (report_id, flag_type, reason, severity, notes)
        VALUES (
            NEW.id,
            'text_similarity',
            'Text Similarity alert. Found recent duplicate report matching title/description with >80% similarity threshold.',
            1, -- Low Severity
            'Automated Rule Trigger: Text similarity index exceeded.'
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 8. Bind Rules Engine trigger to reports table
CREATE OR REPLACE TRIGGER trg_detect_suspicious_activity
AFTER INSERT ON public.reports
FOR EACH ROW
EXECUTE FUNCTION public.detect_suspicious_activity();

-- 9. Server Function: Upvote Coordinated Attack Detector
CREATE OR REPLACE FUNCTION public.check_upvote_burst()
RETURNS TRIGGER AS $$
DECLARE
    upvote_burst_count INTEGER;
BEGIN
    -- Check Rule D: Upvote Burst (If >15 upvotes from same hashed IP range on a report in last 2 hours)
    SELECT COUNT(*)
    INTO upvote_burst_count
    FROM public.upvotes
    WHERE report_id = NEW.report_id
      AND ip_address_hash = NEW.ip_address_hash
      AND created_at >= NOW() - INTERVAL '2 hours';

    IF upvote_burst_count > 15 THEN
        -- Insert flag on the target report if it isn't already flagged for this upvote burst
        IF NOT EXISTS (
            SELECT 1 FROM public.suspicious_activity_flags 
            WHERE report_id = NEW.report_id 
              AND flag_type = 'ip_burst' 
              AND reason LIKE '%upvotes%'
        ) THEN
            INSERT INTO public.suspicious_activity_flags (report_id, flag_type, reason, severity, notes)
            VALUES (
                NEW.report_id,
                'ip_burst',
                'Suspicious Coordinated Upvoting detected. ' || upvote_burst_count || ' upvotes cast on this report from the same hashed IP within the last 2 hours.',
                3, -- High Severity
                'Automated Rule Trigger: Coordinated upvote attack detected.'
            );
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
