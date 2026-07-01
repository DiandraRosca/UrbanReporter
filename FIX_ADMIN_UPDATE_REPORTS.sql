-- FIX_ADMIN_UPDATE_REPORTS.sql
-- Run this ENTIRE script in Supabase SQL Editor (select all, then run)

-- Step 1: Drop existing update policies
DROP POLICY IF EXISTS "Users can update their own reports" ON reports;
DROP POLICY IF EXISTS "Admins can update any report" ON reports;
DROP POLICY IF EXISTS "Users can update own reports" ON reports;

-- Step 2: Create user update policy
CREATE POLICY "Users can update own reports" ON reports 
FOR UPDATE TO authenticated 
USING (auth.uid() = user_id) 
WITH CHECK (auth.uid() = user_id);

-- Step 3: Create admin update policy with WITH CHECK
CREATE POLICY "Admins can update any report" ON reports 
FOR UPDATE TO authenticated 
USING (EXISTS (SELECT 1 FROM profiles WHERE profiles.id = auth.uid() AND profiles.is_admin = true)) 
WITH CHECK (EXISTS (SELECT 1 FROM profiles WHERE profiles.id = auth.uid() AND profiles.is_admin = true));

-- Step 4: Verify
SELECT policyname, cmd, qual IS NOT NULL as has_using, with_check IS NOT NULL as has_with_check 
FROM pg_policies WHERE tablename = 'reports' AND cmd = 'UPDATE';
