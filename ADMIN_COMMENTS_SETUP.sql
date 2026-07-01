-- Admin Comments/Notes for Reports
-- Run this in your Supabase SQL Editor

-- Report comments table (admin notes with optional photos)
CREATE TABLE IF NOT EXISTS report_comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    report_id UUID NOT NULL REFERENCES reports(id) ON DELETE CASCADE,
    admin_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    comment TEXT NOT NULL,
    photo_urls TEXT[] DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for faster queries
CREATE INDEX IF NOT EXISTS idx_report_comments_report_id ON report_comments(report_id);
CREATE INDEX IF NOT EXISTS idx_report_comments_created_at ON report_comments(created_at DESC);

-- Enable RLS
ALTER TABLE report_comments ENABLE ROW LEVEL SECURITY;

-- RLS Policies for report_comments

-- Anyone authenticated can view comments
CREATE POLICY "Anyone can view report comments"
    ON report_comments FOR SELECT
    TO authenticated
    USING (true);

-- Only admins can insert comments
CREATE POLICY "Admins can insert comments"
    ON report_comments FOR INSERT
    TO authenticated
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.is_admin = true
        )
    );

-- Only admins can update their own comments
CREATE POLICY "Admins can update their own comments"
    ON report_comments FOR UPDATE
    TO authenticated
    USING (
        admin_id = auth.uid() AND
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.is_admin = true
        )
    );

-- Only admins can delete their own comments
CREATE POLICY "Admins can delete their own comments"
    ON report_comments FOR DELETE
    TO authenticated
    USING (
        admin_id = auth.uid() AND
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.is_admin = true
        )
    );

-- Create storage bucket for admin comment photos (if not exists)
-- Note: Run this separately or via Supabase Dashboard
-- INSERT INTO storage.buckets (id, name, public) VALUES ('admin-photos', 'admin-photos', true)
-- ON CONFLICT (id) DO NOTHING;


-- =====================================================
-- Resolution Photos (photos added when marking resolved)
-- =====================================================

-- Add resolution_photo_urls column to reports table
ALTER TABLE reports ADD COLUMN IF NOT EXISTS resolution_photo_urls TEXT[] DEFAULT '{}';

-- Update RLS policy to allow admins to update resolution photos
-- (Already covered by existing "Admins can update any report" policy)
