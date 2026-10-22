# 🔥 Firebase Setup - Final Steps

## ✅ What You've Already Done

✅ **Firebase Project Created** - Project ID: `nivio-*****`  
✅ **FlutterFire Configured** - `firebase_options.dart` generated  
✅ **Platforms Configured** - Android, Windows, Web  

---

## 🎯 What You Need To Do Now

### Step 1: Enable Authentication

1. Go to **Firebase Console**: https://console.firebase.google.com
2. Select your project **"nivio-f6110"**
3. Click **"Authentication"** in left sidebar
4. Click **"Get started"** button
5. Click **"Sign-in method"** tab
6. Find **"Anonymous"** in the list
7. Click on it → Toggle **"Enable"** → Click **"Save"**

✅ **Done!** Anonymous auth is now enabled.

---

### Step 2: Create Firestore Database

1. In Firebase Console, click **"Firestore Database"** in left sidebar
2. Click **"Create database"** button
3. **Start mode**: Select **"Production mode"** (we'll add rules next)
4. **Location**: Choose closest to you (e.g., `us-central1` or your region)
5. Click **"Enable"**

⏳ Wait 1-2 minutes for database to be created.

---

### Step 3: Set Firestore Security Rules

1. In **Firestore Database** → Click **"Rules"** tab
2. **DELETE** everything in the editor
3. **PASTE** this exact code:

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    // Allow users to read/write their own watch history
    match /users/{userId}/watchHistory/{historyId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Deny all other access
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

4. Click **"Publish"** button

✅ **Done!** Your database is now secure.

---

## 📖 Understanding the Rules

### What These Rules Do:

```javascript
// Rule 1: Watch History Access
match /users/{userId}/watchHistory/{historyId} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}
```

**Means:**
- ✅ Authenticated users CAN read/write their OWN watch history
- ❌ Users CANNOT read/write OTHER users' history
- ❌ Unauthenticated users CANNOT access anything

**Example:**
- User A (uid: `abc123`) can access: `/users/abc123/watchHistory/*`
- User A CANNOT access: `/users/xyz789/watchHistory/*` (User B's data)

```javascript
// Rule 2: Deny Everything Else
match /{document=**} {
  allow read, write: if false;
}
```

**Means:**
- ❌ All other database paths are completely locked
- No accidental data leaks

---

## 🧪 Test Your Setup

### 1. Run the App

```powershell
flutter run -d edge
```

### 2. Test Authentication

1. App opens → You see auth screen with "LOLFLIX" logo
2. Click **"GET STARTED"**
3. Should redirect to home screen

✅ **Auth works!**

### 3. Check Firebase Console

1. Go to **Authentication → Users**
2. You should see **1 anonymous user**
3. Copy the **User UID** (you'll use this to verify data)

### 4. Test Video Playback & Watch History

1. In the app, click **search icon** (top right)
2. Search for: **"Breaking Bad"**
3. Click on the result
4. Select **Season 1**
5. Click **play** on Episode 1
6. Wait for video to load (providers will try in order)
7. Let it play for ~10 seconds
8. Press **back** to exit player

### 5. Verify Watch History Saved

**Check Local (Hive):**
- Go back to home screen
- You should see **"Breaking Bad"** in "Continue Watching"
- Should show progress bar

**Check Cloud (Firestore):**
1. Firebase Console → **Firestore Database → Data**
2. Navigate to: `users → {your-uid} → watchHistory`
3. You should see a document with Breaking Bad data:
   ```
   tmdbId: 1396
   title: "Breaking Bad"
   currentSeason: 1
   currentEpisode: 1
   progressPercent: 0.05 (or similar)
   lastWatchedAt: (timestamp)
   ```

✅ **Watch history sync works!**

---

## 🔍 Firestore Data Structure

Your database will look like this:

```
nivio-***** (database)
└── users/
    ├── abc123-user-id-1/
    │   └── watchHistory/
    │       ├── 1396/  (Breaking Bad)
    │       │   ├── id: "abc123_1396"
    │       │   ├── tmdbId: 1396
    │       │   ├── title: "Breaking Bad"
    │       │   ├── currentSeason: 1
    │       │   ├── currentEpisode: 1
    │       │   ├── progressPercent: 0.15
    │       │   ├── lastPositionSeconds: 450
    │       │   └── ... (more fields)
    │       └── 2316/  (The Office)
    │           └── ... (similar structure)
    └── xyz789-user-id-2/
        └── watchHistory/
            └── ... (their shows)
```

---

## 📊 Firebase Quotas (Free Tier)

### Firestore
- **Storage**: 1 GB (you'll use <10 MB)
- **Reads**: 50,000/day (you'll use <100/day)
- **Writes**: 20,000/day (you'll use <500/day)
- **Deletes**: 20,000/day

### Authentication
- **Users**: Unlimited ✅
- **Sign-ins**: Unlimited ✅

**You're well within limits for 5 users!** 🎉

---

## 🐛 Troubleshooting

### "Failed to initialize Firebase"
**Fix:** Make sure you ran:
```powershell
flutter pub get
```

### "Permission denied" in Firestore
**Check:**
1. Are Firestore rules published?
2. Is user authenticated? (Check Firebase Console → Authentication)
3. Is userId matching in rules?

**Debug:**
```dart
// Add to your code temporarily to check user ID
print('User ID: ${FirebaseAuth.instance.currentUser?.uid}');
```

### Video plays but no watch history
**Check:**
1. Firebase initialized in main.dart? ✅ (we just did this)
2. Firestore rules set? (do step 3 above)
3. Check Flutter console for errors

### "Anonymous sign-in is disabled"
**Fix:** Follow Step 1 above to enable it

---

## ✅ Final Checklist

- [ ] **Firebase project created** (nivio-*****) ✅
- [ ] **Anonymous auth enabled** (Step 1)
- [ ] **Firestore database created** (Step 2)
- [ ] **Security rules set** (Step 3)
- [ ] **App tested** (search + play video)
- [ ] **Watch history verified** (check Firestore Console)

---

## 🎉 You're Done!

Once all checkboxes are ✅, your Firebase is **fully configured** and ready!

### Next Steps:
1. Complete Step 1, 2, 3 above
2. Run: `flutter run -d edge`
3. Test search, play video, check continue watching
4. Enjoy your Netflix clone! 🍿

---

## 💡 Pro Tips

### Clear Watch History
```dart
// In Firebase Console → Firestore → Delete documents manually
// Or add a "Clear History" button in your app
```

### Add More Users
- Just click "GET STARTED" on auth screen again
- Each device gets a unique anonymous user ID
- Each user has separate watch history

### Monitor Usage
- Firebase Console → Usage tab
- Check reads/writes/storage
- Set up budget alerts (optional)

---

**Need help?** Check the error messages in:
1. Flutter console (VS Code terminal)
2. Chrome DevTools console (F12)
3. Firebase Console → Firestore → Usage/Logs

Good luck! 🚀
