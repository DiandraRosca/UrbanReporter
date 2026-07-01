# Urban Reporter - App Improvements Checklist

## High Priority (UX/Functionality)

- [x] **1. Forgot Password** - Password reset functionality on login screen ✅ DONE
- [ ] **2. Offline Support** - App doesn't work without internet; could cache reports locally
- [x] **3. Image Compression Indicator** - No feedback when photos are being uploaded/compressed ✅ DONE
- [x] **4. Pull-to-Refresh on Map** - Map doesn't have refresh capability for new reports ✅ DONE

## Medium Priority (Polish)

- [x] **5. Profile Screen** - Users can't view/edit their profile (name, phone, email) ✅ DONE
- [x] **6. Report Editing** - Users can't edit their own reports after submission ✅ DONE
- [x] **7. Report Deletion** - Users can't delete their own reports ✅ DONE
- [x] **8. Sorting Options** - Reports list only shows newest first, no sorting options ✅ DONE
- [x] **9. Map Clustering** - When many reports are close together, markers overlap ✅ DONE
- [x] **10. Dark/Light Theme Toggle** - App is dark-only, some users prefer light mode ✅ DONE

## Nice to Have

- [x] **11. Report Comments** - Admin can't add notes/comments to reports ✅ DONE
- [x] **12. Photo Gallery** - Full-screen photo viewer with zoom ✅ DONE
- [x] **13. Share Report** - Share report link with others ✅ DONE
- [x] **14. Export Data** - Admin can't export reports to CSV/PDF ✅ DONE
- [x] **15. Onboarding** - First-time user tutorial ✅ DONE

## Technical Improvements

- [x] **16. Error Handling** - More user-friendly error messages ✅ DONE
- [x] **17. Loading Skeletons** - Replace spinners with skeleton loaders ✅ DONE
- [x] **18. Pagination** - Load reports in batches for better performance ✅ DONE

---

## Completed Features

### ✅ 1. Forgot Password (v1.0.4)
- Added "Ai uitat parola?" link on login screen
- Created `forgot_password_screen.dart` - email input form
- Created `reset_password_screen.dart` - new password form
- App detects `AuthChangeEvent.passwordRecovery` from Supabase
- Email template configured in Supabase using `{{ .ConfirmationURL }}`

**Files modified:**
- `lib/screens/auth/login_screen.dart`
- `lib/screens/auth/forgot_password_screen.dart` (new)
- `lib/screens/auth/reset_password_screen.dart` (new)
- `lib/main.dart` (auth listener for password recovery)

### ✅ 3. Image Upload Indicator (v1.0.5)
- Shows "Se încarcă fotografiile..." when uploading photos
- Shows "Se trimite raportul..." when submitting without photos
- Loading spinner with status text in submit button

**Files modified:**
- `lib/screens/report/create_report_screen.dart`

### ✅ 4. Pull-to-Refresh on Map (v1.0.5)
- Added refresh button above location button on map
- Shows loading spinner while refreshing
- Reloads all reports from server

**Files modified:**
- `lib/screens/map/map_screen.dart`


### ✅ 5. Profile Screen (v1.0.5)
- Profile icon in app bar navigates to profile screen
- Shows user avatar with initials, name, and admin badge if applicable
- Displays name (read-only), email (read-only), phone (editable)
- Inline phone editing with save/cancel buttons
- Change password dialog with validation
- Bilingual support (Romanian/English)

**Files modified:**
- `lib/screens/profile/profile_screen.dart` (new)
- `lib/screens/home/home_screen.dart` (added profile button)
- `lib/services/auth_service.dart` (added reloadProfile method)


### ✅ 6. Report Editing (v1.0.5)
- Users can edit the description of their own reports
- Edit button (pencil icon) appears next to "Description" label for report owner
- Opens dialog with text field pre-filled with current description
- Updates both local state and database

**Files modified:**
- `lib/screens/report/report_detail_screen.dart` (added edit button and dialog)
- `lib/services/report_service.dart` (added updateReportDescription method)


