-- Add resolution_photo_urls column to reports table
-- Run this in your Supabase SQL Editor if the column doesn't exist

-- Check if column exists first, then add it
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'reports' AND column_name = 'resolution_photo_urls'
    ) THEN
        ALTER TABLE reports ADD COLUMN resolution_photo_urls TEXT[] DEFAULT '{}';
    END IF;
END $$;
