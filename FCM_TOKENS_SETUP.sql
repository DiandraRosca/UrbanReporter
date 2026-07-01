-- =====================================================
-- FCM TOKENS TABLE FOR PUSH NOTIFICATIONS
-- Run this in Supabase SQL Editor
-- =====================================================

-- Create table to store FCM tokens
CREATE TABLE IF NOT EXISTS user_fcm_tokens (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
    fcm_token TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE user_fcm_tokens ENABLE ROW LEVEL SECURITY;

-- Users can manage their own tokens
CREATE POLICY "Users can insert own token"
    ON user_fcm_tokens FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own token"
    ON user_fcm_tokens FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own token"
    ON user_fcm_tokens FOR DELETE
    USING (auth.uid() = user_id);

-- Admins can read all tokens (needed for sending notifications)
CREATE POLICY "Admins can read all tokens"
    ON user_fcm_tokens FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE profiles.id = auth.uid() 
            AND profiles.is_admin = true
        )
    );

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_user_fcm_tokens_user_id ON user_fcm_tokens(user_id);

-- Verify table was created
SELECT 'user_fcm_tokens table created successfully!' as status;
