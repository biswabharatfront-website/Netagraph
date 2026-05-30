-- Migration: Politician Schemes and Milestones Database Schema
-- Date: 2026-05-30
-- Platform: Supabase / PostgreSQL

-- 1. Create politician_schemes table
CREATE TABLE IF NOT EXISTS public.politician_schemes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    politician_id UUID NOT NULL REFERENCES public.politicians(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    eligibility TEXT NOT NULL,
    budget_allocated TEXT NOT NULL,
    beneficiaries_count TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('Active', 'Completed', 'Suspended')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_politician_scheme UNIQUE(politician_id, title)
);

-- 2. Create politician_milestones table
CREATE TABLE IF NOT EXISTS public.politician_milestones (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    politician_id UUID NOT NULL REFERENCES public.politicians(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    date DATE NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('term_start', 'promise_completed', 'achievement', 'townhall', 'future_milestone')),
    icon_name TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_politician_milestone UNIQUE(politician_id, title, date)
);

-- 3. Enable Row Level Security (RLS)
ALTER TABLE public.politician_schemes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.politician_milestones ENABLE ROW LEVEL SECURITY;

-- 4. Create Security Policies
-- Everyone can read schemes and milestones
CREATE POLICY "Allow public read-only access to schemes" 
ON public.politician_schemes FOR SELECT USING (true);

CREATE POLICY "Allow public read-only access to milestones" 
ON public.politician_milestones FOR SELECT USING (true);

-- Only Admins, Moderators, or backend service roles can write
CREATE POLICY "Allow write access to schemes for authorized roles" 
ON public.politician_schemes FOR ALL 
USING (
  auth.uid() IN (
    SELECT id FROM public.profiles WHERE role IN ('admin', 'moderator', 'system')
  )
);

CREATE POLICY "Allow write access to milestones for authorized roles" 
ON public.politician_milestones FOR ALL 
USING (
  auth.uid() IN (
    SELECT id FROM public.profiles WHERE role IN ('admin', 'moderator', 'system')
  )
);
