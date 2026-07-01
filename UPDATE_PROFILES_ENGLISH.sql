-- =====================================================
-- UPDATE PROFILES TABLE - ENGLISH COLUMN NAMES
-- Run this in Supabase SQL Editor
-- =====================================================

-- First, check what columns exist and rename if needed
DO $$
BEGIN
    -- Rename 'nume' to 'last_name' if it exists
    IF EXISTS (SELECT 1 FROM information_schema.columns 
               WHERE table_name = 'profiles' AND column_name = 'nume') THEN
        ALTER TABLE profiles RENAME COLUMN nume TO last_name;
    END IF;
    
    -- Rename 'prenume' to 'first_name' if it exists
    IF EXISTS (SELECT 1 FROM information_schema.columns 
               WHERE table_name = 'profiles' AND column_name = 'prenume') THEN
        ALTER TABLE profiles RENAME COLUMN prenume TO first_name;
    END IF;
END $$;

-- Add columns if they don't exist
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS first_name TEXT;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS last_name TEXT;

-- Drop full_name column if it exists
ALTER TABLE profiles DROP COLUMN IF EXISTS full_name;

-- Update the trigger function with English column names
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email, first_name, last_name, phone, is_admin, created_at)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'first_name', ''),
        COALESCE(NEW.raw_user_meta_data->>'last_name', ''),
        NEW.raw_user_meta_data->>'phone',
        FALSE,
        NOW()
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Recreate the trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Verify columns
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'profiles' 
ORDER BY ordinal_position;
