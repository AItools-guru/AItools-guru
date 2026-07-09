-- =====================================================================
-- Migration 002: Enable Row Level Security (RLS) on Core Tables
-- Run this in the Supabase SQL Editor AFTER migration 001
-- =====================================================================
-- IMPORTANT: These policies enforce that each user can ONLY access
-- their own rows. The Supabase anon key + JWT auth session makes
-- auth.uid() available automatically when the client signs in via
-- client.auth.sign_in_with_password().
-- =====================================================================

-- ─────────────────────────────────────────────────────────
-- 1. Enable RLS on both tables
-- ─────────────────────────────────────────────────────────

ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE meetings ENABLE ROW LEVEL SECURITY;

-- ─────────────────────────────────────────────────────────
-- 2. user_profiles Policies
-- ─────────────────────────────────────────────────────────

-- Users can read their own profile
CREATE POLICY "Users can view own profile"
ON user_profiles FOR SELECT
USING (auth.uid()::text = user_id);

-- Users can insert their own profile (on first sign up)
CREATE POLICY "Users can insert own profile"
ON user_profiles FOR INSERT
WITH CHECK (auth.uid()::text = user_id);

-- Users can update their own profile (API key changes, settings)
CREATE POLICY "Users can update own profile"
ON user_profiles FOR UPDATE
USING (auth.uid()::text = user_id)
WITH CHECK (auth.uid()::text = user_id);

-- Users CANNOT delete their profile via the client SDK
-- (Admin operations only via service role key or dashboard)

-- ─────────────────────────────────────────────────────────
-- 3. meetings Policies
-- ─────────────────────────────────────────────────────────

-- Users can read their own meetings
CREATE POLICY "Users can view own meetings"
ON meetings FOR SELECT
USING (auth.uid()::text = user_id);

-- Users can insert their own meetings
CREATE POLICY "Users can insert own meetings"
ON meetings FOR INSERT
WITH CHECK (auth.uid()::text = user_id);

-- Users can update their own meetings (e.g., edit title)
CREATE POLICY "Users can update own meetings"
ON meetings FOR UPDATE
USING (auth.uid()::text = user_id)
WITH CHECK (auth.uid()::text = user_id);

-- Users can delete their own meetings
CREATE POLICY "Users can delete own meetings"
ON meetings FOR DELETE
USING (auth.uid()::text = user_id);

-- ─────────────────────────────────────────────────────────
-- 4. Service Role Bypass (for Stripe webhook handler)
-- ─────────────────────────────────────────────────────────
-- The service_role key automatically bypasses RLS in Supabase,
-- so no additional policy is needed for the webhook handler.
-- This comment documents the architectural decision:
--   - Webhook handler uses SUPABASE_SERVICE_ROLE_KEY
--   - It can update user_profiles.plan without being blocked by RLS
--   - The anon key used by the dashboard client respects all policies above

-- ─────────────────────────────────────────────────────────
-- 5. Verification Queries
-- ─────────────────────────────────────────────────────────
-- Run these to confirm RLS is active:
--   SELECT tablename, rowsecurity FROM pg_tables
--   WHERE schemaname = 'public' AND tablename IN ('user_profiles', 'meetings');
--
-- Run these to confirm policies exist:
--   SELECT policyname, tablename, cmd
--   FROM pg_policies
--   WHERE schemaname = 'public';
