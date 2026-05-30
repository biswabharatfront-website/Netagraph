-- Migration: Base Tables for Netagraph Civic Portal
-- Date: 2026-05-29
-- Platform: Supabase / PostgreSQL

-- 1. Enable PostGIS and Crypto Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- 2. Create Profiles Table
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT,
    phone TEXT,
    avatar_url TEXT,
    ward_name TEXT DEFAULT 'Ward 142 - Varthur',
    location_text TEXT DEFAULT 'Varthur, Bengaluru, Karnataka 560087',
    reports_filed INTEGER DEFAULT 0,
    contributions_count INTEGER DEFAULT 0,
    active_score INTEGER DEFAULT 0,
    badges TEXT[] DEFAULT '{}',
    reputation_score NUMERIC DEFAULT 100.0,
    reputation_level TEXT DEFAULT 'New Citizen',
    is_resident_verified BOOLEAN DEFAULT FALSE,
    resident_verification_status TEXT DEFAULT 'None',
    uploaded_doc_type TEXT,
    uploaded_doc_url TEXT,
    role TEXT DEFAULT 'citizen' CHECK (role IN ('citizen', 'admin', 'moderator', 'system')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Create Reports (Issues) Table
CREATE TABLE IF NOT EXISTS public.reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    category TEXT NOT NULL,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    location_name TEXT,
    image_url TEXT,
    reporter_name TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'verified', 'inProgress', 'resolved')),
    upvotes INTEGER DEFAULT 0,
    
    -- EXIF metadata
    gps_verified BOOLEAN DEFAULT TRUE,
    exif_verified BOOLEAN DEFAULT TRUE,
    exif_camera TEXT DEFAULT 'OnePlus 11 5G',
    exif_timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Anti-spam
    ip_address_hash TEXT,
    device_fingerprint TEXT,
    location_area TEXT,
    suspicious_flags_count INTEGER DEFAULT 0,
    is_reported_suspicious BOOLEAN DEFAULT FALSE
);

-- 4. Create Upvotes Table
CREATE TABLE IF NOT EXISTS public.upvotes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    report_id UUID REFERENCES public.reports(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    ip_address_hash TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_user_report_upvote UNIQUE (report_id, user_id)
);

-- 5. Create Comments Table
CREATE TABLE IF NOT EXISTS public.comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    report_id UUID REFERENCES public.reports(id) ON DELETE CASCADE,
    author_name TEXT NOT NULL,
    author_badge TEXT DEFAULT 'Resident',
    text TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. Create Discussions Table
CREATE TABLE IF NOT EXISTS public.discussions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    author_name TEXT NOT NULL,
    author_role TEXT DEFAULT 'Resident',
    upvotes INTEGER DEFAULT 1,
    replies TEXT[] DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 7. Create Announcements Table
CREATE TABLE IF NOT EXISTS public.announcements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    author_name TEXT NOT NULL,
    is_urgent BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 8. Create Events Table
CREATE TABLE IF NOT EXISTS public.events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    date_text TEXT NOT NULL,
    time_text TEXT NOT NULL,
    location_text TEXT NOT NULL,
    rsvp_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 9. Create Event RSVPs Table
CREATE TABLE IF NOT EXISTS public.event_rsvps (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID REFERENCES public.events(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_user_event_rsvp UNIQUE (event_id, user_id)
);

-- 10. Enable Row Level Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.upvotes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.discussions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.announcements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.event_rsvps ENABLE ROW LEVEL SECURITY;

-- 11. Security Policies
CREATE POLICY "Allow public read access" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Allow public read access" ON public.reports FOR SELECT USING (true);
CREATE POLICY "Allow public read access" ON public.upvotes FOR SELECT USING (true);
CREATE POLICY "Allow public read access" ON public.comments FOR SELECT USING (true);
CREATE POLICY "Allow public read access" ON public.discussions FOR SELECT USING (true);
CREATE POLICY "Allow public read access" ON public.announcements FOR SELECT USING (true);
CREATE POLICY "Allow public read access" ON public.events FOR SELECT USING (true);
CREATE POLICY "Allow public read access" ON public.event_rsvps FOR SELECT USING (true);

CREATE POLICY "Allow insert profile" ON public.profiles FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Allow public inserts" ON public.reports FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public upvotes" ON public.upvotes FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public upvotes delete" ON public.upvotes FOR DELETE USING (true);
CREATE POLICY "Allow public comments" ON public.comments FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public discussions" ON public.discussions FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public events rsvp" ON public.event_rsvps FOR INSERT WITH CHECK (true);
