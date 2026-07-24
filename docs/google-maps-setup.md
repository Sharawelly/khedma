# Google Maps setup — owner checklist

This is the part of the integration that needs **your** Google account and billing details, so it is
not delegated. Work through it when Phases 0–6 have landed. At the end there is a short **"hand back
to Claude"** section — once you paste those values in, the in-app map work can be implemented.

Nothing in Phases 0–6 depends on this. The app captures real coordinates via device GPS
(`geolocator`) without any Google key; this setup adds the visual map, address search, and route
drawing on top.

---

## Step 0 — Decide the app identifier first

The Android Maps key is locked to your **package name + signing certificate**, so the identifier has
to be settled *before* you create the key. The app is still on the Flutter default
`com.example.khedma`, which cannot be published.

Pick one (reverse-domain, lowercase, no hyphens):
- `com.eraasoft.khedma` — company namespace, the usual convention
- `net.runasp.khdma` — matches the current backend host
- anything else you own

**Tell Claude the identifier.** It gets applied to `android/app/build.gradle.kts` (`namespace` and
`applicationId`) and to the iOS `PRODUCT_BUNDLE_IDENTIFIER` in all three build configurations. Do this
before creating the key, or you will have to edit the key restrictions afterwards.

---

## Step 1 — Create the Google Cloud project

1. Go to <https://console.cloud.google.com> and sign in.
2. Project dropdown (top bar) → **New Project**.
3. Name it e.g. `Khedma-Mobile` → **Create**. Make sure it is selected afterwards.

## Step 2 — Attach billing

Maps will not serve tiles without a billing account attached, even inside the free monthly credit.

1. **Billing** → **Link a billing account** → create one if you have none (needs a card).
2. Google provides a recurring free monthly Maps credit; typical development traffic stays inside it.
   Set a budget alert anyway: **Billing → Budgets & alerts → Create budget**, cap it low (e.g. $10)
   and alert at 50/90/100%. This is your safety net against a runaway loop or a leaked key.

## Step 3 — Enable the APIs

**APIs & Services → Library**, search each one, click **Enable**:

| API | Why it's needed |
|---|---|
| **Maps SDK for Android** | renders the map on Android |
| **Maps SDK for iOS** | renders the map on iOS |
| **Places API** | address search / autocomplete in the location picker |
| **Geocoding API** | turns a dropped pin into a readable address |
| **Directions API** | route line + road ETA on the live-tracking screen |

Optional: **Maps Static API** if you want lightweight map thumbnails on the booking-details card.

> Enable exactly these. Every enabled API is billable surface — don't enable extras "just in case."

## Step 4 — Create the API keys

Create **three** keys rather than one. If a mobile key leaks it is bound to your app signature and is
useless to anyone else; a single unrestricted key is a standing liability.

**APIs & Services → Credentials → Create credentials → API key** (three times, renaming each).

### Key A — "Khedma Android"
- **Application restrictions** → **Android apps** → **Add**
  - *Package name*: the identifier from Step 0
  - *SHA-1*: see the box below — add **both** debug and release
- **API restrictions** → *Restrict key* → select **Maps SDK for Android**

### Key B — "Khedma iOS"
- **Application restrictions** → **iOS apps** → add the same identifier as the **bundle ID**
- **API restrictions** → *Restrict key* → select **Maps SDK for iOS**

### Key C — "Khedma Web Services"
Places / Geocoding / Directions are plain HTTPS calls and are **not** covered by the Android/iOS app
restrictions, so they need their own key.
- **Application restrictions** → **None** (they cannot be restricted by app signature)
- **API restrictions** → *Restrict key* → select **Places API**, **Geocoding API**, **Directions API**
- ⚠️ Because this one cannot be app-restricted, treat it as the sensitive one: keep the budget alert
  from Step 2 on, and rotate it if it is ever committed to git.

### Getting your SHA-1 fingerprints

Run from the project root (`D:\Flutter\khedma`):

```bash
cd android && ./gradlew signingReport
```

Look for the `debug` variant's `SHA1:` line — that's the debug fingerprint, which is what lets Maps
work while developing. When you later create a release keystore, come back and add its SHA-1 too, or
maps will render as a blank grey grid in release builds.

---

## Step 5 — Give the server its own key (separate concern)

The backend's `GoogleMaps:ApiKey` in `appsettings.json` is currently **empty**, which is why
`GET /api/bookings/{id}/eta` returns a straight-line `Haversine` distance instead of a real road ETA.

Create a **fourth** key (or reuse Key C) restricted to **Directions API** + **Distance Matrix API**,
and give it to whoever manages the server config. Restrict it by **IP address** to the server's IP.
This is the backend team's change, not the app's.

---

## Step 6 — Hand back to Claude

Paste these four things back into the session and the Maps implementation can proceed:

```
App identifier : com.example.____            (from Step 0)
Android key    : AIza...                     (Key A)
iOS key        : AIza...                     (Key B)
Web services   : AIza...                     (Key C)
```

### How the keys get used (so you know what you're approving)

- The **web-services key** is passed at run time via
  `flutter run --dart-define=GOOGLE_MAPS_API_KEY=...`, so it is not baked into a committed file.
- The **Android key** goes into `android/app/src/main/AndroidManifest.xml` as
  `<meta-data android:name="com.google.android.geo.API_KEY" .../>`.
- The **iOS key** goes into `ios/Runner/AppDelegate.swift` as `GMSServices.provideAPIKey(...)`.

Those last two must physically ship inside the app binary — that is how the Maps SDKs work, and it is
why the app-signature restrictions from Step 4 are what actually protects them, not secrecy.

> **Before you paste keys into chat:** they will be stored in the conversation. Given the restrictions
> above the mobile keys are low-risk, but if you would rather not, say so — the code can be written
> against placeholders and you can fill the real values in locally.

### What gets built once the keys land

| Screen | Becomes |
|---|---|
| `confirm_location_screen` | draggable map + pin, "use my location", address autocomplete |
| `track_live_screen` | live provider marker + route line + road ETA |
| `provider_track_live_screen` | provider-side route, "open in Google Maps" handoff |
| `provider_profile_working_area_section` | service-area picker with a radius circle |
| `booking_details_screen` | mini-map of the job address |