### ✅ 7. Report Deletion (v1.0.5)
- Users can delete their own reports ONLY when status is "Trimis" (submitted)
- Admins can delete ANY report regardless of status
- Delete button (trash icon) appears in app bar for owner+submitted OR admin
- Admin dashboard: "Șterge Raportul" button in expanded report card
- Once admin changes status to "În lucru" or "Rezolvat", regular users can't delete
- Confirmation dialog before deletion
- Also deletes associated photos from storage

**Files modified:**
- `lib/screens/report/report_detail_screen.dart` (added delete button and confirmation)
- `lib/screens/admin/admin_dashboard_screen.dart` (added delete button in report cards)
- `lib/services/report_service.dart` (added deleteReport method with isAdmin flag)


### ✅ 8. Sorting Options (v1.0.5)
- Added sorting row below category filters in "My Reports" screen
- Sort options: Newest, Oldest, By Status, By Category
- Visual chips show selected sort option
- Default is "Newest" (same as before)

**Files modified:**
- `lib/screens/report/my_reports_screen.dart` (added _sortBy state and _SortChip widget)


### ✅ 9. Map Clustering (v1.0.5)
- Added `flutter_map_marker_cluster` package
- Nearby markers automatically cluster into a single purple circle showing count
- Tap cluster to zoom in and see individual markers
- Cluster radius: 80 pixels
- Individual markers still show category icon and status color

**Files modified:**
- `pubspec.yaml` (added flutter_map_marker_cluster: ^1.3.6)
- `lib/screens/map/map_screen.dart` (replaced MarkerLayer with MarkerClusterLayerWidget)


### ✅ 10. Dark/Light Theme Toggle (v1.0.6)
- Created `ThemeService` (ChangeNotifier) to manage theme state
- Theme preference saved to `SharedPreferences` and persists across app restarts
- Added light theme to `app_theme.dart` with appropriate colors
- Theme toggle switch in profile screen below "Change Password" button
- Shows current mode (Mod întunecat / Mod luminos) with sun/moon icon
- App uses `themeMode` to switch between light and dark themes
- Updated ALL screens to use theme-aware colors for proper visibility in both modes

**Files modified:**
- `lib/services/theme_service.dart` (new)
- `lib/config/app_theme.dart` (added lightTheme and light theme colors)
- `lib/screens/profile/profile_screen.dart` (added theme toggle, theme-aware colors)
- `lib/main.dart` (added ThemeService provider and Consumer)
- `lib/screens/map/map_screen.dart` (theme-aware colors)
- `lib/screens/report/my_reports_screen.dart` (theme-aware colors)
- `lib/screens/report/report_detail_screen.dart` (theme-aware colors)
- `lib/screens/report/create_report_screen.dart` (theme-aware colors)
- `lib/screens/home/home_screen.dart` (theme-aware dialogs)
- `lib/screens/auth/login_screen.dart` (theme-aware colors)
- `lib/screens/auth/register_screen.dart` (theme-aware colors for back button, titles, success screen)
- `lib/screens/auth/forgot_password_screen.dart` (theme-aware colors for back button, titles, success screen)
- `lib/screens/auth/reset_password_screen.dart` (theme-aware colors for titles, success screen)
- `lib/screens/admin/admin_dashboard_screen.dart` (full theme support for statistics, reports list, hotspots, cards, dialogs)


### ✅ 11. Admin Comments/Notes (v1.0.7)
- Admins can add notes/comments to any report
- Comments support text and optional photos (from gallery or camera)
- Comments show admin name, timestamp, and attached photos
- Admins can delete their own comments
- Comments visible to all users viewing the report
- Photos stored in separate `admin-photos` storage bucket

**Database setup required:**
- Run `ADMIN_COMMENTS_SETUP.sql` in Supabase SQL Editor
- Create `admin-photos` storage bucket in Supabase Dashboard (public bucket)

