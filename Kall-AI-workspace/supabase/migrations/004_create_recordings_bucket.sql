-- =====================================================================
-- Migration 004: Create Recordings Storage Bucket & RLS Policies
-- Run this in the Supabase SQL Editor
-- =====================================================================

-- ─────────────────────────────────────────────────────────
-- 1. Create the recordings bucket
-- ─────────────────────────────────────────────────────────
-- Inserts a private bucket named 'recordings' if it doesn't exist
INSERT INTO storage.buckets (id, name, public)
VALUES ('recordings', 'recordings', false)
ON CONFLICT (id) DO NOTHING;

-- ─────────────────────────────────────────────────────────
-- 2. Storage Objects RLS Policies
-- ─────────────────────────────────────────────────────────
-- Enables fine-grained row-level security for files within the
-- recordings bucket.

-- Policy A: Allow authenticated users to upload files into their own
-- folder matching their user_id.
-- Path syntax: bucket_id = 'recordings' AND owner's folder = user_id
CREATE POLICY "Allow authenticated uploads to own folder"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'recordings' 
    AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Policy B: Allow authenticated users to view or download files
-- from their own folder.
CREATE POLICY "Allow authenticated reads from own folder"
ON storage.objects FOR SELECT
TO authenticated
USING (
    bucket_id = 'recordings'
    AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Policy C: Allow authenticated users to delete files from their own folder.
CREATE POLICY "Allow authenticated deletes from own folder"
ON storage.objects FOR DELETE
TO authenticated
USING (
    bucket_id = 'recordings'
    AND (storage.foldername(name))[1] = auth.uid()::text
);

-- ─────────────────────────────────────────────────────────
-- 3. Verification Queries
-- ─────────────────────────────────────────────────────────
-- Check if the bucket exists:
--   SELECT * FROM storage.buckets WHERE id = 'recordings';
--
-- Check storage policies:
--   SELECT policyname, cmd FROM pg_policies WHERE tablename = 'objects';
