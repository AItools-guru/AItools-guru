-- =====================================================================
-- Migration 003: HNSW Vector Index + match_meetings RPC Function
-- Run this in the Supabase SQL Editor AFTER migrations 001 and 002
-- =====================================================================
-- Prerequisites:
--   - pgvector extension must be enabled:
--     CREATE EXTENSION IF NOT EXISTS vector;
--   - The meetings table must have an 'embedding' column of type vector(768)
--     (768 dimensions for Gemini text-embedding-004)
-- =====================================================================

-- Ensure pgvector extension is available
CREATE EXTENSION IF NOT EXISTS vector;

-- ─────────────────────────────────────────────────────────
-- 1. HNSW Index on meetings.embedding
-- ─────────────────────────────────────────────────────────
-- HNSW (Hierarchical Navigable Small Worlds) provides fast
-- approximate nearest neighbor search. It is preferred over
-- IVFFlat for workloads with frequent inserts and moderate
-- dataset sizes (up to ~1M rows).
--
-- Parameters:
--   m = 16 (connections per layer; higher = more accurate, more memory)
--   ef_construction = 64 (build time accuracy; higher = slower build, better index)

CREATE INDEX IF NOT EXISTS idx_meetings_embedding_hnsw
ON meetings
USING hnsw (embedding vector_cosine_ops)
WITH (m = 16, ef_construction = 64);

-- ─────────────────────────────────────────────────────────
-- 2. match_meetings RPC Function (Cosine Similarity Search)
-- ─────────────────────────────────────────────────────────
-- This function is called from rag_engine.py via:
--   client.rpc("match_meetings", { query_embedding, match_threshold, match_count, p_user_id })
--
-- It returns meetings whose embedding cosine similarity exceeds the threshold,
-- ordered by similarity descending, limited to match_count results.
-- The p_user_id parameter ensures data isolation per user.

CREATE OR REPLACE FUNCTION match_meetings(
    query_embedding vector(768),
    match_threshold float DEFAULT 0.5,
    match_count int DEFAULT 5,
    p_user_id text DEFAULT ''
)
RETURNS TABLE (
    id uuid,
    user_id text,
    title text,
    date text,
    duration text,
    summary jsonb,
    created_at timestamptz,
    similarity float
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    RETURN QUERY
    SELECT
        m.id,
        m.user_id,
        m.title,
        m.date,
        m.duration,
        m.summary,
        m.created_at,
        1 - (m.embedding <=> query_embedding) AS similarity
    FROM meetings m
    WHERE
        m.user_id = p_user_id
        AND m.embedding IS NOT NULL
        AND 1 - (m.embedding <=> query_embedding) > match_threshold
    ORDER BY m.embedding <=> query_embedding
    LIMIT match_count;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION match_meetings TO authenticated;

-- ─────────────────────────────────────────────────────────
-- 3. Verification
-- ─────────────────────────────────────────────────────────
-- Check the index exists:
--   SELECT indexname, indexdef FROM pg_indexes
--   WHERE tablename = 'meetings' AND indexname LIKE '%hnsw%';
--
-- Check the function exists:
--   SELECT routine_name, routine_type FROM information_schema.routines
--   WHERE routine_schema = 'public' AND routine_name = 'match_meetings';
