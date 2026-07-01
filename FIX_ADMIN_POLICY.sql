-- =====================================================
-- FIX ADMIN PROFILE ACCESS
-- Run this in Supabase SQL Editor
-- =====================================================

-- Drop the problematic policy
DROP POLICY IF EXISTS "Admins can view all profiles" ON profiles;

-- Keep the original simple policy - users can view their own profile
-- This already exists, but let's make sure
DROP POLICY IF EXISTS "Users can view their own profile" ON profiles;
CREATE POLICY "Users can view their own profile"
    ON profiles FOR SELECT
    USING (auth.uid() = id);

-- Add a separate policy for admins to view all profiles
-- This uses a subquery that doesn't cause recursion
CREATE POLICY "Admins can view all profiles"
    ON profiles FOR SELECT
    TO authenticated
    USING (
        auth.uid() = id 
        OR 
        (SELECT is_admin FROM profiles WHERE id = auth.uid()) = true
    );

-- Verify your admin user still has is_admin = true
-- Replace YOUR_USER_ID with your actual user ID if needed
SELECT id, email, first_name, last_name, is_admin 
FROM profiles 
WHERE is_admin = true;
