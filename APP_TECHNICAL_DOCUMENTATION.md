# Urban Reporter - Technical Documentation

## Complete Application Overview

Urban Reporter is a cross-platform mobile application for reporting urban issues (potholes, broken streetlights, waste, abandoned vehicles) to local authorities. Built with Flutter and Supabase.

---

## Table of Contents

1. [Technology Stack](#technology-stack)
2. [Project Structure](#project-structure)
3. [Supabase Configuration](#supabase-configuration)
4. [Database Schema](#database-schema)
5. [Authentication System](#authentication-system)
6. [Services Architecture](#services-architecture)
7. [Push Notifications](#push-notifications)
8. [Storage Buckets](#storage-buckets)
9. [Row Level Security (RLS)](#row-level-security-rls)
10. [App Features](#app-features)
11. [Configuration Keys](#configuration-keys)
12. [Deployment](#deployment)

---

## Technology Stack

### Frontend
| Technology | Version | Purpose |
|------------|---------|---------|
| Flutter | 3.x | Cross-platform UI framework |
| Dart | >=3.0.0 <4.0.0 | Programming language |
| Provider | 6.1.1 | State management |

### Backend
| Technology | Purpose |
|------------|---------|
| Supabase | Backend-as-a-Service (PostgreSQL, Auth, Storage, Edge Functions) |
| Firebase | Push notifications (FCM) |

### Key Flutter Packages
```yaml
# Backend
supabase_flutter: ^2.3.0

# Maps & Location
flutter_map: ^6.1.0
flutter_map_marker_cluster: ^1.3.6
latlong2: ^0.9.0
geolocator: ^11.0.0
geocoding: ^2.1.1

# Firebase & Notifications
firebase_core: ^3.1.0
firebase_messaging: ^15.0.2
flutter_local_notifications: ^18.0.1

# UI
cached_network_image: ^3.3.1
fl_chart: ^0.66.0
image_picker: ^1.0.7

# Utils
provider: ^6.1.1
shared_preferences: ^2.2.2
url_launcher: ^6.2.4
share_plus: ^7.2.2
package_info_plus: ^8.0.0
```

---

## Project Structure

```
urban_reporter/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── firebase_options.dart        # Firebase configuration (auto-generated)
│   │
│   ├── config/
│   │   ├── app_theme.dart           # Theme colors and styles
│   │   └── supabase_config.dart     # Supabase URL and keys
│   │
│   ├── models/
│   │   ├── report.dart              # Report model with categories/status
│   │   ├── user_profile.dart        # User profile model
│   │   ├── cluster.dart             # Hotspot cluster model
│   │   └── report_comment.dart      # Admin comment model
│   │
│   ├── services/
│   │   ├── auth_service.dart        # Authentication logic
│   │   ├── report_service.dart      # Report CRUD operations
│   │   ├── cluster_service.dart     # Hotspot clustering algorithm
│   │   ├── comment_service.dart     # Admin comments/notes
│   │   ├── notification_service.dart # Push notifications
│   │   ├── localization_service.dart # Romanian/English translations
│   │   ├── location_service.dart    # GPS and geocoding
│   │   ├── theme_service.dart       # Dark/light mode
│   │   ├── update_service.dart      # In-app update checker
│   │   └── error_service.dart       # Error message handling
│   │
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   ├── forgot_password_screen.dart
│   │   │   └── reset_password_screen.dart
│   │   ├── home/
│   │   │   └── home_screen.dart     # Main navigation container
│   │   ├── map/
│   │   │   └── map_screen.dart      # Interactive map with markers
│   │   ├── report/
│   │   │   ├── create_report_screen.dart
│   │   │   ├── report_detail_screen.dart
│   │   │   ├── my_reports_screen.dart
│   │   │   └── photo_gallery_screen.dart
│   │   ├── admin/
│   │   │   └── admin_dashboard_screen.dart
│   │   ├── profile/
│   │   │   └── profile_screen.dart
│   │   └── onboarding/
│   │       └── onboarding_screen.dart
│   │
│   └── widgets/
│       └── skeleton_loader.dart     # Loading placeholder
│
├── android/
│   └── app/
│       ├── build.gradle             # Android build config
│       ├── google-services.json     # Firebase config
│       └── src/main/
│           ├── AndroidManifest.xml
│           └── res/                 # Icons and resources
│
├── supabase/
│   ├── migrations/
│   │   └── 001_initial_schema.sql   # Database schema
│   └── functions/
│       └── send-notification/
│           └── index.ts             # Edge function for FCM
│
└── pubspec.yaml                     # Dependencies
```

---

## Supabase Configuration

### Connection Details
```dart
// lib/config/supabase_config.dart
class SupabaseConfig {
  static const String url = 'https://vvutpdjavulhgdanlrsi.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
  
  static const String photoBucket = 'report-photos';
  static const String adminPhotoBucket = 'admin-photos';
}
```

### Supabase Project Details
| Setting | Value |
|---------|-------|
| Project URL | `https://vvutpdjavulhgdanlrsi.supabase.co` |
| Project Reference | `vvutpdjavulhgdanlrsi` |
| Region | (Check Supabase Dashboard) |
| Anon Key | Public key for client-side access |

### How to Find Your Keys
1. Go to Supabase Dashboard → Project Settings → API
2. **URL**: Project URL
3. **anon key**: Under "Project API keys" → anon/public
4. **service_role key**: Under "Project API keys" → service_role (NEVER expose in client code)

---

## Database Schema

### Tables Overview

| Table | Purpose |
|-------|---------|
| `profiles` | User profiles (extends auth.users) |
| `reports` | Urban issue reports |
| `status_history` | Report status change log |
| `hotspot_clusters` | GPS-based report clusters |
| `report_comments` | Admin notes on reports |
| `user_fcm_tokens` | Push notification tokens |
| `app_config` | App configuration (version, etc.) |

### Table: `profiles`
```sql
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    full_name TEXT,
    first_name TEXT,
    last_name TEXT,
    phone TEXT,
    is_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key, links to auth.users |
| email | TEXT | User's email address |
| full_name | TEXT | Display name (legacy) |
| first_name | TEXT | First name |
| last_name | TEXT | Last name |
| phone | TEXT | Phone number (optional) |
| is_admin | BOOLEAN | Admin privileges flag |
| created_at | TIMESTAMPTZ | Account creation date |

### Table: `reports`
```sql
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
    resolution_photo_urls TEXT[] DEFAULT '{}',
    cluster_id UUID REFERENCES hotspot_clusters(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| user_id | UUID | Reporter's user ID |
| category | TEXT | Issue type (pothole, lighting, waste, abandonedVehicle, other) |
| description | TEXT | Problem description |
| latitude | DECIMAL | GPS latitude |
| longitude | DECIMAL | GPS longitude |
| address | TEXT | Reverse-geocoded address |
| status | TEXT | Current status (submitted, inProgress, resolved) |
| photo_urls | TEXT[] | Array of photo URLs |
| resolution_photo_urls | TEXT[] | Photos added when resolved |
| cluster_id | UUID | Associated hotspot cluster |
| created_at | TIMESTAMPTZ | Report creation time |
| updated_at | TIMESTAMPTZ | Last update time |

### Table: `status_history`
```sql
CREATE TABLE status_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    report_id UUID NOT NULL REFERENCES reports(id) ON DELETE CASCADE,
    old_status TEXT,
    new_status TEXT NOT NULL,
    changed_by UUID REFERENCES profiles(id),
    changed_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Table: `hotspot_clusters`
```sql
CREATE TABLE hotspot_clusters (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    center_lat DECIMAL(10, 8) NOT NULL,
    center_lng DECIMAL(11, 8) NOT NULL,
    area_name TEXT,
    priority INTEGER DEFAULT 0,
    total_reports INTEGER DEFAULT 0,
    unresolved_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Table: `report_comments`
```sql
CREATE TABLE report_comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    report_id UUID NOT NULL REFERENCES reports(id) ON DELETE CASCADE,
    admin_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    comment TEXT NOT NULL,
    photo_urls TEXT[] DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Table: `user_fcm_tokens`
```sql
CREATE TABLE user_fcm_tokens (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
    fcm_token TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Table: `app_config`
```sql
CREATE TABLE app_config (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    key TEXT UNIQUE NOT NULL,
    value TEXT NOT NULL,
    download_url TEXT,
    release_notes TEXT,
    force_update BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert version config
INSERT INTO app_config (key, value, download_url, release_notes, force_update)
VALUES ('latest_version', '1.0.8', 'https://your-download-url.com/app.apk', 'Bug fixes', false);
```

### Database Indexes
```sql
CREATE INDEX idx_reports_user_id ON reports(user_id);
CREATE INDEX idx_reports_status ON reports(status);
CREATE INDEX idx_reports_category ON reports(category);
CREATE INDEX idx_reports_created_at ON reports(created_at DESC);
CREATE INDEX idx_reports_location ON reports(latitude, longitude);
CREATE INDEX idx_reports_cluster_id ON reports(cluster_id);
CREATE INDEX idx_hotspot_clusters_priority ON hotspot_clusters(priority DESC);
CREATE INDEX idx_report_comments_report_id ON report_comments(report_id);
CREATE INDEX idx_user_fcm_tokens_user_id ON user_fcm_tokens(user_id);
```

### Database Triggers
```sql
-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$ LANGUAGE plpgsql;

CREATE TRIGGER reports_updated_at
    BEFORE UPDATE ON reports
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

-- Log status changes
CREATE OR REPLACE FUNCTION log_status_change()
RETURNS TRIGGER AS $
BEGIN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
        INSERT INTO status_history (report_id, old_status, new_status, changed_by)
        VALUES (NEW.id, OLD.status, NEW.status, auth.uid());
    END IF;
    RETURN NEW;
END;
$ LANGUAGE plpgsql;

CREATE TRIGGER reports_status_change
    AFTER UPDATE ON reports
    FOR EACH ROW
    EXECUTE FUNCTION log_status_change();
```

---

## Authentication System

### Flow
1. User registers with email/password
2. Supabase sends confirmation email
3. User clicks link to verify email
4. Profile is created via database trigger
5. User can now log in

### Profile Creation Trigger
```sql
-- Automatically create profile when user signs up
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $
BEGIN
    INSERT INTO public.profiles (id, email, first_name, last_name, phone)
    VALUES (
        NEW.id,
        NEW.email,
        NEW.raw_user_meta_data->>'first_name',
        NEW.raw_user_meta_data->>'last_name',
        NEW.raw_user_meta_data->>'phone'
    );
    RETURN NEW;
END;
$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();
```

### Password Reset
- Uses Supabase's built-in password reset
- Deep link: `urbanreporter://auth/reset`
- Configured in Supabase Dashboard → Authentication → URL Configuration

---

## Services Architecture

### AuthService
Handles user authentication state.
```dart
class AuthService extends ChangeNotifier {
  User? get user;
  UserProfile? get profile;
  bool get isAuthenticated;
  bool get isAdmin;
  
  Future<String?> signUp({...});
  Future<String?> signIn({...});
  Future<void> signOut();
  Future<String?> resetPassword(String email);
}
```

### ReportService
Manages report CRUD operations.
```dart
class ReportService extends ChangeNotifier {
  List<Report> get reports;        // All reports
  List<Report> get userReports;    // Current user's reports
  
  Future<void> loadReports();
  Future<void> loadUserReports(String userId);
  Future<String?> createReport({...});
  Future<String?> updateReportStatus(String id, ReportStatus status);
  Future<String?> deleteReport(String id);
  Future<Map<String, dynamic>> getStatistics();
}
```

### ClusterService
GPS-based clustering algorithm (150m radius).
```dart
class ClusterService extends ChangeNotifier {
  List<HotspotCluster> get clusters;
  
  Future<void> loadClusters();
  Future<String?> recalculateClusters(List<Report> reports);
}
```

### NotificationService
Push notifications via Firebase Cloud Messaging.
```dart
class NotificationService {
  Future<void> initialize();
  Future<void> saveTokenForUser(String userId);
  Future<void> notifyAdminsNewReport({...});
  Future<void> notifyUserStatusChange({...});
}
```

### LocalizationService
Romanian/English translations.
```dart
class LocalizationService extends ChangeNotifier {
  String get currentLanguage;  // 'ro' or 'en'
  bool get isRomanian;
  
  String get(String key);
  Future<void> toggleLanguage();
}
```

### ThemeService
Dark/light mode toggle.
```dart
class ThemeService extends ChangeNotifier {
  bool get isDarkMode;
  Future<void> toggleTheme();
}
```

---

## Push Notifications

### Setup Requirements
1. Firebase project with Cloud Messaging enabled
2. `google-services.json` in `android/app/`
3. Firebase service account JSON in Supabase secrets
4. Edge function deployed

### Firebase Configuration
1. Go to Firebase Console → Project Settings
2. Download `google-services.json` for Android
3. For Edge Function: Project Settings → Service Accounts → Generate new private key

### Supabase Edge Function
Location: `supabase/functions/send-notification/index.ts`

Deploy command:
```bash
supabase functions deploy send-notification --no-verify-jwt
```

Set Firebase secret:
```bash
supabase secrets set FIREBASE_SERVICE_ACCOUNT='{"type":"service_account",...}'
```

### Notification Types
| Type | Trigger | Recipients |
|------|---------|------------|
| new_report | User creates report | All admins |
| status_change | Admin changes status | Report owner |

---

## Storage Buckets

### Bucket: `report-photos`
- **Purpose**: User-uploaded photos for reports
- **Access**: Public read, authenticated write
- **Path format**: `{user_id}/{report_id}/{photo_id}.jpg`

### Bucket: `admin-photos`
- **Purpose**: Admin resolution photos and comment photos
- **Access**: Public read, admin write
- **Path format**: `resolution/{report_id}/{photo_id}.jpg` or `{admin_id}/{report_id}/{comment_id}/{photo_id}.jpg`

### Storage Policies
```sql
-- report-photos bucket
CREATE POLICY "Public read" ON storage.objects FOR SELECT USING (bucket_id = 'report-photos');
CREATE POLICY "Auth upload" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'report-photos' AND auth.role() = 'authenticated');
CREATE POLICY "Owner delete" ON storage.objects FOR DELETE USING (bucket_id = 'report-photos' AND auth.uid()::text = (storage.foldername(name))[1]);

-- admin-photos bucket
CREATE POLICY "Public read" ON storage.objects FOR SELECT USING (bucket_id = 'admin-photos');
CREATE POLICY "Admin upload" ON storage.objects FOR INSERT WITH CHECK (
    bucket_id = 'admin-photos' AND 
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true)
);
```

---

## Row Level Security (RLS)

### Profiles Table
```sql
-- All authenticated users can read all profiles
CREATE POLICY "profiles_select_all" ON profiles
FOR SELECT TO authenticated USING (true);

-- Users can only update their own profile
CREATE POLICY "profiles_update_own" ON profiles
FOR UPDATE TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());
```

### Reports Table
```sql
-- Anyone authenticated can view all reports
CREATE POLICY "Anyone can view all reports" ON reports
FOR SELECT TO authenticated USING (true);

-- Users can create their own reports
CREATE POLICY "Users can create their own reports" ON reports
FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

-- Users can update their own reports
CREATE POLICY "Users can update their own reports" ON reports
FOR UPDATE TO authenticated USING (auth.uid() = user_id);

-- Admins can update any report
CREATE POLICY "Admins can update any report" ON reports
FOR UPDATE TO authenticated USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true)
);

-- Users can delete their own submitted reports, admins can delete any
CREATE POLICY "Delete own submitted or admin" ON reports
FOR DELETE TO authenticated USING (
    (auth.uid() = user_id AND status = 'submitted') OR
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = true)
);
```

---

## App Features

### User Features
- ✅ Email registration with verification
- ✅ Password reset via email
- ✅ Report urban issues with photos
- ✅ GPS location capture
- ✅ View reports on interactive map
- ✅ Track own report status
- ✅ Pull-to-refresh on all screens
- ✅ Share reports
- ✅ Navigate to report location (Google Maps)
- ✅ Dark/light theme
- ✅ Romanian/English language

### Admin Features
- ✅ Dashboard with statistics
- ✅ View all reports
- ✅ Change report status
- ✅ Add resolution photos
- ✅ Add notes/comments to reports
- ✅ View hotspot clusters
- ✅ Recalculate clusters
- ✅ Export reports (CSV/PDF)
- ✅ Delete any report

### Report Categories
| Category | Icon | Color |
|----------|------|-------|
| Pothole | 🚧 | Orange |
| Lighting | 💡 | Yellow |
| Waste | 🗑️ | Green |
| Abandoned Vehicle | 🚙 | Blue |
| Other | 📋 | Purple |

### Report Statuses
| Status | Color | Description |
|--------|-------|-------------|
| Submitted | Orange | New report |
| In Progress | Blue | Being worked on |
| Resolved | Green | Issue fixed |

---

## Configuration Keys

### Android Package
- **Package name**: `com.urbanreporter.app`
- **Min SDK**: Flutter default (21)
- **Target SDK**: 36
- **Compile SDK**: 36

### Deep Links
- **Scheme**: `urbanreporter`
- **Host**: `auth`
- **Full URL**: `urbanreporter://auth/callback`

### SharedPreferences Keys
| Key | Type | Purpose |
|-----|------|---------|
| `app_language` | String | Current language ('ro' or 'en') |
| `isDarkMode` | bool | Theme preference |
| `onboarding_complete` | bool | First-time user flag |
| `skipped_update_version` | String | Version user chose to skip |

---

## Deployment

### Build Commands
```bash
# Clean build
cd urban_reporter
flutter clean
flutter pub get

# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

### Output Locations
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

### Version Management
Update in `pubspec.yaml`:
```yaml
version: 1.0.8+9  # format: major.minor.patch+buildNumber
```

### Supabase Edge Functions
```bash
# Login to Supabase CLI
supabase login

# Link to project
supabase link --project-ref vvutpdjavulhgdanlrsi

# Deploy function
supabase functions deploy send-notification --no-verify-jwt

# Set secrets
supabase secrets set FIREBASE_SERVICE_ACCOUNT='...'
```

---

## SQL Files Reference

| File | Purpose |
|------|---------|
| `001_initial_schema.sql` | Base tables (profiles, reports, status_history) |
| `HOTSPOT_CLUSTERS_SETUP.sql` | Hotspot clusters table and policies |
| `FCM_TOKENS_SETUP.sql` | Push notification tokens table |
| `ADMIN_COMMENTS_SETUP.sql` | Admin comments table |
| `ADD_RESOLUTION_PHOTOS_COLUMN.sql` | Resolution photos column |
| `FIX_RLS_SIMPLE.sql` | Fix profile access policies |
| `APP_CONFIG_SETUP.sql` | App version config table |
| `MAKE_ADMIN.sql` | Make user an admin |

---

## Making a User Admin

```sql
UPDATE profiles 
SET is_admin = true 
WHERE id = 'USER_UUID_HERE';

-- Or by email
UPDATE profiles 
SET is_admin = true 
WHERE email = 'admin@example.com';
```

---

## Troubleshooting

### Admin Dashboard Not Showing
1. Check if user has `is_admin = true` in profiles table
2. Run `FIX_RLS_SIMPLE.sql` to fix policies
3. Log out and log back in

### Photos Not Uploading
1. Check storage bucket exists
2. Verify storage policies are set
3. Check bucket is set to public

### Notifications Not Working
1. Verify Firebase service account is set in Supabase secrets
2. Check Edge Function logs in Supabase Dashboard
3. Ensure FCM token is saved for user

### Reports Not Loading
1. Check RLS policies on reports table
2. Verify user is authenticated
3. Check Supabase logs for errors

---

## Contact & Support

This application was developed as a faculty project for urban issue reporting.

**Current Version**: 1.0.10+11
**Last Updated**: January 2026
