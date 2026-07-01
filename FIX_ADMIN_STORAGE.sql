-- Fix storage policies for admin-photos bucket
-- Run this in your Supabase SQL Editor
-- FIRST: Create the bucket in Supabase Dashboard > Storage > New Bucket
-- Bucket name: admin-photos
-- Public bucket: Yes

-- Allow admins to upload resolution photos
CREATE POLICY "Admins can upload resolution photos"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'admin-photos'
    AND EXISTS (
        SELECT 1 FROM profiles
        WHERE profiles.id = auth.uid()
        AND profiles.is_admin = true
    )
);

-- Allow anyone to view admin photos (public bucket)
CREATE POLICY "Anyone can view admin photos"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'admin-photos');

-- Allow admins to delete admin photos
CREATE POLICY "Admins can delete admin photos"
ON storage.objects FOR DELETE
TO authenticated
USING (
    bucket_id = 'admin-photos'
    AND EXISTS (
        SELECT 1 FROM profiles
        WHERE profiles.id = auth.uid()
        AND profiles.is_admin = true
    )
);

-- Also allow admins to delete user photos (for cleanup when deleting reports)
CREATE POLICY "Admins can delete any report photos"
ON storage.objects FOR DELETE
TO authenticated
USING (
    bucket_id = 'report-photos'
    AND EXISTS (
        SELECT 1 FROM profiles
        WHERE profiles.id = auth.uid()
        AND profiles.is_admin = true
    )
);
