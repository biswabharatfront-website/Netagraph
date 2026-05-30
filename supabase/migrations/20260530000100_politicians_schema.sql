-- Migration: Politicians and Promises Database Schema
-- Date: 2026-05-30
-- Platform: Supabase / PostgreSQL with PostGIS

-- 1. Enable PostGIS if not already active
CREATE EXTENSION IF NOT EXISTS postgis;

-- 2. Create politicians table
CREATE TABLE IF NOT EXISTS public.politicians (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Core Identity
    name TEXT NOT NULL,
    full_name TEXT,
    position TEXT NOT NULL, -- e.g., 'MLA', 'MP', 'Councillor'
    level TEXT NOT NULL CHECK (level IN ('local', 'state', 'national')),
    
    -- Constituency & Location
    constituency TEXT NOT NULL,
    ward_number TEXT,
    pin_code TEXT,
    assembly_constituency TEXT,
    parliamentary_constituency TEXT,
    state TEXT NOT NULL,
    district TEXT,
    
    -- Geography
    constituency_boundary GEOGRAPHY(POLYGON, 4326),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    
    -- Political Details
    party TEXT NOT NULL,
    party_symbol_url TEXT,
    election_year INTEGER,
    term_start DATE,
    term_end DATE,
    website TEXT,
    twitter_handle TEXT,
    facebook_url TEXT,
    
    -- Performance & Statistics
    accountability_score DOUBLE PRECISION DEFAULT 0.0,
    promises_kept_rate DOUBLE PRECISION DEFAULT 0.0, -- In percent (0.0 to 100.0)
    response_rate DOUBLE PRECISION DEFAULT 0.0,
    open_reports_percentage DOUBLE PRECISION DEFAULT 0.0,
    total_reports INTEGER DEFAULT 0,
    resolved_reports INTEGER DEFAULT 0,
    open_reports INTEGER DEFAULT 0,
    average_response_time_days DOUBLE PRECISION DEFAULT 0.0,
    last_activity_date TIMESTAMP WITH TIME ZONE,
    
    -- Disclosures & Records (Scraped from MyNeta/sansad/ECI)
    education TEXT,
    assets DOUBLE PRECISION, -- Total declared wealth in INR
    liabilities DOUBLE PRECISION, -- Total declared debts in INR
    criminal_cases INTEGER DEFAULT 0, -- Count of pending cases
    bio TEXT,
    
    -- Communication & Contact
    email TEXT,
    phone TEXT,
    office_address TEXT,
    photo_url TEXT,
    
    -- Audit Metadata
    source TEXT DEFAULT 'Compiled' NOT NULL, -- e.g., 'MyNeta / ADR, Sansad, ECI'
    source_url TEXT,
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    is_active BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT FALSE
);

-- 3. Create politician_promises table
CREATE TABLE IF NOT EXISTS public.politician_promises (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    politician_id UUID REFERENCES public.politicians(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    category TEXT NOT NULL, -- e.g., 'Roads', 'Water', 'Waste', 'Healthcare'
    status TEXT NOT NULL CHECK (status IN ('Not Started', 'In Progress', 'Delivered', 'Stalled', 'Broken')),
    due_date DATE,
    evidence_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Enable Row Level Security (RLS)
ALTER TABLE public.politicians ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.politician_promises ENABLE ROW LEVEL SECURITY;

-- 5. Create Security Policies
-- Everyone can read politician profiles
CREATE POLICY "Allow public read-only access to politicians" 
ON public.politicians FOR SELECT USING (true);

CREATE POLICY "Allow public read-only access to promises" 
ON public.politician_promises FOR SELECT USING (true);

-- Only Admins, Moderators, or backend service roles can write
CREATE POLICY "Allow write access to authorized roles" 
ON public.politicians FOR ALL 
USING (
  auth.uid() IN (
    SELECT id FROM public.profiles WHERE role IN ('admin', 'moderator', 'system')
  )
);

CREATE POLICY "Allow write access to promises for authorized roles" 
ON public.politician_promises FOR ALL 
USING (
  auth.uid() IN (
    SELECT id FROM public.profiles WHERE role IN ('admin', 'moderator', 'system')
  )
);
