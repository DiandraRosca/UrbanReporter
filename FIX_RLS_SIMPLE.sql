-- FIX_RLS_SIMPLE.sql
-- Run this in Supabase SQL Editor to fix profile access

-- Step 1: Drop ALL existing policies on profiles table
DROP POLICY IF EXISTS "profiles_select_policy" ON profiles;
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Users can view own profile or admins can view all" ON profiles;
DROP POLICY IF EXISTS "Admins can view all profiles" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "profiles_update_policy" ON profiles;
DROP POLICY IF EXISTS "profiles_insert_policy" ON profiles;

-- Step 2: Create simple policies that work

-- Allow ALL authenticated users to read ALL profiles
-- This is needed because:
-- 1. Users need to read their own profile to check isAdmin
-- 2. Admins need to see reporter names in reports
-- 3. Report service joins with profiles to show names
CREATE POLICY "profiles_select_all" ON profiles
FOR SELECT TO authenticated
USING (true);

-- Allow users to update only their own profile
CREATE POLICY "profiles_update_own" ON profiles
FOR UPDATE TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- Allow insert for new users (triggered by auth signup)
CREATE POLICY "profiles_insert_own" ON profiles
FOR INSERT TO authenticated
WITH CHECK (id = auth.uid());

-- Step 3: Verify the admin user has is_admin = true
-- Replace with your admin user ID
UPDATE profiles 
SET is_admin = true 
WHERE id = '54b52117-1cbf-4425-9692-d2e41edaeb72';

-- Step 4: Verify the fix worked
SELECT id, full_name, is_admin FROM profiles WHERE id = '54b52117-1cbf-4425-9692-d2e41edaeb72';
