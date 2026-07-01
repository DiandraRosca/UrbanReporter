# Google Play Store Publishing Guide - Urban Reporter

This guide walks you through publishing your Flutter app to Google Play Store.

---

## Prerequisites

- [ ] Google Play Developer Account ($25 one-time fee)
- [ ] App icon (512x512 PNG)
- [ ] Feature graphic (1024x500 PNG)
- [ ] Screenshots (at least 2 phone screenshots)
- [ ] Privacy policy URL
- [ ] Java JDK installed (for keytool)

---

## Part 1: Create a Signing Keystore

The keystore is used to sign your app. **NEVER LOSE THIS FILE** - you won't be able to update your app without it.

### Step 1.1: Generate the Keystore

Open Command Prompt and run:

```cmd
keytool -genkey -v -keystore C:\Users\andre\urban-reporter-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias urban-reporter
```

You'll be prompted for:
1. **Keystore password** - Create a strong password (WRITE IT DOWN!)
2. **Your first and last name** - Your name or company name
3. **Organizational unit** - Can be anything (e.g., "Development")
4. **Organization** - Your company/organization name
5. **City/Locality** - Your city
6. **State/Province** - Your state/region
7. **Country code** - Two-letter code (e.g., "RO" for Romania)
8. **Key password** - Can be same as keystore password

### Step 1.2: Backup Your Keystore

**CRITICAL**: Copy your keystore to multiple safe locations:
- Cloud storage (Google Drive, Dropbox)
- USB drive
- Another computer

Save these details somewhere safe:
```
Keystore location: C:\Users\andre\urban-reporter-keystore.jks
Keystore password: [YOUR_PASSWORD]
Key alias: urban-reporter
Key password: [YOUR_KEY_PASSWORD]
```

---

## Part 2: Configure App Signing

### Step 2.1: Create key.properties File

