# Push Notifications Setup Guide

## Overview
This guide explains how to set up push notifications for the Urban Reporter app.

## What's Already Done
1. ✅ Firebase project created
2. ✅ `google-services.json` added to `android/app/`
3. ✅ Firebase dependencies added to Flutter
4. ✅ NotificationService created
5. ✅ FCM token storage in database

## What You Need To Do

### Step 1: Run the SQL in Supabase
Go to Supabase SQL Editor and run the contents of `FCM_TOKENS_SETUP.sql`

### Step 2: Get Firebase Service Account Key
1. Go to Firebase Console → Project Settings → Service Accounts
2. Click "Generate new private key"
3. Download the JSON file
4. Keep this file safe - you'll need it for Supabase

### Step 3: Deploy Supabase Edge Function (Optional - for server-side notifications)

If you want notifications to work when the app is closed, you need to deploy the Edge Function.

**Option A: Skip Edge Function (Simpler)**
For your faculty demo, you can skip this step. The app will still:
- Request notification permission
- Save FCM tokens to database
- Show local notifications when app is open

**Option B: Deploy Edge Function (Full notifications)**

1. Install Supabase CLI:
```bash
npm install -g supabase
```

2. Login to Supabase:
```bash
supabase login
```

3. Link your project:
```bash
cd urban_reporter
supabase link --project-ref vvutpdjavulhgdanlrsi
```

4. Set the Firebase service account as a secret:
```bash
supabase secrets set FIREBASE_SERVICE_ACCOUNT='<paste entire JSON content here>'
```

5. Deploy the function:
```bash
supabase functions deploy send-notification
```

## Testing Notifications

### Test 1: Local Notification (No Edge Function needed)
1. Build and install the app on your phone
2. Login to the app
3. The app will request notification permission - allow it
4. Check the console for "FCM Token: ..." message

### Test 2: Full Push Notification (Requires Edge Function)
1. Have two phones or one phone + emulator
2. Login as admin on one device
3. Login as regular user on another device
4. Create a report as the regular user
5. Admin should receive a notification

## Troubleshooting

### "No tokens found" error
- Make sure the user has logged in at least once
- Check that notification permission was granted
- Verify the `user_fcm_tokens` table has entries

### Notifications not showing
- Check that the app has notification permission in Android settings
- Make sure the notification channel is created
- Try restarting the app

## For Faculty Demo

For a simple demo without Edge Functions:
1. Just run the SQL to create the tokens table
2. Build the APK
3. Show that the app requests notification permission
4. Show the FCM token being saved in the database
5. Explain that with Edge Functions deployed, real push notifications would work

This demonstrates the architecture even if the full server-side sending isn't set up.
