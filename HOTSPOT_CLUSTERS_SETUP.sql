-- Hotspot Clusters Database Schema
-- Run this in your Supabase SQL Editor

-- Hotspot clusters table (stores GPS-based report clusters)
-- Skip if already exists
CREATE TABLE IF NOT EXISTS hotspot_clusters (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    center_lat DECIMAL(10, 8) NOT NULL,
    center_lng DECIMAL(11, 8) NOT NULL,
    area_name TEXT,
    priority INTEGER DEFAULT 0,
    total_reports INTEGER DEFAULT 0,
    unresolved_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add cluster_id to reports table (skip if exists)
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'reports' AND column_name = 'cluster_id') THEN
        ALTER TABLE reports ADD COLUMN cluster_id UUID REFERENCES hotspot_clusters(id) ON DELETE SET NULL;
    END IF;
END $$;

-- Index for faster lookups (skip if exists)
CREATE INDEX IF NOT EXISTS idx_reports_cluster_id ON reports(cluster_id);
CREATE INDEX IF NOT EXISTS idx_hotspot_clusters_priority ON hotspot_clusters(priority DESC);

-- Enable RLS
ALTER TABLE hotspot_clusters ENABLE ROW LEVEL SECURITY;

-- Drop existing policies first (to avoid conflicts)
DROP POLICY IF EXISTS "Anyone can view hotspot clusters" ON hotspot_clusters;
DROP POLICY IF EXISTS "Admins can insert hotspot clusters" ON hotspot_clusters;
DROP POLICY IF EXISTS "Admins can update hotspot clusters" ON hotspot_clusters;
DROP POLICY IF EXISTS "Admins can delete hotspot clusters" ON hotspot_clusters;

-- Policies for hotspot_clusters
CREATE POLICY "Anyone can view hotspot clusters"
    ON hotspot_clusters FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Admins can insert hotspot clusters"
    ON hotspot_clusters FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.is_admin = true
        )
    );

CREATE POLICY "Admins can update hotspot clusters"
    ON hotspot_clusters FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.is_admin = true
        )
    );

CREATE POLICY "Admins can delete hotspot clusters"
    ON hotspot_clusters FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.is_admin = true
        )
    );

-- Trigger for updated_at (skip if exists)
DROP TRIGGER IF EXISTS hotspot_clusters_updated_at ON hotspot_clusters;
CREATE TRIGGER hotspot_clusters_updated_at
    BEFORE UPDATE ON hotspot_clusters
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();