**Files created:**
- `lib/models/report_comment.dart` (new model)
- `lib/services/comment_service.dart` (new service)
- `ADMIN_COMMENTS_SETUP.sql` (database migration)

**Files modified:**
- `lib/config/supabase_config.dart` (added adminPhotoBucket constant)
- `lib/main.dart` (added CommentService provider)
- `lib/screens/report/report_detail_screen.dart` (added comments section UI)


### ✅ 11.1 Resolution Photos (v1.0.7)
- When admin marks a report as "Resolved", a dialog appears to optionally add resolution photos
- Photos can be taken with camera or selected from gallery
- Resolution photos are displayed in the report detail screen with a green border
- Photos stored in `admin-photos` bucket under `resolution/` path
- Shows "Fotografii Rezolvare" / "Resolution Photos" section when photos exist

**Database setup required:**
- The `resolution_photo_urls` column is included in `ADMIN_COMMENTS_SETUP.sql`

**Files modified:**
- `lib/models/report.dart` (added resolutionPhotoUrls field)
- `lib/services/report_service.dart` (updateReportStatus accepts optional resolutionPhotos)
- `lib/screens/report/report_detail_screen.dart` (resolution photo dialog and display section)


### ✅ 12. Photo Gallery (v1.0.7)
- Full-screen photo viewer with swipe navigation between photos
- Double-tap to zoom in/out
- Pinch-to-zoom with InteractiveViewer (0.5x to 4x zoom)
- Photo counter indicator (e.g., "2 / 5")
- Page indicator dots at bottom
- Works for report photos, resolution photos, and admin comment photos
- "Double-tap to zoom" hint displayed

**Files created:**
- `lib/screens/report/photo_gallery_screen.dart` (new PhotoGalleryScreen widget)

**Files modified:**
- `lib/screens/report/report_detail_screen.dart` (updated to use PhotoGalleryScreen)


### ✅ 13. Share Report (v1.0.7)
- Share button in report detail app bar
- Shares formatted text with report details:
  - Category, location, status, date
  - Full description
  - OpenStreetMap link to exact location
- Uses native share sheet (works on Android, iOS, web)
- Bilingual support (Romanian/English)

**Dependencies added:**
- `share_plus: ^7.2.2`

**Files modified:**
- `pubspec.yaml` (added share_plus)
- `lib/screens/report/report_detail_screen.dart` (added share button and _shareReport method)


### ✅ 14. Export Data (v1.0.7)
- Export buttons in admin dashboard Statistics tab
- Two export options:
  - **Export CSV**: Full report data in CSV format (ID, category, status, description, address, coordinates, user info, dates)
  - **Summary**: Text summary of statistics (totals by status and category)
- On mobile: CSV is saved to temp file and shared via native share sheet
- On web: Data is copied to clipboard
- Bilingual support (Romanian/English headers and labels)

**Dependencies added:**
- `path_provider: ^2.1.2`

**Files created:**
- `lib/services/export_service.dart` (new ExportService with CSV generation)

**Files modified:**
- `pubspec.yaml` (added path_provider)
- `lib/screens/admin/admin_dashboard_screen.dart` (added export buttons and methods)


### ✅ 15. Onboarding (v1.0.7)
- Comprehensive first-time user tutorial shown before login screen
- 7 swipeable pages with detailed instructions:
  1. **Welcome** - Introduction to the app
  2. **How to create a report** - Step-by-step guide (tap +, select category, take photos, describe, submit)
  3. **Explore the map** - Map features, marker colors, location button, refresh
  4. **Your reports** - My Reports screen, filtering, sorting, editing, deleting
  5. **Notifications & status** - Status meanings (Submitted → In Progress → Resolved), resolution photos
  6. **Profile & settings** - Phone editing, password change, theme toggle, tutorial access
  7. **You're ready!** - Final encouragement