Create a new file at `urban_reporter/android/key.properties`:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD_HERE
keyPassword=YOUR_KEY_PASSWORD_HERE
keyAlias=urban-reporter
storeFile=C:\\Users\\andre\\urban-reporter-keystore.jks
```

**Note**: Use double backslashes `\\` in the path on Windows.

### Step 2.2: Add key.properties to .gitignore

Add this line to `urban_reporter/.gitignore`:
```
android/key.properties
```

This prevents your passwords from being uploaded to Git.

### Step 2.3: Update build.gradle

Open `urban_reporter/android/app/build.gradle` and make these changes:

**Add this BEFORE the `android {` block:**

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
```

**Find the `buildTypes` section and REPLACE it with:**

```gradle
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}

buildTypes {
    release {
        signingConfig signingConfigs.release
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

---

## Part 3: Prepare App Metadata

### Step 3.1: Update App Version

In `urban_reporter/pubspec.yaml`, update the version:

```yaml
version: 1.0.0+1
```

Format: `major.minor.patch+buildNumber`
- Increment `buildNumber` for every upload to Play Store
- Example: 1.0.0+1, 1.0.0+2, 1.0.1+3, 1.1.0+4

### Step 3.2: Update App Name (if needed)

In `urban_reporter/android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:label="Urban Reporter"
    ...
```

### Step 3.3: Verify Package Name

Your package name is `com.urbanreporter.app` (defined in build.gradle).
This CANNOT be changed after publishing.

---

## Part 4: Build the Release App Bundle

### Step 4.1: Clean and Build

Open Command Prompt in the project folder and run:

```cmd
cd urban_reporter
flutter clean
flutter pub get
flutter build appbundle --release
```

### Step 4.2: Locate the AAB File

After successful build, find your app bundle at:
```
urban_reporter/build/app/outputs/bundle/release/app-release.aab
```

This is the file you'll upload to Google Play.

---

## Part 5: Create Google Play Developer Account

### Step 5.1: Register

1. Go to https://play.google.com/console
2. Sign in with your Google account
3. Pay the $25 registration fee
4. Complete the account details

### Step 5.2: Verify Identity (if required)

Google may require identity verification for new accounts:
- Government ID
- Payment method verification
- Address verification

This can take 1-3 days.

---

## Part 6: Create App in Play Console

### Step 6.1: Create New App

1. Click "Create app" in Play Console
2. Fill in:
   - **App name**: Urban Reporter
   - **Default language**: Romanian (or English)
   - **App or game**: App
   - **Free or paid**: Free
3. Accept the declarations
4. Click "Create app"

### Step 6.2: Complete Store Listing

Go to **Grow** → **Store presence** → **Main store listing**:

**App Details:**
- **App name**: Urban Reporter
- **Short description** (80 chars max):
  ```
  Raportează probleme urbane din orașul tău - gropi, iluminat, gunoi, vehicule abandonate.
  ```
- **Full description** (4000 chars max):
  ```
  Urban Reporter este aplicația care îți permite să raportezi problemele din orașul tău direct autorităților locale.

  🚨 FUNCȚIONALITĂȚI:
  • Raportează probleme: gropi în asfalt, iluminat defect, gunoi, vehicule abandonate
  • Adaugă fotografii pentru a documenta problema
  • Localizare GPS automată
  • Urmărește statusul rapoartelor tale
  • Primește notificări când problema este rezolvată
  • Vizualizează toate problemele pe hartă

  📍 CUM FUNCȚIONEAZĂ:
  1. Deschide aplicația și autentifică-te
  2. Apasă pe butonul + pentru a raporta o problemă
  3. Selectează categoria problemei
  4. Adaugă o descriere și fotografii
  5. Confirmă locația pe hartă
  6. Trimite raportul

  🔔 NOTIFICĂRI:
  Primești notificări în timp real când statusul raportului tău se schimbă.

  🗺️ HARTĂ INTERACTIVĂ:
  Vezi toate problemele raportate în zona ta pe o hartă interactivă.

  Împreună putem face orașul nostru mai bun!
  ```

**Graphics:**
- **App icon**: 512x512 PNG (your app icon)
- **Feature graphic**: 1024x500 PNG (promotional banner)
- **Screenshots**: 
  - Minimum 2 phone screenshots
  - Recommended: 4-8 screenshots
  - Size: 16:9 or 9:16 aspect ratio
  - Show main features: map, report creation, report list

### Step 6.3: Complete Content Rating

Go to **Policy** → **App content** → **Content rating**:

1. Start the questionnaire
2. Answer questions about your app content:
   - Violence: No
   - Sexual content: No
   - Language: No
   - Controlled substances: No
   - User-generated content: Yes (photos)
3. Submit for rating

### Step 6.4: Set Up Privacy Policy

Go to **Policy** → **App content** → **Privacy policy**:

You need a URL to a privacy policy page. Options:
1. Create a simple webpage on GitHub Pages
2. Use a free privacy policy generator
3. Host on your own website

Example privacy policy URL: `https://yourusername.github.io/urban-reporter-privacy`

### Step 6.5: Data Safety

Go to **Policy** → **App content** → **Data safety**:

Fill in what data your app collects:
- **Account info**: Email, name, phone (optional)
- **Location**: Precise location (for reports)
- **Photos**: User-uploaded photos
- **Device info**: For crash reporting

---

## Part 7: Upload and Release

### Step 7.1: Create a Release

1. Go to **Release** → **Production**
2. Click "Create new release"
3. Upload your `app-release.aab` file
4. Add release notes:
   ```
   Versiunea 1.0.0
   • Prima versiune a aplicației
   • Raportare probleme urbane
   • Hartă interactivă
   • Notificări push
   • Suport pentru română și engleză
   ```
5. Click "Save"

### Step 7.2: Review and Publish

1. Click "Review release"
2. Fix any errors or warnings
3. Click "Start rollout to Production"

### Step 7.3: Wait for Review

- First review: 1-7 days (can be longer for new accounts)
- Google will email you when approved or if changes needed

---

## Part 8: After Publishing

### Updating Your App

1. Increment version in `pubspec.yaml`:
   ```yaml
   version: 1.0.1+2
   ```
2. Build new AAB:
   ```cmd
   flutter build appbundle --release
   ```
3. Upload to Play Console → Create new release

### Monitoring

- Check **Statistics** for downloads and ratings
- Respond to **Reviews** from users
- Monitor **Crashes** in Android Vitals

---

## Checklist Summary

### Before Publishing:
- [ ] Keystore created and backed up
- [ ] key.properties configured
- [ ] build.gradle updated with signing config
- [ ] App version set in pubspec.yaml
- [ ] Release AAB built successfully

### Play Console Setup:
- [ ] Developer account created ($25)
- [ ] App created in console
- [ ] Store listing completed (name, descriptions)
- [ ] App icon uploaded (512x512)
- [ ] Feature graphic uploaded (1024x500)
- [ ] Screenshots uploaded (min 2)
- [ ] Content rating completed
- [ ] Privacy policy URL added
- [ ] Data safety form completed
- [ ] AAB uploaded
- [ ] Release submitted for review

---

## Troubleshooting

### "Keystore was tampered with, or password was incorrect"
- Double-check your password in key.properties
- Make sure path uses double backslashes on Windows

### "App not signed with upload key"
- Ensure key.properties is in android/ folder
- Verify build.gradle has signing config

### Build fails with ProGuard errors
- Add rules to `android/app/proguard-rules.pro`:
  ```
  -keep class io.flutter.** { *; }
  -keep class com.google.firebase.** { *; }
  ```

### App rejected by Google
- Read the rejection email carefully
- Common issues: missing privacy policy, inappropriate content, broken functionality
- Fix issues and resubmit

---

## Useful Links

- Google Play Console: https://play.google.com/console
- Flutter deployment docs: https://docs.flutter.dev/deployment/android
- App signing: https://developer.android.com/studio/publish/app-signing
- Store listing guidelines: https://support.google.com/googleplay/android-developer/answer/9859152

---

## Cost Summary

| Item | Cost |
|------|------|
| Google Play Developer Account | $25 (one-time) |
| App hosting (Supabase free tier) | $0 |
| **Total** | **$25** |

Good luck with your app launch! 🚀
