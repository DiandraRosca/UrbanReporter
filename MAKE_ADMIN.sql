-- =====================================================
-- MAKE USER AN ADMIN
-- Run this in Supabase SQL Editor (https://supabase.com/dashboard)
-- =====================================================

-- Option 1: Make admin by email
-- Replace 'your-email@example.com' with the actual email
UPDATE profiles 
SET is_admin = true 
WHERE email = 'your-email@example.com';

-- Option 2: Make admin by user ID (if you know it)
-- UPDATE profiles SET is_admin = true WHERE id = 'user-uuid-here';

-- Verify the change
SELECT id, email, full_name, is_admin, created_at 
FROM profiles 
WHERE is_admin = true;

-- =====================================================
-- VIEW ALL USERS (to find the right one)
-- =====================================================
SELECT id, email, full_name, is_admin, created_at 
FROM profiles 
ORDER BY created_at DESC;
