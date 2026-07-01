# Urban Reporter - Frontend Documentation

This document provides comprehensive documentation of all frontend screens, their functions, user flows, and UI components.

---

## Table of Contents

1. [Application Structure](#application-structure)
2. [Authentication Screens](#authentication-screens)
3. [Main Application Screens](#main-application-screens)
4. [Report Management Screens](#report-management-screens)
5. [Admin Dashboard](#admin-dashboard)
6. [User Flows](#user-flows)
7. [State Management](#state-management)
8. [Localization](#localization)
9. [Theme System](#theme-system)

---

## Application Structure

### Screen Organization
```
lib/screens/
├── auth/
│   ├── login_screen.dart          # User login
│   ├── register_screen.dart       # User registration
│   ├── forgot_password_screen.dart # Password reset request
│   └── reset_password_screen.dart  # New password entry
├── home/
│   └── home_screen.dart           # Main navigation hub
├── onboarding/
│   └── onboarding_screen.dart     # First-time user tutorial
├── map/
│   └── map_screen.dart            # Interactive map view
├── report/
│   ├── create_report_screen.dart  # New report creation
│   ├── report_detail_screen.dart  # Report details view
│   ├── my_reports_screen.dart     # User's reports list
│   └── photo_gallery_screen.dart  # Full-screen photo viewer
├── admin/
│   └── admin_dashboard_screen.dart # Admin management panel
└── profile/
    └── profile_screen.dart        # User profile settings
```

---

## Authentication Screens

### LoginScreen (`login_screen.dart`)

**Purpose:** Entry point for existing users to authenticate.

**Key Functions:**
| Function | Description |
|----------|-------------|
| `_handleLogin()` | Validates form and calls `AuthService.signIn()` |
| `_buildLanguageToggle()` | Renders RO/EN language switch button |
| `_navigateToRegister()` | Opens registration screen |
| `_navigateToForgotPassword()` | Opens password reset screen |

**UI Components:**
- Email text field with validation
- Password field with visibility toggle
- "Remember me" checkbox
- Login button with loading state
- Language toggle (Romanian/English)
- Links to Register and Forgot Password

**Validation Rules:**
- Email: Required, valid email format
- Password: Required, minimum 6 characters

---

### RegisterScreen (`register_screen.dart`)

**Purpose:** New user account creation with email verification.

**Key Functions:**
| Function | Description |
|----------|-------------|
| `_handleRegister()` | Creates account via `AuthService.signUp()` |
| `_validateForm()` | Checks all fields meet requirements |
| `_showVerificationDialog()` | Displays email verification instructions |

**UI Components:**
- Full name text field
- Email text field
- Password field with strength indicator
- Confirm password field
- Terms acceptance checkbox
- Register button with loading state

**Validation Rules:**
- Full name: Required, 2-50 characters
- Email: Required, valid format, unique
- Password: Required, min 6 chars, must match confirmation
- Terms: Must be accepted

**Post-Registration Flow:**
1. Account created in Supabase Auth
2. Profile record created in `profiles` table
3. Verification email sent automatically
4. User shown dialog to check email
5. Redirected to login screen

---

### ForgotPasswordScreen (`forgot_password_screen.dart`)

**Purpose:** Initiate password reset via email.

**Key Functions:**
| Function | Description |
|----------|-------------|
| `_handleResetRequest()` | Sends reset email via `AuthService.resetPassword()` |
| `_showSuccessDialog()` | Confirms email was sent |

**UI Components:**
- Email input field
- Send reset link button
- Back to login link
- Success/error feedback

**Flow:**
1. User enters registered email
2. Supabase sends reset link
3. Link opens app via deep link
4. User redirected to ResetPasswordScreen

---

### ResetPasswordScreen (`reset_password_screen.dart`)

**Purpose:** Set new password after clicking reset link.

**Key Functions:**
| Function | Description |
|----------|-------------|
| `_handlePasswordReset()` | Updates password via `AuthService.updatePassword()` |
| `_validatePasswords()` | Ensures passwords match and meet requirements |

**UI Components:**
- New password field
- Confirm password field
- Reset button
- Password strength indicator

---

## Main Application Screens

### HomeScreen (`home_screen.dart`)

**Purpose:** Central navigation hub with bottom navigation bar.

**Navigation Tabs:**
| Index | Tab | Screen | Icon |
|-------|-----|--------|------|
| 0 | Map | MapScreen | `Icons.map` |
| 1 | My Reports | MyReportsScreen | `Icons.list_alt` |
| 2 | Create | CreateReportScreen | `Icons.add_circle` |
| 3 | Profile | ProfileScreen | `Icons.person` |

**Key Functions:**
| Function | Description |
|----------|-------------|
| `_onTabSelected(int index)` | Switches active tab |
| `_checkAdminStatus()` | Loads admin flag from profile |
| `_buildAdminFAB()` | Shows admin button if user is admin |

**Admin Access:**
- Floating action button appears for admin users
- Tapping opens AdminDashboardScreen
- Admin status checked on screen load

**State Management:**
- Uses `IndexedStack` to preserve tab states
- Current index stored in local state
- Profile data loaded from Supabase on init

---

### OnboardingScreen (`onboarding_screen.dart`)

**Purpose:** First-time user tutorial explaining app features.

**Pages:**
1. **Welcome** - App introduction and purpose
2. **Report Issues** - How to create reports
3. **Track Progress** - Following report status
4. **Community** - Contributing to city improvement

**Key Functions:**
| Function | Description |
|----------|-------------|
| `_nextPage()` | Advances to next tutorial page |
| `_skipOnboarding()` | Marks complete and goes to home |
| `_completeOnboarding()` | Saves flag and navigates to home |

**UI Components:**
- PageView with smooth transitions
- Page indicator dots
- Skip button (top right)
- Next/Get Started button

**Persistence:**
- Completion saved to SharedPreferences
- Key: `onboarding_complete`
- Checked on app startup in main.dart

---

### MapScreen (`map_screen.dart`)

**Purpose:** Interactive map displaying all reports with clustering.

**Key Functions:**
| Function | Description |
|----------|-------------|
| `_loadReports()` | Fetches all reports from Supabase |
| `_loadClusters()` | Loads hotspot cluster data |
| `_buildMarkers()` | Creates map markers from reports |
| `_onMarkerTap(Report)` | Opens report detail bottom sheet |
| `_centerOnUserLocation()` | Moves map to GPS position |
| `_filterByCategory(String)` | Shows only selected category |
| `_filterByStatus(String)` | Shows only selected status |

**Map Features:**
- OpenStreetMap tiles via flutter_map
- Marker clustering for dense areas
- Color-coded markers by status:
  - 🔴 Red: Submitted (new)
  - 🟡 Yellow: In Progress
  - 🟢 Green: Resolved
- Category icons on markers
- User location indicator

**Filters:**
- Category dropdown (All, Pothole, Lighting, etc.)
- Status dropdown (All, Submitted, In Progress, Resolved)
- Filters persist during session

**Bottom Sheet Preview:**
- Shows when marker tapped
- Displays: title, category, status, date
- "View Details" button opens full screen

**Hotspot Clusters:**
- Areas with many reports highlighted
- Cluster count displayed
- Helps identify problem areas

---

### ProfileScreen (`profile_screen.dart`)

**Purpose:** User settings, preferences, and account management.

**Sections:**

**1. Profile Header**
- User avatar (initials-based)
- Full name display
- Email display
- Edit profile button

**2. Settings**
| Setting | Description |
|---------|-------------|
| Language | Toggle Romanian/English |
| Theme | Light/Dark/System mode |
| Notifications | Enable/disable push notifications |

**3. Account Actions**
| Action | Function |
|--------|----------|
| Change Password | Opens password change dialog |
| Delete Account | Confirmation then account deletion |
| Logout | Signs out and returns to login |

**Key Functions:**
| Function | Description |
|----------|-------------|
| `_loadProfile()` | Fetches user data from Supabase |
| `_updateProfile()` | Saves profile changes |
| `_changeLanguage(String)` | Updates app locale |
| `_changeTheme(ThemeMode)` | Updates app theme |
| `_handleLogout()` | Signs out via AuthService |
| `_handleDeleteAccount()` | Deletes account after confirmation |

**Theme Options:**
- Light Mode
- Dark Mode  
- System (follows device setting)

---

## Report Management Screens

### CreateReportScreen (`create_report_screen.dart`)

**Purpose:** Multi-step form for submitting new urban issues.

**Form Steps:**

**Step 1: Category Selection**
- Grid of category cards
- Categories: Pothole, Street Lighting, Illegal Waste, Abandoned Vehicle, Other
- Visual icons for each

**Step 2: Location**
- Interactive map for pin placement
- "Use Current Location" button
- Address auto-detection via reverse geocoding
- Manual address entry option

**Step 3: Description**
- Title field (required)
- Description textarea (required)
- Character count indicator

**Step 4: Photos**
- Camera capture button
- Gallery selection button
- Photo preview grid
- Remove photo option
- Maximum 5 photos

**Step 5: Review & Submit**
- Summary of all entered data
- Edit buttons for each section
- Submit button

**Key Functions:**
| Function | Description |
|----------|-------------|
| `_nextStep()` | Validates current step and advances |
| `_previousStep()` | Returns to previous step |
| `_selectCategory(String)` | Sets report category |
| `_getCurrentLocation()` | Gets GPS coordinates |
| `_pickFromGallery()` | Opens image picker |
| `_takePhoto()` | Opens camera |
| `_removePhoto(int)` | Removes photo at index |
| `_submitReport()` | Uploads photos and creates report |

**Submission Process:**
1. Validate all required fields
2. Upload photos to Supabase Storage
3. Create report record with photo URLs
4. Show success dialog
5. Navigate to report detail

**Validation:**
- Category: Required
- Location: Required (lat/lng)
- Title: Required, 5-100 characters
- Description: Required, 20-1000 characters
- Photos: Optional, max 5, max 10MB each

---

### MyReportsScreen (`my_reports_screen.dart`)

**Purpose:** List of current user's submitted reports.

**Key Functions:**
| Function | Description |
|----------|-------------|
| `_loadReports()` | Fetches user's reports from Supabase |
| `_refreshReports()` | Pull-to-refresh handler |
| `_deleteReport(String)` | Deletes report after confirmation |
| `_filterReports(String)` | Filters by status |

**UI Components:**
- Pull-to-refresh ListView
- Report cards with:
  - Category icon and name
  - Title
  - Status badge (color-coded)
  - Date submitted
  - Photo thumbnail (if available)
- Empty state illustration
- Filter chips (All, Submitted, In Progress, Resolved)

**Report Card Actions:**
- Tap: Opens ReportDetailScreen
- Long press: Shows delete option (only for own reports)

**Sorting:**
- Default: Newest first
- Option to sort by status

---

### ReportDetailScreen (`report_detail_screen.dart`)

**Purpose:** Full details of a single report with status history.

**Sections:**

**1. Photo Gallery**
- Horizontal scrollable photos
- Tap to open full-screen gallery
- Photo count indicator

**2. Report Information**
| Field | Display |
|-------|---------|
| Category | Icon + name |
| Status | Colored badge |
| Created | Date and time |
| Location | Address + map preview |

**3. Description**
- Full report description text

**4. Status Timeline**
- Chronological status changes
- Each entry shows:
  - Status icon
  - Status name
  - Date/time
  - Changed by (admin name)

**5. Comments Section**
- List of admin comments
- Each comment shows:
  - Admin name
  - Comment text
  - Timestamp
- Add comment (admin only)

**6. Resolution Photos** (if resolved)
- Photos added by admin showing fix
- Displayed in separate section

**Key Functions:**
| Function | Description |
|----------|-------------|
| `_loadReport()` | Fetches report details |
| `_loadStatusHistory()` | Gets status change timeline |
| `_loadComments()` | Fetches admin comments |
| `_openPhotoGallery(int)` | Opens full-screen at index |
| `_openInMaps()` | Opens location in external maps app |
| `_shareReport()` | Shares report via system share |

**Admin-Only Features:**
- Update status dropdown
- Add comment button
- Add resolution photos
- Delete report option

---

### PhotoGalleryScreen (`photo_gallery_screen.dart`)

**Purpose:** Full-screen photo viewer with zoom and swipe.

**Features:**
- Swipeable photo carousel
- Pinch-to-zoom
- Double-tap to zoom
- Page indicator
- Close button
- Share button

**Key Functions:**
| Function | Description |
|----------|-------------|
| `_onPageChanged(int)` | Updates current index |
| `_sharePhoto()` | Shares current photo |
| `_downloadPhoto()` | Saves to device gallery |

---

## Admin Dashboard

### AdminDashboardScreen (`admin_dashboard_screen.dart`)

**Purpose:** Administrative panel for managing all reports.

**Tabs:**

**1. Overview Tab**
- Statistics cards:
  - Total reports
  - Pending (submitted)
  - In progress
  - Resolved
  - Resolution rate percentage
- Reports by category chart
- Recent activity list

**2. Reports Tab**
- Searchable list of all reports
- Advanced filters:
  - Status
  - Category
  - Date range
  - Search by title/description
- Bulk actions (select multiple)
- Sort options

**3. Analytics Tab**
- Reports over time chart
- Category distribution pie chart
- Average resolution time
- Hotspot areas map
- Export data button

**Key Functions:**
| Function | Description |
|----------|-------------|
| `_loadStatistics()` | Fetches dashboard stats |
| `_loadAllReports()` | Gets all reports (paginated) |
| `_updateReportStatus()` | Changes report status |
| `_addComment()` | Adds admin comment to report |
| `_addResolutionPhotos()` | Uploads fix photos |
| `_deleteReport()` | Removes report |
| `_exportReports()` | Generates CSV/PDF export |
| `_searchReports(String)` | Filters by search query |

**Report Management Actions:**
| Action | Description |
|--------|-------------|
| View | Opens report detail |
| Update Status | Dropdown to change status |
| Add Comment | Opens comment dialog |
| Add Resolution Photos | Upload photos of fix |
| Delete | Removes report (with confirmation) |

**Export Options:**
- CSV format (spreadsheet compatible)
- PDF format (printable report)
- Date range selection
- Category/status filters

---

## User Flows

### New User Registration Flow
```
App Launch → Onboarding → Register → Email Verification → Login → Home
```

### Returning User Flow
```
App Launch → Login → Home
```

### Report Submission Flow
```
Home → Create Tab → Category → Location → Description → Photos → Review → Submit → Detail View
```

### Report Tracking Flow
```
Home → My Reports → Select Report → View Status Timeline → View Comments
```

### Admin Report Management Flow
```
Home → Admin FAB → Dashboard → Select Report → Update Status/Add Comment → Save
```

### Password Reset Flow
```
Login → Forgot Password → Enter Email → Check Email → Click Link → Reset Password → Login
```

---

## State Management

### Services Architecture
The app uses a service-based architecture with singleton services:

| Service | Responsibility |
|---------|----------------|
| `AuthService` | Authentication, session management |
| `ReportService` | CRUD operations for reports |
| `LocationService` | GPS and geocoding |
| `NotificationService` | Push notifications |
| `ThemeService` | Theme preferences |
| `LocalizationService` | Language management |
| `CommentService` | Report comments |
| `ClusterService` | Hotspot clustering |
| `ExportService` | Data export |
| `ErrorService` | Error handling and logging |
| `UpdateService` | App version checking |

### Data Flow
```
UI Screen → Service Method → Supabase Client → Database
                ↓
         Local State Update
                ↓
            UI Rebuild
```

### Caching Strategy
- Reports cached locally for offline viewing
- Images cached via `cached_network_image`
- User profile cached in SharedPreferences
- Cache invalidated on pull-to-refresh

---

## Localization

### Supported Languages
- Romanian (ro) - Default
- English (en)

### Implementation
- `LocalizationService` manages current locale
- Translations stored in service as maps
- Language persisted to SharedPreferences
- Key: `app_language`

### Usage in Screens
```dart
final loc = LocalizationService();
Text(loc.translate('submit_report'))
```

### Translation Keys (Examples)
| Key | Romanian | English |
|-----|----------|---------|
| `login` | Autentificare | Login |
| `register` | Înregistrare | Register |
| `submit_report` | Trimite raport | Submit Report |
| `my_reports` | Rapoartele mele | My Reports |
| `status_submitted` | Trimis | Submitted |
| `status_in_progress` | În lucru | In Progress |
| `status_resolved` | Rezolvat | Resolved |

---

## Theme System

### Theme Modes
1. **Light Mode** - Default light colors
2. **Dark Mode** - Dark background, light text
3. **System Mode** - Follows device setting

### Color Scheme
| Element | Light | Dark |
|---------|-------|------|
| Primary | Blue (#2196F3) | Blue (#64B5F6) |
| Background | White | Dark Grey (#121212) |
| Surface | Light Grey | Dark Grey (#1E1E1E) |
| Error | Red | Light Red |
| Text | Black | White |

### Status Colors
| Status | Color |
|--------|-------|
| Submitted | Red (#F44336) |
| In Progress | Orange (#FF9800) |
| Resolved | Green (#4CAF50) |

### Category Colors
| Category | Color |
|----------|-------|
| Pothole | Brown (#795548) |
| Street Lighting | Yellow (#FFC107) |
| Illegal Waste | Green (#4CAF50) |
| Abandoned Vehicle | Blue Grey (#607D8B) |
| Other | Grey (#9E9E9E) |

### Theme Persistence
- Saved to SharedPreferences
- Key: `theme_mode`
- Values: `light`, `dark`, `system`
- Applied on app startup

---

## UI Components

### Common Widgets

**SkeletonLoader** (`skeleton_loader.dart`)
- Animated loading placeholder
- Used while data is fetching
- Shimmer effect animation

**Custom Buttons**
- Primary button (filled)
- Secondary button (outlined)
- Text button (no background)
- Icon button
- FAB (floating action button)

**Form Fields**
- Text input with validation
- Password input with visibility toggle
- Dropdown selector
- Date picker
- Category selector grid

**Cards**
- Report card
- Statistics card
- Comment card
- Status timeline card

**Dialogs**
- Confirmation dialog
- Success dialog
- Error dialog
- Loading dialog
- Input dialog

### Responsive Design
- Adapts to different screen sizes
- Safe area handling for notches
- Keyboard-aware scrolling
- Orientation support (portrait primary)

---

## Error Handling

### ErrorService
Centralized error handling with:
- Error logging
- User-friendly messages
- Retry mechanisms
- Offline detection

### Error Display
- SnackBar for minor errors
- Dialog for critical errors
- Inline validation messages
- Empty state illustrations

### Common Error Scenarios
| Scenario | Handling |
|----------|----------|
| Network offline | Show offline banner, use cached data |
| Auth expired | Redirect to login |
| Upload failed | Retry option, save draft locally |
| Invalid input | Inline validation message |
| Server error | Generic error dialog with retry |

---

## Performance Optimizations

### Image Handling
- Compressed before upload (max 1MB)
- Cached after download
- Lazy loading in lists
- Placeholder during load

### List Performance
- Pagination (20 items per page)
- Lazy loading on scroll
- Item recycling via ListView.builder
- Skeleton loaders during fetch

### Memory Management
- Dispose controllers properly
- Cancel subscriptions on unmount
- Clear image cache periodically
- Limit concurrent network requests

---

## Accessibility

### Features
- Semantic labels on all interactive elements
- Sufficient color contrast
- Touch targets minimum 48x48dp
- Screen reader support
- Scalable text sizes

### Testing
- TalkBack (Android) compatible
- VoiceOver (iOS) compatible
- Keyboard navigation support

---

## Deep Linking

### Supported Links
| Link | Action |
|------|--------|
| `urbanreporter://reset-password?token=xxx` | Opens password reset |
| `urbanreporter://report/[id]` | Opens specific report |

### Configuration
- Android: Intent filters in AndroidManifest.xml
- iOS: URL schemes in Info.plist
- Handled in main.dart on app startup

---

This documentation covers all frontend screens and functionality of the Urban Reporter application. For backend and database documentation, see `APP_TECHNICAL_DOCUMENTATION.md`. 