-- =====================================================================
-- Migration 001: Add Pro Plan Columns to user_profiles
-- Run this in the Supabase SQL Editor (Dashboard > SQL Editor)
-- =====================================================================

-- Add plan column: 'free' (default) or 'pro'
ALTER TABLE user_profiles
ADD COLUMN IF NOT EXISTS plan text NOT NULL DEFAULT 'free';

-- Add Stripe customer ID for webhook correlation
ALTER TABLE user_profiles
ADD COLUMN IF NOT EXISTS stripe_customer_id text DEFAULT NULL;

-- Add subscription lifecycle status
-- Values: 'inactive', 'active', 'past_due', 'canceled', 'trialing'
ALTER TABLE user_profiles
ADD COLUMN IF NOT EXISTS subscription_status text NOT NULL DEFAULT 'inactive';

-- Add timestamp for when the subscription was last updated
ALTER TABLE user_profiles
ADD COLUMN IF NOT EXISTS subscription_updated_at timestamptz DEFAULT NULL;

-- Create an index on stripe_customer_id for fast webhook lookups
CREATE INDEX IF NOT EXISTS idx_user_profiles_stripe_customer_id
ON user_profiles (stripe_customer_id)
WHERE stripe_customer_id IS NOT NULL;

-- Verify: SELECT column_name, data_type, column_default
-- FROM information_schema.columns WHERE table_name = 'user_profiles';
