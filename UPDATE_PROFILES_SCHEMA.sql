-- =====================================================
-- UPDATE PROFILES TABLE FOR ROMANIAN FIELDS
-- Run this in Supabase SQL Editor
-- =====================================================

-- Add new columns if they don't exist
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS nume TEXT,
ADD COLUMN IF NOT EXISTS prenume TEXT;

-- Remove old full_name column if it exists (optional - keep for backward compatibility)
-- ALTER TABLE profiles DROP COLUMN IF EXISTS full_name;

-- Update the trigger function to handle new fields
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email, nume, prenume, phone, is_admin, created_at)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'nume', ''),
        COALESCE(NEW.raw_user_meta_data->>'prenume', ''),
        NEW.raw_user_meta_data->>'phone',
        FALSE,
        NOW()
    )
    ON CONFLICT (id) DO UPDATE SET
        email = EXCLUDED.email,
        nume = COALESCE(EXCLUDED.nume, profiles.nume),
        prenume = COALESCE(EXCLUDED.prenume, profiles.prenume),
        phone = COALESCE(EXCLUDED.phone, profiles.phone);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Make sure the trigger exists
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- =====================================================
-- CONFIGURE EMAIL CONFIRMATION (10 minutes expiry)
-- This needs to be done in Supabase Dashboard:
-- 1. Go to Authentication > Email Templates
-- 2. Set "Confirm signup" email expiry to 600 seconds (10 minutes)
-- 
-- Or via SQL (if you have access):
-- UPDATE auth.config SET value = '600' WHERE key = 'mailer_otp_exp';
-- =====================================================

-- Verify the changes
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'profiles' 
ORDER BY ordinal_position;
