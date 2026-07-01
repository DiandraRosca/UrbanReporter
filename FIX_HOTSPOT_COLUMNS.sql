-- Fix missing columns in hotspot_clusters table
-- Run this in Supabase SQL Editor

-- Add missing columns if they don't exist
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'hotspot_clusters' AND column_name = 'total_reports') THEN
        ALTER TABLE hotspot_clusters ADD COLUMN total_reports INTEGER DEFAULT 0;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'hotspot_clusters' AND column_name = 'unresolved_count') THEN
        ALTER TABLE hotspot_clusters ADD COLUMN unresolved_count INTEGER DEFAULT 0;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'hotspot_clusters' AND column_name = 'priority') THEN
        ALTER TABLE hotspot_clusters ADD COLUMN priority INTEGER DEFAULT 0;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'hotspot_clusters' AND column_name = 'area_name') THEN
        ALTER TABLE hotspot_clusters ADD COLUMN area_name TEXT;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'hotspot_clusters' AND column_name = 'center_lat') THEN
        ALTER TABLE hotspot_clusters ADD COLUMN center_lat DECIMAL(10, 8);
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'hotspot_clusters' AND column_name = 'center_lng') THEN
        ALTER TABLE hotspot_clusters ADD COLUMN center_lng DECIMAL(11, 8);
    END IF;
END $$;

-- Add cluster_id to reports if missing
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'reports' AND column_name = 'cluster_id') THEN
        ALTER TABLE hotspot_clusters ADD COLUMN cluster_id UUID REFERENCES hotspot_clusters(id) ON DELETE SET NULL;
    END IF;
END $$;

-- Verify the table structure
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'hotspot_clusters'
ORDER BY ordinal_position;
