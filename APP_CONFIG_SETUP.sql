-- App Config Table for Version Management
-- Run this in your Supabase SQL Editor

-- Create app_config table
CREATE TABLE IF NOT EXISTS app_config (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    key TEXT UNIQUE NOT NULL,
    value TEXT NOT NULL,
    download_url TEXT,
    release_notes TEXT,
    force_update BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE app_config ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read app_config (needed for update checks)
CREATE POLICY "Anyone can read app_config"
    ON app_config FOR SELECT
    USING (true);

-- Only admins can modify app_config
CREATE POLICY "Admins can modify app_config"
    ON app_config FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.is_admin = true
        )
    );

-- Insert initial version record
INSERT INTO app_config (key, value, download_url, release_notes, force_update)
VALUES (
    'latest_version',
    '1.0.0',
    'https://github.com/andreitechro/urbanism-release/releases/download/v1.0.0/app-release.apk',
    'Prima versiune a aplicației',
    false
)
ON CONFLICT (key) DO NOTHING;

-- Function to update timestamp
CREATE OR REPLACE FUNCTION update_app_config_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for auto-updating timestamp
DROP TRIGGER IF EXISTS app_config_updated_at ON app_config;
CREATE TRIGGER app_config_updated_at
    BEFORE UPDATE ON app_config
    FOR EACH ROW
    EXECUTE FUNCTION update_app_config_timestamp();

-- =====================================================
-- HOW TO USE:
-- =====================================================
-- When you release a new version:
-- 1. Build your APK: flutter build apk --release
-- 2. Create a new release on GitHub: https://github.com/andreitechro/urbanism-release/releases
-- 3. Upload app-release.apk to the release
-- 4. Update the app_config table:
--
-- UPDATE app_config 
-- SET 
--     value = '1.1.0',
--     download_url = 'https://github.com/andreitechro/urbanism-release/releases/download/v1.1.0/app-release.apk',
--     release_notes = 'Noutăți în versiunea 1.1.0:\n- Notificări îmbunătățite\n- Actualizări automate\n- Rezolvare bug-uri',
--     force_update = false
-- WHERE key = 'latest_version';
--
-- Set force_update = true if users MUST update (critical fix)