- Two page types: intro pages (centered icon + description) and steps pages (list of instructions)
- Skip button to bypass onboarding
- Back/Continue navigation buttons
- Page indicator dots
- Onboarding state saved to SharedPreferences
- Bilingual support (Romanian/English)
- Theme-aware (dark/light mode)
- "View Tutorial" button in profile screen to re-watch onboarding anytime

**Files created:**
- `lib/screens/onboarding/onboarding_screen.dart` (new OnboardingScreen widget with _StepsPage)

**Files modified:**
- `lib/main.dart` (added onboarding check in AuthWrapper)
- `lib/screens/profile/profile_screen.dart` (added tutorial button)


### ✅ 16. Error Handling (v1.0.8)
- Created centralized `ErrorService` for translating technical errors into user-friendly messages
- Handles multiple error categories:
  - **Network errors**: "Nu există conexiune la internet" / "No internet connection"
  - **Timeout errors**: "Serverul nu răspunde" / "Server not responding"
  - **Auth errors**: Invalid credentials, email not confirmed, user exists, password requirements, session expired, rate limiting
  - **Database errors**: Duplicates, not found, permission denied, foreign key constraints
  - **Storage errors**: File too large, not found, invalid format
  - **Location errors**: GPS disabled, permission denied, timeout
  - **Permission errors**: Generic permission denied message
- Bilingual support (Romanian/English) based on `isRomanian` parameter
- Applied to all services: AuthService, ReportService, CommentService
- Removed hardcoded error messages and old `_translateError` methods

**Files created:**
- `lib/services/error_service.dart` (new ErrorService with getFriendlyMessage method)

**Files modified:**
- `lib/services/auth_service.dart` (uses ErrorService, removed _translateError)
- `lib/services/report_service.dart` (uses ErrorService for all error returns)
- `lib/services/comment_service.dart` (uses ErrorService for all error returns)


### ✅ 17. Loading Skeletons (v1.0.8)
- Created reusable skeleton loader components with shimmer animation effect
- Components include:
  - `ShimmerEffect` - Animated gradient overlay for skeleton elements
  - `SkeletonBox` - Basic placeholder box with configurable size and border radius
  - `ReportCardSkeleton` - Skeleton for user report cards in My Reports
  - `AdminReportCardSkeleton` - Skeleton for admin dashboard report cards
  - `StatCardSkeleton` - Skeleton for statistics cards
  - `ReportListSkeleton` - Full list skeleton with multiple report cards
  - `ProfileCardSkeleton` - Skeleton for profile information cards
- All skeletons support dark/light theme
- Replaced `CircularProgressIndicator` spinners with skeleton loaders in:
  - My Reports screen (user's report list)
  - Admin Dashboard Statistics tab (total card + status cards)
  - Admin Dashboard All Reports tab (report list)

**Files created:**
- `lib/widgets/skeleton_loader.dart` (new skeleton components)

**Files modified:**
- `lib/screens/report/my_reports_screen.dart` (uses ReportListSkeleton)
- `lib/screens/admin/admin_dashboard_screen.dart` (uses StatCardSkeleton, AdminReportCardSkeleton)


### ✅ 18. Pagination (v1.0.8)
- Implemented infinite scroll pagination for reports lists
- Reports loaded in batches of 20 items at a time
- Automatic loading of more reports when scrolling near bottom (200px threshold)
- Pull-to-refresh resets pagination and reloads from beginning
- Loading indicator shown at bottom while fetching more reports
- Separate pagination state for:
  - All reports (admin dashboard)
  - User reports (my reports screen)
- Pagination state includes:
  - `isLoadingMore` - indicates if currently fetching more data
  - `hasMoreReports` / `hasMoreUserReports` - indicates if more data available
  - Page tracking for proper offset calculation

**Files modified:**
- `lib/services/report_service.dart` (added pagination logic, loadMoreReports, loadMoreUserReports)
- `lib/screens/report/my_reports_screen.dart` (added scroll controller, infinite scroll)
- `lib/screens/admin/admin_dashboard_screen.dart` (converted _AllReportsList to StatefulWidget, added infinite scroll)
