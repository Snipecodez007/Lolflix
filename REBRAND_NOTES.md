# LOLFLIX rebrand notes

Fully renamed from Nivio to **LOLFLIX** (app name, Dart package, folders, Android/Windows/Linux ids, assets, landing page, docs).

## Fill these placeholders with your own values
| Placeholder | Where |
|---|---|
| `YOUR_GITHUB_USERNAME` | `lib` + `packages/lolflix_core/lib/services/github_release_update_service.dart` (in-app update checker), `landing/`, `README.md`, `.github/FUNDING.yml` |
| `YOUR_DOMAIN` | `landing/api/redirect.js` (share-link preview image) and `SHARE_REDIRECT_URL` in `.env` |

## Backend/service IDs kept on purpose (they belong to external accounts, changing them breaks login/sync)
- Firebase project in `firebase_options.dart` / `firebase.json` -> run `flutterfire configure` with your own project, and register package `com.lolflix.app` + your SHA-1 for Google Sign-In.
- `shorebird.yaml` `app_id` -> run `shorebird init` for your own app.
- Discord / AniList / MAL / Simkl: new redirect schemes are `lolflix://auth/...` and `lolflixdiscord://oauth2/callback`. Register these in your own developer apps and put the client IDs in `.env`.
- `assets/images/upi.jpeg` and sponsor links still point to the original author. Replace or remove them.
- Screenshots in `assets/images` and `landing/` are old captures; retake them from the LOLFLIX app.

## Names you will see after building
- Android: `com.lolflix.app`, label `LOLFLIX`, release files `lolflix-<version>.apk`
- Windows: `LOLFLIX.exe`, installer `LOLFLIX-Setup-<version>.exe`
- Linux: `lolflix`, `LOLFLIX-*.AppImage`
- Deep links: `lolflix://open/...`

## GitHub: push = all APKs build
Workflow: `.github/workflows/build-android.yml` (runs on push to `main`/`master`, on tags `v*`, or manually from the Actions tab).

It builds the Rust torrent engine for all ABIs, then produces and uploads:
`lolflix-<ver>.apk` (arm64-v8a, recommended), `lolflix-<ver>-armeabi-v7a.apk`, `lolflix-<ver>-x86_64.apk`, `lolflix-<ver>-universal.apk`, `SHA256SUMS.txt`.
Find them in the run page under **Artifacts**. Push a tag (`git tag v2.2.4 && git push origin v2.2.4`) to also publish a GitHub Release (this is what the in-app updater reads).

### Optional repo secrets (Settings > Secrets and variables > Actions)
Build works without any of them (with warnings), but features/updates need them:
| Secret | What |
|---|---|
| `KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD` | Your release signing key. Without it every build gets a random debug key and cannot update over the previous APK. |
| `GOOGLE_SERVICES_JSON_BASE64` | `base64 -w0 google-services.json` from your Firebase project (package `com.lolflix.app`). Needed for Google Sign-In. |
| `ENV_FILE` | Full content of your `.env` (Supabase, Simkl, etc.). |

Create the signing key once (keep the file safe, never commit it):
```
keytool -genkeypair -v -keystore release.keystore -alias lolflix -keyalg RSA -keysize 2048 -validity 10000
base64 -w0 release.keystore
```

### First push
```
git init && git add . && git commit -m "LOLFLIX"
git branch -M main
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/LOLFLIX.git
git push -u origin main
```
`.gitignore` was fixed so `android/` folders (they used to be ignored) are pushed. `google-services.json`, `.env` and keystores stay ignored.
