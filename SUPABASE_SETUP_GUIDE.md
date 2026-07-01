# Supabase Setup Guide - Urban Reporter

## Step 1: Run Database Migration

1. Go to https://supabase.com/dashboard
2. Open your project: `vvutpdjavulhgdanlrsi`
3. Click **SQL Editor** in left sidebar
4. Click **New query**
5. Copy and paste this entire SQL block:

```sql
-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Profiles table (extends auth.users)
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    full_name TEXT,
    phone TEXT,
    is_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Reports table
CREATE TABLE reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    category TEXT NOT NULL CHECK (category IN ('pothole', 'lighting', 'waste', 'abandonedVehicle', 'other')),
    description TEXT NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    address TEXT,
    status TEXT DEFAULT 'submitted' CHECK (status IN ('submitted', 'inProgress', 'resolved')),
    photo_urls TEXT[] DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Status history table
CREATE TABLE status_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    report_id UUID NOT NULL REFERENCES reports(id) ON DELETE CASCADE,
    old_status TEXT,
    new_status TEXT NOT NULL,
    changed_by UUID REFERENCES profiles(id),
    changed_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_reports_user_id ON reports(user_id);
CREATE INDEX idx_reports_status ON reports(status);
CREATE INDEX idx_reports_category ON reports(category);
CREATE INDEX idx_reports_created_at ON reports(created_at DESC);
CREATE INDEX idx_reports_location ON reports(latitude, longitude);

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE status_history ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can view their own profile"
    ON profiles FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
    ON profiles FOR UPDATE
    USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile"
    ON profiles FOR INSERT
    WITH CHECK (auth.uid() = id);

-- Reports policies
CREATE POLICY "Anyone can view all reports"
    ON reports FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Users can create their own reports"
    ON reports FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own reports"
    ON reports FOR UPDATE
    TO authenticated
    USING (auth.uid() = user_id);

CREATE POLICY "Admins can update any report"
    ON reports FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.is_admin = true
        )
    );

-- Status history policies
CREATE POLICY "Anyone can view status history"
    ON status_history FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Authenticated users can insert status history"
    ON status_history FOR INSERT
    TO authenticated
    WITH CHECK (true);

-- Function to update updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for reports updated_at
CREATE TRIGGER reports_updated_at
    BEFORE UPDATE ON reports
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

-- Function to log status changes
CREATE OR REPLACE FUNCTION log_status_change()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
        INSERT INTO status_history (report_id, old_status, new_status, changed_by)
        VALUES (NEW.id, OLD.status, NEW.status, auth.uid());
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for status history
CREATE TRIGGER reports_status_change
    AFTER UPDATE ON reports
    FOR EACH ROW
    EXECUTE FUNCTION log_status_change();
```

6. Click **Run** (or press Ctrl+Enter)
7. You should see "Success. No rows returned"

---

## Step 2: Setup Storage Bucket

### A. Create the bucket (if not already created)
1. Go to **Storage** in left sidebar
2. Click **New bucket**
3. Name: `report-photos`
4. Make it **Public**
5. Click **Create bucket**

### B. Set up storage policies
1. Go back to **SQL Editor**
2. Click **New query**
3. Paste this SQL:

```sql
-- Allow authenticated users to upload photos
CREATE POLICY "Authenticated users can upload photos"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'report-photos'
    AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Allow anyone to view photos
CREATE POLICY "Anyone can view photos"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'report-photos');

-- Allow users to delete their own photos
CREATE POLICY "Users can delete their own photos"
ON storage.objects FOR DELETE
TO authenticated
USING (
    bucket_id = 'report-photos'
    AND (storage.foldername(name))[1] = auth.uid()::text
);
```

4. Click **Run**

---

## Step 3: Disable Email Confirmation (for testing)

1. Go to **Authentication** → **Providers**
2. Click on **Email**
3. Scroll down to find **"Confirm email"** toggle
4. Turn it **OFF**
5. Click **Save**

---

## Step 4: Test Registration

1. Go back to your app in Chrome
2. Click "Register"
3. Fill in:
   - Name: Test User
   - Email: test@example.com
   - Password: password123
4. Click "Create Account"

Should work now!

---

## Step 5: Create Admin User (Optional)

After registering a user, make them admin:

1. Go to **SQL Editor**
2. Run this (replace email with your test email):

```sql
UPDATE profiles SET is_admin = true WHERE email = 'test@example.com';
```

Now that user can access the Admin Dashboard in the app.

---

## Troubleshooting

**If registration still fails:**
- Check browser console (F12) for detailed error
- Make sure all SQL ran successfully (no red errors)
- Verify email confirmation is OFF
- Try a different email address

**If you see "profiles table doesn't exist":**
- Step 1 SQL didn't run successfully
- Go back and run it again

**If photos don't upload:**
- Make sure bucket is created and public
- Run Step 2B SQL again
