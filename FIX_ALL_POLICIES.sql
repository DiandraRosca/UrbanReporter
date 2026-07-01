-- FIX_ALL_POLICIES.sql
-- Run this ENTIRE script in Supabase SQL Editor to fix all RLS policies

-- ============================================
-- STEP 1: Check current policies
-- ============================================
SELECT tablename, policyname, cmd, roles 
FROM pg_policies 
WHERE schemaname = 'public' 
ORDER BY tablename, cmd;

-- ============================================
-- STEP 2: Fix PROFILES policies
-- ============================================
-- Drop all existing profiles policies
DROP POLICY IF EXISTS "profiles_select_policy" ON profiles;
DROP POLICY IF EXISTS "profiles_select_all" ON profiles;
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Users can view their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can view own profile or admins can view all" ON profiles;
DROP POLICY IF EXISTS "Admins can view all profiles" ON profiles;
DROP POLICY IF EXISTS "profiles_update_policy" ON profiles;
DROP POLICY IF EXISTS "profiles_update_own" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON profiles;
DROP POLICY IF EXISTS "profiles_insert_policy" ON profiles;
DROP POLICY IF EXISTS "profiles_insert_own" ON profiles;
DROP POLICY IF EXISTS "Users can insert their own profile" ON profiles;

-- Create simple profiles policies
-- ALL authenticated users can read ALL profiles (needed for joins)
CREATE POLICY "profiles_select_all" ON profiles
FOR SELECT TO authenticated
USING (true);

-- Users can only update their own profile
CREATE POLICY "profiles_update_own" ON profiles
FOR UPDATE TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- Users can insert their own profile (for registration)
CREATE POLICY "profiles_insert_own" ON profiles
FOR INSERT TO authenticated
WITH CHECK (id = auth.uid());

-- ============================================
-- STEP 3: Fix REPORTS policies
-- ============================================
-- Drop all existing reports policies
DROP POLICY IF EXISTS "Anyone can view all reports" ON reports;
DROP POLICY IF EXISTS "Users can view all reports" ON reports;
DROP POLICY IF EXISTS "Users can create their own reports" ON reports;
DROP POLICY IF EXISTS "Users can update their own reports" ON reports;
DROP POLICY IF EXISTS "Users can update own reports" ON reports;
DROP POLICY IF EXISTS "Admins can update any report" ON reports;
DROP POLICY IF EXISTS "Admins can delete any report" ON reports;
DROP POLICY IF EXISTS "Users can delete their own submitted reports" ON reports;

-- SELECT: All authenticated users can view all reports
CREATE POLICY "reports_select_all" ON reports
FOR SELECT TO authenticated
USING (true);

-- INSERT: Users can create their own reports
CREATE POLICY "reports_insert_own" ON reports
FOR INSERT TO authenticated
WITH CHECK (auth.uid() = user_id);

-- UPDATE: Users can update their own reports
CREATE POLICY "reports_update_own" ON reports
FOR UPDATE TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- UPDATE: Admins can update any report
CREATE POLICY "reports_update_admin" ON reports
FOR UPDATE TO authenticated
USING (EXISTS (SELECT 1 FROM profiles WHERE profiles.id = auth.uid() AND profiles.is_admin = true))
WITH CHECK (EXISTS (SELECT 1 FROM profiles WHERE profiles.id = auth.uid() AND profiles.is_admin = true));

-- DELETE: Users can delete their own submitted reports
CREATE POLICY "reports_delete_own" ON reports
FOR DELETE TO authenticated
USING (auth.uid() = user_id AND status = 'submitted');

-- DELETE: Admins can delete any report
CREATE POLICY "reports_delete_admin" ON reports
FOR DELETE TO authenticated
USING (EXISTS (SELECT 1 FROM profiles WHERE profiles.id = auth.uid() AND profiles.is_admin = true));

-- ============================================
-- STEP 4: Verify all policies
-- ============================================
SELECT tablename, policyname, cmd, 
       qual IS NOT NULL as has_using, 
       with_check IS NOT NULL as has_with_check
FROM pg_policies 
WHERE schemaname = 'public' AND tablename IN ('profiles', 'reports')
ORDER BY tablename, cmd, policyname;
