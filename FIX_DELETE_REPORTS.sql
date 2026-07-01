-- Fix DELETE policies for reports table
-- Run this in your Supabase SQL Editor

-- Allow users to delete their own reports (only if status is 'submitted')
CREATE POLICY "Users can delete their own submitted reports"
    ON reports FOR DELETE
    TO authenticated
    USING (
        auth.uid() = user_id 
        AND status = 'submitted'
    );

-- Allow admins to delete any report
CREATE POLICY "Admins can delete any report"
    ON reports FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.is_admin = true
        )
    );

-- Also add storage policies for deleting photos
-- This allows users to delete their own photos and admins to delete any photos

-- For report-photos bucket (user photos)
-- Note: You may need to run these in the Supabase Dashboard > Storage > Policies

-- DELETE policy for report-photos bucket:
-- CREATE POLICY "Users can delete own photos"
-- ON storage.objects FOR DELETE
-- TO authenticated
-- USING (
--     bucket_id = 'report-photos' 
--     AND (storage.foldername(name))[1] = auth.uid()::text
-- );

-- CREATE POLICY "Admins can delete any photos"
-- ON storage.objects FOR DELETE
-- TO authenticated
-- USING (
--     bucket_id = 'report-photos'
--     AND EXISTS (
--         SELECT 1 FROM profiles
--         WHERE profiles.id = auth.uid()
--         AND profiles.is_admin = true
--     )
-- );
