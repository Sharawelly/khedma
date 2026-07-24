# Plan: Connect the Khedma Flutter App to the KHDMA .NET Backend (+ Google Maps)

> **Revision 2** — updated after the backend team delivered the requested endpoints and contract
> changes. Resolved gaps removed, new contracts folded in, skill paths corrected, and the Google Maps
> work moved to the **final phase**.
>
> **✅ Verified against backend source on 2026-07-24** at branch `final_part` @ **`36cf206`**
> ("Merge branch 'master' into final_part"). `dotnet build` → **0 errors** (6 harmless NuGet
> version-resolution warnings). Every endpoint, DTO shape, and contract change below was read from
> the actual `.cs` files, not from a summary. Corrections found during verification are marked **[V]**.

## Context

The Flutter app (`D:\Flutter\khedma`) has a **finished UI** but only the `auth` feature was ever
wired to a backend — and it was wired to a **different template backend** (`api.world-apm.com`,
phone-based login, `country_id`/`governorate_id` register fields). Every customer (`client`) and
provider (`provider`) screen currently renders **mock/hardcoded data** with no data/domain layer.

The real backend is **KHDMA** (`D:\Eraa Soft Back-end\GP\Service-Center-Eraa-GP-`, .NET 9, Clean
Architecture, JWT + Identity), running locally at `http://localhost:5283`
(Swagger: `http://localhost:5283/swagger/index.html`).

**Goal:** replace all mock data with live KHDMA data for the **Customer** and **Provider** roles
(plus the **Common** endpoints they share). **Do NOT implement any Admin endpoints** — the mobile
app has no admin role. Add **real-time (SignalR)** for job dispatch / live tracking / chat, and
finally add **full in-app Google Maps**.

This document is written to be executed by a delegate (Sonnet 5 / Codex). Follow the app's existing
conventions exactly — the reference is the `auth` vertical slice and the project skills.

### Decisions already made (by the product owner)
- **Real-time:** include **SignalR** (package `signalr_netcore`) — Phase 5.
- **Google Maps:** **full in-app maps**, but scheduled **last** (Phase 7). Phases 3–4 use
  device GPS only (no Maps SDK, no API key) so booking works before the map work starts.
- **Payments:** **defer/stub** — treat payment as pending/cash; leave a clean seam.

### ⚠️ Deployment status — read before testing
The backend changes are on branch **`final_part` @ `36cf206`** and are **NOT deployed**.
`http://khdma.runasp.net` still serves the **old build**. All development and testing must run
against a **local backend** until a teammate redeploys (and preserves the server's `appsettings.json`).

**[V]** The handoff brief referenced `762d2e4`; two commits landed after it (`1b69126`, then the
`36cf206` merge). Build from `36cf206`.

---

## Project skills & review gates

`.cursor/skills/` is gone. Skills now live in **two mirrored locations**:
- **`.agents/skills/`** — for Codex and other agents
- **`.claude/skills/`** — for Claude Code

Both contain the same four Flutter scaffolding skills. Use them for every new slice:

| Skill | Use for |
|---|---|
| `flutter-new-feature` | A brand-new feature (model → entity → datasource → repo → usecase → cubit → UI → DI) |
| `flutter-add-endpoint` | One new API action on an **existing** feature |
| `flutter-generate-model` | Model + entity from a JSON payload |
| `flutter-implement-ui-from-mcp` | Building UI from a design source (mostly N/A — UI is done) |

> ⚠️ **`.claude/commands/add-endpoint.md` is a BACKEND (.NET) skill** for the KHDMA API — it is *not*
> the Flutter one. Never apply it to this repo. For Flutter, always use `flutter-add-endpoint`.

**Review gates** (also in both skill dirs) — run these before presenting/committing each phase:
- **`clean-code-guard`** — review the production Dart written in the phase.
- **`test-guard`** — if any tests were written.
- **`docs-guard`** — if docs/READMEs were touched.

> ⚠️ The Flutter skill docs still reference **stale paths**: `domain/repository/`, `data/repository/`,
> `presentation/pages/`, endpoints in `lib/core/utils/constants.dart`, and list parsing via
> `json["data"]["items"]`. Follow the **real** layout instead: `domain/repositories/`,
> `data/repositories/`, `presentation/screen(s)/`, endpoint constants in `ApiConstants` inside
> `lib/core/api/dio_consumer.dart`, and KHDMA's paged shape (array directly in `data`).

---

## Architecture & conventions (MUST follow)

**Clean architecture, feature-first**, with **flutter_bloc (Cubit) + get_it + Dio + go_router**.
Copy the pattern of `lib/features/auth/{data,domain,presentation}`. Per-feature layering:

```
features/<feature>/
  data/{models, datasources, repositories}
  domain/{entities, repositories, usecases (+ usecases/params)}
  presentation/{cubit, screen(s), widgets}
  <feature>_injection.dart      # setup<Feature>Injection() → registered in lib/injection_container.dart
```

- **Model extends Entity**; hand-written `fromJson`/`toJson` (no build_runner/freezed in this project).
- **Datasource** returns typed models (never `dynamic`), uses an endpoint constant, throws `ServerException` on `success==false`.
- **Repository impl** converts model→entity, catches exceptions → `Left(Failure)` (`dartz` `Either<Failure,T>`).
- **UseCase** = one `call(params)`; **Cubit** = one public method, states initial/loading/success/failure; **no mapping in cubit**.
- **DI** via `ServiceLocator` (get_it): repo/usecase = `registerLazySingleton`, cubit = `registerFactory`.
- **UI**: `BlocBuilder`; loading→shimmer (`lib/core/widgets/shimmer/`); error→red `SelectableText.rich`; reuse `lib/core/widgets/`.
- **Localization**: Arabic (default) + English via JSON keys in `lang/ar.json` / `lang/en.json` (`.tr`). Never hardcode strings.
- **Colors/text**: global `colors.*` (`lib/core/utils/values/app_colors.dart`) and `TextStyles.*` — not `Theme.of(context)`.

### Reuse — do NOT reinvent
- HTTP client **`DioConsumer` / `DioConsumerImpl`** (`lib/core/api/dio_consumer.dart`) — already injects the Bearer token, sets `accept-language`/`lang`, supports multipart `FormData`, maps errors to typed exceptions.
- **`AppInterceptors`** (`lib/core/api/app_interceptors.dart`) — already emits an unauthorized event on 401 via `AuthEventBus`. Keep; extend for token refresh (Phase 1).
- Storage: `secureStorage` (`app_secure_storage.dart`) and `sharedPreferences` (`app_shared_preferences.dart`).
- Envelope bases: `BaseOneResponse`, `BaseListResponse`, `PaginationModel` (`lib/core/base_classes/`) — **adapt to KHDMA's shape** (Phase 0).
- Global getters `dioConsumer`, `secureStorage`, `sharedPreferences`, `colors` from `lib/injection_container.dart`.

---

## KHDMA response contract

**1) Auth endpoints** (`/api/auth/*`) use a **non-standard** shape (deliberately left unstandardized
so the existing `AuthRespModel` keeps working):
```jsonc
{ "isSuccess": true, "errorMessage": null,
  "token": { "accessToken":"<JWT>", "refreshToken":"<b64>", "expiresAt":"...Z",
             "role":"Customer" /* or "Provider" */, "userName":"Sara Ahmed",
             "userId":"<id>" } }
```
✅ **`userId` is now returned — do NOT decode the JWT.**
Failure: HTTP 400 (register) / 401 (login) with `{ isSuccess:false, errorMessage:"...", token:null }`.

**2) Everything else** uses the standard envelope:
```jsonc
{ "success": true, "message": "...", "statusCode": 200, "data": <T> }
```
Paged endpoints add top-level `page, pageSize, totalCount, totalPages, hasNextPage, hasPreviousPage`
and put the array directly in `data` (**not** nested `data.items`).

**Cross-cutting gotchas:**
- ✅ **Image URLs are now ABSOLUTE.** Do **not** prepend a base host — you would get doubled URLs.
  **[V]** Served by `ImageUrlResolver`, which reads `App:PublicBaseUrl` from config and **falls back to
  the incoming request's host** when that key is absent. `App:PublicBaseUrl` is currently **not set** in
  either `appsettings.json` or `appsettings.Development.json`, so locally the URLs come back on whatever
  host you called — e.g. an Android emulator calling `10.0.2.2:5283` gets
  `http://10.0.2.2:5283/uploads/...`, which loads correctly. **This works by accident, not by design:**
  once the API sits behind a proxy/CDN the backend team must set `App:PublicBaseUrl` or images will
  point at an internal host. Flag it before deployment. (The resolver is idempotent — it leaves
  already-absolute URLs alone — so a stray prepend on our side is the only real risk.)
- **Enums serialize as integers** — **[V]** confirmed: `Program.cs` registers no `JsonStringEnumConverter`
  and no `AddJsonOptions`. One exception: `PendingJobDto.BookingType` is declared as a **`string`** in
  C# (defaulting to `nameof(BookingType.Immediate)`), while `BookingDetailDto.BookingType` is the real
  **integer enum**. The inconsistency is real — parse defensively.
- `401`/`403` now return a JSON body matching the standard envelope (no longer empty).
- Two intentional non-envelope responses: the admin bookings export (a real csv/xlsx file) and the
  auth endpoints (`AuthResponseDto`).

### Swagger (regenerated at `762d2e4`)
138 operations · **26 role-ordered sections** (`01 ADMIN…` → `26 PUBLIC…`) · 151 schemas ·
132 documented response bodies. Four independent auth boxes let you hold multiple role tokens at once:

| Box | Sections | Get the token from |
|---|---|---|
| `AdminBearer` | 01–11 | `POST /api/auth/login/admin` (**ignore — not for mobile**) |
| `CustomerBearer` | 12–15 | `POST /api/auth/login` |
| `ProviderBearer` | 16–19 | `POST /api/auth/login` |
| `CommonBearer` | 20–25 | any of the three |

Response schemas are now documented, so `swagger.json` is a reliable contract reference (and could
seed a generator) — but **hand-write the models** to match this project's conventions.

**[V]** The handoff brief warned that "the new endpoints have no `[ProducesResponseType]`, so trust the
source over Swagger." **That is now out of date** — every new endpoint carries full
`[ProducesResponseType]` attributes (verified in `ProviderController.cs`, `BookingController.cs`,
`PublicCatalogController.cs`). Swagger and the source agree; use either.

**[V]** Two distinct `BookingDetailDto` classes exist — `KHDMA.Application.DTOs.Booking.BookingDetailDto`
(**ours**, returned by `GET /api/Booking/{id:guid}`) and `KHDMA.Application.DTOs.Admin.BookingDetailDto`
(admin-only, richer). They are different shapes. When reading `swagger.json`, take the **Booking** one.

---

## PHASE 0 — Foundation, config, envelopes, app identity

1. **Base URL + environment config.** Replace the `api.world-apm.com` constants in `ApiConstants`
   (`lib/core/api/dio_consumer.dart`) with a `--dart-define`-driven base URL. Add
   `lib/core/config/app_config.dart` reading `String.fromEnvironment('API_BASE_URL', ...)`
   (and later `GOOGLE_MAPS_API_KEY` in Phase 7).
   - Android emulator → `http://10.0.2.2:5283/api`
   - iOS simulator / desktop → `http://localhost:5283/api`
   - Physical device → `http://<your-LAN-IP>:5283/api`
   - Production → `http://khdma.runasp.net/api` (**only after redeploy**)
   ✅ HTTPS redirect is now **disabled in Development**, so plain-HTTP emulator calls no longer 307.

2. **Purge template endpoint leftovers** from `ApiConstants` (`getArticles`, `getBreedTypes`,
   `blocksDashboard`, `getCategoryFilters`, `messagesUnreadCount`, `changeLanguage`, …) and add KHDMA
   endpoint constants grouped by area (auth, profile, catalog, booking, provider, chat, notifications,
   reviews, favorites, location).

3. **Envelope base classes.** Update `BaseListResponse` + `PaginationModel` to KHDMA's paged shape
   (array in `data`, pagination at top level). Keep `BaseOneResponse` for single objects. Parse `statusCode`.

4. **Do NOT build an image-URL prepend helper.** URLs are absolute now. If any prepending logic exists,
   remove it. (See the `App:PublicBaseUrl` caveat above — it affects deployment, not our client code.)

5. **App identity — DEFERRED to Phase 7.** The owner will choose the final identifier during the Google
   Maps setup (it must match the Maps key's package-name + SHA-1 restriction, so the two are done
   together). `com.example.khedma` stays in place through Phases 0–6; nothing in those phases depends
   on it.

6. **Secure storage.** Extend `app_secure_storage.dart` with `refreshToken` (+ optionally
   `tokenExpiresAt`, `userRole`) keys and accessors.

**Deliverable check:** app compiles, points at KHDMA, no template endpoints remain, `flutter analyze` clean.

---

## PHASE 1 — Auth rework (Customer + Provider), token lifecycle, role routing

The existing `auth` datasource/params/models target the wrong backend and **must be rewritten**. Keep
the auth **UI screens** (login, create-account, otp, role-selection, language); re-map fields and navigation.

1. **Params & models** → KHDMA contract:
   - **Login** `POST /api/auth/login` JSON `{ email, password }` → parse `{ isSuccess, errorMessage, token{...} }`.
   - **Register customer** `POST /api/auth/register/customer` **multipart**: `fullName, email, password, phoneNumber, dateOfBirth?`, file `profilePicture?`.
   - **Register provider** `POST /api/auth/register/provider` **multipart**: customer fields **plus** `hourlyRate?, serviceArea?, jobTitle?, experienceYears?, description?, availabilityStatus?, currentLatitude?, currentLongitude?`, files `certificateImages[]?`, `portfolioImages[]?`.
   - **Refresh** `POST /api/auth/refresh-token` `{ refreshToken }`; **Logout** `POST /api/auth/logout` `{ refreshToken }`.
   Model the token as `AuthTokenModel { accessToken, refreshToken, expiresAt, role, userName, userId }`.
   Persist accessToken + refreshToken in secure storage; **take `userId` straight from the response**.

   > ✅ **RESOLVED 2026-07-24 — register field set confirmed by the product owner:**
   > - **Customer form:** `fullName`, `email`, `password`, **`phoneNumber`**. (Phone is required so the
   >   provider's `AcceptResultDto.customerPhone` is populated and they can actually call the customer.)
   >   `dateOfBirth` and `profilePicture` are **skipped** at signup.
   > - **Provider form: two-step signup.** Step 1 = the same account fields as customer. Step 2 =
   >   professional details: `jobTitle`, `hourlyRate`, `serviceArea`, `experienceYears`, `description`.
   >   `certificateImages` / `portfolioImages` are **deferred to profile editing** (Phase 2), not signup.
   > - **OTP is skipped.** The backend has no OTP/phone-verification endpoint (only email confirmation,
   >   whose token prints to the server console with no mail sender wired). Route **past**
   >   `otp_screen.dart`; leave the file in place but unused rather than deleting it.
   >
   > **[V]** `BaseRegisterDto` declares no `[Required]` attributes and `AuthService` does not validate
   > `PhoneNumber`, so an empty phone would be silently accepted server-side — another reason to collect
   > it on the client.

2. **Datasource / repo / usecases / cubits.** Rewrite `auth_remote_datasource.dart`, `auth_repo_impl.dart`,
   and the login/register/auto-login cubits. Keep the DI structure (`auth_injection.dart`). Remove
   `getAllCountries` and all `country_id`/`governorate_id`/`activity_type_id` machinery.

3. **Token refresh interceptor.** In `AppInterceptors`, on 401 attempt **one** silent refresh via
   `/api/auth/refresh-token`; on success retry the original request, on failure emit the unauthorized
   event (bounce to login). Guard against refresh loops.

4. **Role-based routing.** `role_selection_screen.dart` currently routes on the UI tap. Branch instead on
   the **server role** from the token (`Customer` → `Routes.appShellRoute`, `Provider` →
   `Routes.providerAppShellRoute`). Role selection may still pick which *register* form to show.

5. **Profile bootstrap.** After login call `GET /api/profile` and cache the profile.

**Deliverable check:** register + login work against seeded accounts; token persists; correct shell is
routed to by server role; 401 triggers refresh-then-logout.

---

## PHASE 2 — Common features (Profile, Addresses, Certificates/Portfolio, Notifications, Chat REST)

1. **Profile:** `GET /api/profile` (branch on role) → `profile_screen.dart` / `provider_profile_screen.dart`;
   `PUT /api/profile` multipart (+ avatar); `PUT /api/profile/change-password`.
2. **Addresses (customer):** `GET/POST/DELETE /api/profile/addresses[/{id}]` —
   `{ label, addresssLine (note the DTO's triple-s typo), latitude, longitude }`.
3. **Provider certificates & portfolio:** `GET/POST/DELETE /api/profile/certificates[/{imageId}]` and
   `.../portfolio[/{imageId}]` (multipart `List<IFormFile> images`).
   ⚠️ Certificate `name`/`issuer` were **removed** (no DB columns) — don't render them.
4. **Notifications:** `GET /api/Notifications?type=&isRead=&page=` (paged), `PUT /{id}/read`,
   `PUT /read-all`, `DELETE /{id}`. Replace `notifications_screen.dart` mock.
5. **Chat — REST layer only** (real-time in Phase 5): `GET /api/chat/threads`,
   `GET /api/chat/{bookingId}/history?page=`, `POST /api/chat/{bookingId}/messages`,
   `POST /api/chat/{bookingId}/attachments` (multipart → url), `POST /api/chat/{bookingId}/read`.
   Chat is scoped to a booking.

**Deliverable check:** profile loads/edits, addresses CRUD, notifications list/read, chat history loads
and messages send.

---

## PHASE 3 — Customer catalog + booking lifecycle

> **Location strategy for this phase (no Google Maps yet):** use `geolocator` for the device's current
> position and `geocoding` for reverse-geocoding to an address string. Both use the **native platform
> geocoder — no Google Maps SDK and no API key required.** Keep `confirm_location_screen.dart` as a
> "use my current location / pick a saved address" screen; Phase 7 swaps in the real map picker.

1. **Public catalog (no token):** `GET /api/categories/public`,
   `GET /api/services/public?categoryId=&search=&page=`, `GET /api/services/public/{id}`,
   `GET /api/providers/{id}/public`, `GET /api/Reviews/provider/{providerId}?page=`.
   Replace mocks in `home_screen.dart`, `category_services_screen.dart`, `service_details_screen.dart`,
   `provider_profile_screen.dart`.
   ⚠️ `PublicServiceDetailDto.whatsIncluded` was **removed** — drop any UI for it.

2. **✅ NEW — Provider browse / nearby:** `GET /api/providers/public` (anonymous, paged)
   `?category={Guid}&search=&lat=&lng=&radiusKm=&page=&pageSize=`
   → item `{ id, name, photo?, jobTitle?, rating, reviewCount, hourlyRate?, distanceKm? }`
   **[V]** `id` here is a **`string`** (Identity user id), *not* a `Guid` — unlike `serviceId`/
   `categoryId`, which are GUIDs. Type the Dart field as `String`.
   - **With `lat`+`lng`** → *nearby mode*: **Online providers only**, `radiusKm` (default 25),
     sorted by distance, `distanceKm` populated.
   - **Without** → *catalogue browse*: all Active providers **including offline**, sorted by rating,
     `distanceKm` null.
   Powers a provider list/browse screen and (in Phase 7) a map of nearby providers.

3. **Create booking (dispatch):** `POST /api/Booking` `CreateBookingDto`
   `{ serviceId, bookingType(Immediate|Scheduled), scheduledTime?, address?, latitude?, longitude?, addressId?, notes?, attachmentUrl? }`
   → `CreateBookingResultDto { bookingId, status, priceBreakdown{...}, providersNotified, dispatchStarted }`.
   Funnel: `confirm_location_screen` → `choose_date_time_screen` → `almost_done_screen` → create →
   `provider_tracking_screen` → `provider_found_screen` → `track_live_screen`.
   **No price is sent** — the server snapshots `Service.FixedPrice`. **Payment step: stubbed.**

4. **Direct booking:** `POST /api/Booking/direct` (`CreateDirectBookingDto` = create + `providerId`).

5. **Cancel:** `DELETE /api/Booking/{id}` (reason as a raw JSON string body).

6. **✅ NEW — Booking detail:** `GET /api/Booking/{id:guid}` — auth: the customer **or the assigned
   provider** (403 otherwise, 404 if absent). **[V]** The route carries a `:guid` constraint, so a
   non-GUID id misses routing entirely (404, not a validation error). Returns:
   `id, customerId, customerName, providerId?, providerName?, providerPhone?, providerRating?,
   providerPhoto?, serviceId, serviceName, bookingType, scheduledTime?, address?, latitude?,
   longitude?, status, statusLabelEn, statusLabelAr, totalPrice, notes?, cancelReason?, createAt,
   acceptedAt?, enRouteAt?, arrivedAt?, startedAt?, completedAt?, cancelledAt?`
   - ⚠️ **All `provider*` fields are null until a provider accepts** — the UI must handle that.
   - ✅ `statusLabelEn`/`statusLabelAr` are **ready to render** — do **not** write client-side status
     label mapping; pick by current locale.
   - The timestamps drive the status timeline on the tracking/detail screens.
   This backs `booking_details_screen.dart` and the tracking screens.

7. **History:** `GET /api/Booking/history?status=&from=&to=&page=` (paged) → `bookings_screen.dart`.

8. **ETA:** `GET /api/bookings/{id}/eta` → `EtaDto { etaMinutes, distanceKm, source, calculatedAt }`.
   ⚠️ **Check `source`** — until a Google key is configured server-side it returns `"Haversine"`
   (straight-line), so don't present it as a precise road ETA.

9. **Favorites & reviews:** `POST /api/Favorites/{providerId}` (toggle), `GET /api/Favorites`;
   `POST /api/Reviews` (`CreateReviewDto`), `PUT /api/Reviews/{id}`.

**Payments seam (stub):** define an abstract `PaymentGateway` with a `NoOpPaymentGateway` returning
"pending/cash". Route the booking flow through it so a real gateway drops in later.
⚠️ **Stripe is retired.** `POST /api/payments/intent/{bookingId}` and `/confirm/{paymentIntentId}`
are **deleted**. Paymob is the only gateway; surviving routes are `POST /api/payments/initiate`,
`/webhook`, `/{id}/refund`, and `POST /api/Booking/{id}/retry-payment` now returns a **Paymob payment
key + iframe URL** (not a Stripe client secret). Keep all of this behind the stub for now.

**Deliverable check:** browse categories/services/providers, create a dispatch booking, open its detail,
see it in history, cancel it, favorite a provider, leave a review.

---

## PHASE 4 — Provider features (Jobs, Pending offers, Availability, Earnings, Location)

1. **✅ NEW — Recover pending offers:** `GET /api/provider/pending-jobs` (auth: Provider) — recovers
   dispatch offers after reconnect or a cold start. Returns:
   `bookingId, serviceNameEn, serviceNameAr, categoryNameEn, categoryNameAr, customerFirstName,
   customerAvatarUrl?, distanceKm, providerEarning, currency, estimatedDurationMin?,
   estimatedDurationMax?, bookingType, scheduledTime?, expiresAt, secondsRemaining`
   - ⚠️ **No address by design** (SRS 7.1) — only distance + customer first name. The address is
     revealed on accept.
   - ⚠️ `providerEarning` is **net of commission**, not the booking total. Label it accordingly.
   - Use `secondsRemaining` to drive the offer countdown.
   - ⚠️ `bookingType` here is a **string** (`"Immediate"`), unlike integer enums elsewhere.
   - Returns **200 + empty list** (not an error) when the provider has no stored coordinates.
   Call this on app start and on SignalR reconnect (Phase 5).

2. **Job lifecycle:** `POST /api/Booking/{id}/accept` → `AcceptResultDto` (reveals address/phone/
   customer/earning), `.../reject`, `.../complete`, `.../mark-en-route?eta=`, `.../mark-arrived`,
   `.../mark-in-progress`. Wire onto `provider_incoming_request_screen.dart`,
   `provider_job_details_screen.dart`, `provider_track_live_screen.dart`, `provider_jobs_screen.dart`.
   First-accept-wins → handle **409 ("job taken")** gracefully.

3. **✅ NEW — Availability toggle:** `PUT /api/provider/availability` (auth: Provider)
   - request `{ status: 0|1|2, latitude?: double, longitude?: double }`
   - response `{ status, latitude?, longitude? }`
   - `AvailabilityStatus`: **0 = Online, 1 = Offline, 2 = Busy**
   - Coordinates are written **only when both are supplied**.
   - ⚠️ **Going Online is the moment to publish position** — a provider with null coordinates
     **cannot be found by dispatch**. Capture GPS (`geolocator`) and send lat+lng with the Online toggle.
   Replaces the old "toggle via `PUT /api/profile`" workaround. Wire onto `provider_home_screen.dart`.

4. **Live location publish:** `PUT`/`POST /api/location/update` (`UpdateLocationDto`) — push GPS while
   En Route to feed the customer's tracking view.

5. **Earnings / wallet / payouts:** `GET /api/providers/earnings?period=daily|weekly|monthly|all`,
   `GET /api/providers/wallet`, `POST /api/providers/payouts` (`RequestPayoutDto {amount}`).
   Replace `provider_earnings_screen.dart` mock. (Commission now comes from settings server-side.)

6. **Review replies:** `POST /api/Reviews/{id}/reply` on `provider_reviews_screen.dart`.

**Deliverable check:** provider logs in, goes Online (with coords), sees pending offers, accepts one,
progresses status to completion, views earnings.

---

## PHASE 5 — Real-time (SignalR): dispatch, tracking, chat, notifications

Add `signalr_netcore`. Build a connection manager (`lib/core/realtime/`) opening hub connections with
the JWT via query string (`?access_token=<jwt>`) — the backend only reads the token from query on
`/hubs/*`. Handle connect/reconnect/token-refresh and re-join groups after reconnect.

**Hubs & events** (`KHDMA.Application/RealTime/Events.cs`):
- **BookingHub** `/hubs/booking` — client→server `JoinBookingGroup(bookingId)` / `LeaveBookingGroup`.
  - Provider: `JobDispatched(JobCardDto)`, `JobDispatchExpired`, `JobTaken`, `JobCancelled`.
  - Customer: `BookingStatusChanged`, `ProviderAssigned(ProviderCardDto)`,
    `ProviderLocation(ProviderLocationDto{lat,lng,heading?,etaMinutes?})`, `NoProviderFound`,
    `PaymentStatusChanged`.
- **ChatHub** `/hubs/chat` — client→server `JoinBooking`/`LeaveBooking`/`SendMessage`/`MarkRead`;
  receives `ReceiveMessage`, `MessageRead`, `ChatLocked`, `PresenceChanged`.
- **NotificationHub** `/hubs/notifications` → live badges.

Wire hub streams into the relevant cubits. Manage hub lifecycle with app foreground/background and logout.
**On reconnect, also call `GET /api/provider/pending-jobs`** (Phase 4) to recover missed offers.

Until Phase 7, the tracking screens show the **status timeline + ETA + textual position** driven by
these events; the visual map lands in Phase 7 on top of the same event stream.

**Deliverable check:** customer books → provider receives `JobDispatched` live → accepts → customer
sees `ProviderAssigned` and live status updates; chat messages appear in real time.

---

## PHASE 6 — Cleanup, hardening, end-to-end verification

1. **Remove template leftovers:** doctor-app enums in `lib/core/utils/enums.dart`, `car_params.dart`,
   `cart_params.dart`, `post_returns_sala_params.dart`, unused `sqflite` `database_helper.dart`, and
   any remaining `world-apm`/countries code.
2. **UX polish:** shimmer loading, empty states, error retry, pull-to-refresh, and pagination on every
   paged list (services, providers, history, notifications, chat, reviews). Verify Arabic/RTL.
3. **Quality gates:** `flutter analyze` clean; run `clean-code-guard` over the accumulated diff; add a
   few model `fromJson` / repo-mapping tests and run `test-guard`.

---

## PHASE 7 — Google Maps (full in-app) — FINAL PHASE

Everything below is additive: it replaces GPS-only location capture with real maps, and layers a visual
map over the already-working SignalR event stream.

### 7A. Google Cloud setup
1. <https://console.cloud.google.com> → create a project (e.g. "Khedma-Mobile"). Attach a **billing
   account** (Maps requires billing even within the free tier).
2. **APIs & Services → Library → Enable:** *Maps SDK for Android*, *Maps SDK for iOS*, *Places API*
   (autocomplete), *Geocoding API*, *Directions API* (route polyline + ETA). Optionally *Maps Static API*.
3. **Credentials → Create API key** — create **two restricted keys**:
   - **Android key:** restriction = *Android apps*; add the **package name** (the id set in Phase 0) +
     the **SHA-1** of both debug and release keystores (`gradlew signingReport`). API restriction =
     Maps SDK for Android.
   - **iOS key:** restriction = *iOS apps*; add the **bundle id**. API restriction = Maps SDK for iOS.
   - Add Places/Geocoding/Directions to the appropriate key's API restrictions. **Never commit keys.**
4. Pass keys via `--dart-define=GOOGLE_MAPS_API_KEY=...` (read in `AppConfig`) plus the native config below.
5. ⚠️ **Also hand a server key to the backend team** for `GoogleMaps:ApiKey` in `appsettings` — until
   then `/api/bookings/{id}/eta` returns straight-line Haversine, not road ETA.

### 7B. Packages & native config
- Add `google_maps_flutter`, `flutter_google_places_sdk` (or `google_places_flutter`), and
  `map_launcher` (or reuse `url_launcher`) for external navigation. `geolocator` + `geocoding` are
  already in from Phase 3.
- **Android** (`android/app/src/main/AndroidManifest.xml`): `INTERNET`, `ACCESS_FINE_LOCATION`,
  `ACCESS_COARSE_LOCATION`, plus
  `<meta-data android:name="com.google.android.geo.API_KEY" android:value="..."/>` inside `<application>`.
  Pin `minSdk` ≥ 21 in `build.gradle.kts`.
- **iOS**: `GMSServices.provideAPIKey("...")` in `AppDelegate.swift`; add
  `NSLocationWhenInUseUsageDescription` (+ `...AlwaysAndWhenInUse` if background tracking) to `Info.plist`.

### 7C. Screens to upgrade (style with `colors.*` + `TextStyles.*`)
| Screen (file) | Feature |
|---|---|
| `client/home/.../confirm_location_screen.dart` | **Address picker**: draggable map + centered pin, "use my location", Places autocomplete, reverse-geocode → returns `LatLng` + address into the booking flow / saved addresses. |
| `client/home/.../home_header.dart` + `service_details_screen.dart` | Location chip → open picker / saved addresses. |
| `client/home/.../track_live_screen.dart` | **Customer live tracking**: provider marker animated from SignalR `ProviderLocation`, route polyline (Directions), live ETA. |
| `client/home/.../provider_tracking_screen.dart` | Optional map of nearby providers being matched (`GET /api/providers/public` with `lat`/`lng`). |
| `provider/home/.../provider_track_live_screen.dart` + `provider_job_details_location_card.dart` | **Provider navigation map**: route to customer, "open in Google Maps" deep-link, live self-position publish. |
| `provider/profile/.../provider_profile_working_area_section.dart` | **Service-area picker**: draggable center + radius circle → persist via `PUT /api/profile`. |
| `client/bookings/.../booking_details_screen.dart` (`_BookingLocationCard`) | Mini-map centered on the booking address (lat/lng from `GET /api/Booking/{id}`) + "open in Maps". |

Build a reusable `LocationPickerScreen` and `LiveTrackingMap` shared by both roles. Finish the
commented `navigateTo(lat,lng)` helper in `lib/core/utils/constants.dart` for external deep-links.

**Deliverable check:** pick an address on a real map and book with those coords; provider sets a service
area; the tracking map animates the provider marker from live SignalR positions.

---

## Backend status

### ✅ Delivered — all verified in source at `final_part` @ `36cf206` (**not yet deployed**)
| Claim | Verified where |
|---|---|
| `GET /api/Booking/{id:guid}` — customer / assigned provider | `BookingController.cs:98`, `[Tags(CommonBookings)]` |
| `GET /api/provider/pending-jobs` | `ProviderController.cs:21` |
| `PUT /api/provider/availability` | `ProviderController.cs:38` |
| `GET /api/providers/public` | `PublicCatalogController.cs:54` |
| `userId` on login/refresh | `TokenResponseDto.cs:16` — `public string UserId` |
| `AvailabilityStatus` = 0 Online / 1 Offline / 2 Busy | `Domain/Enums/AvailabilityStatus.cs` |
| Absolute image URLs | `ImageUrlResolver` + `ImageUrlResolverTests.cs` (idempotent) |
| HTTPS redirect off in Dev | `Program.cs:357` — `if (!app.Environment.IsDevelopment())` |
| Stripe fully removed | zero matches in any `.cs` file |
| `whatsIncluded` removed | zero matches in any `.cs` file |
| Enums serialize as integers | no `JsonStringEnumConverter` / `AddJsonOptions` in `Program.cs` |
| Swagger response schemas | `[ProducesResponseType<…>]` present on all new endpoints |

`dotnet build` → **0 errors**.

### ⚠️ Blocked on us (mobile)
1. **Register field set** — confirm the final required fields per role so backend DTOs match the form.
   *Blocks Phase 1.*
2. **Google Maps API key** for the server (`GoogleMaps:ApiKey`) — until supplied, `/api/bookings/{id}/eta`
   returns Haversine. *Phase 7.*

### ❌ Still open on the backend
- **FCM push** — `POST /api/Notifications/register-token` returns **501**. No background push.
- **Auth-envelope standardization** — deliberately deferred so `AuthRespModel` keeps working.
- **CORS** allows only web origins (localhost:3000/5173) — irrelevant for native Flutter (no `Origin`
  header), but would block a Flutter **Web** build.
- **Deployment** — `khdma.runasp.net` still serves the old build. A teammate must redeploy
  (preserving the server's `appsettings.json`).
- **[V] `App:PublicBaseUrl` is unset** — image URLs currently derive from the request host. Fine
  locally; **must be set before/at deployment** or images will point at an internal host.
- **[V] Dead `StripeSettings` section still in `appsettings.json`** — the Stripe *code* is gone but the
  config block remains. Cosmetic only; worth deleting so nobody thinks Stripe is still wired.
- **[V] `Paymob` keys are all empty** (`ApiKey`, `IntegrationId`, `IframeId`, `HmacSecret`) — confirms
  payments are non-functional and the Phase 3 stub is the right call.

Reference payloads: `KHDMA_Full_Project_API.postman_collection.json`,
`KHDMA_Bookings_APIs.postman_collection.json`, `KHDMA-Admin.postman_collection.json` (admin — ignore).

---

## Verification (end-to-end)

Seeded accounts (`AppDbSeeder.cs`), all around Cairo (30.0444, 31.2357):
- Customer: `customer@test.com` / `Password123!`
- Providers: `provider@test.com`, `provider2@test.com`, `provider3@test.com` / `Password123!`
- (Admin `admin@khdma.com` — **do not** use in the mobile app.)

**Run steps:**
1. Check out `final_part` and start the backend on the **http** profile:
   `dotnet run --project KHDMA.API --launch-profile http` → confirm `http://localhost:5283/swagger`.
2. `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5283/api`
   (add `--dart-define=GOOGLE_MAPS_API_KEY=<key>` from Phase 7 onward).
3. **Customer:** register/login → browse categories/services/providers → set location → create a
   dispatch booking → open booking detail → watch it in history.
4. **Provider (2nd device/emulator):** login → go **Online with coordinates** → see pending offers →
   receive `JobDispatched` live → accept → progress En Route/Arrived/InProgress/Complete.
5. **Common:** chat in real time; edit profile + avatar; leave a review; check earnings.
6. Each phase ends with `flutter analyze` clean, its deliverable check passing, and `clean-code-guard`
   run over the diff.

**Review checkpoints:** pause for product-owner review after each phase — especially **Phase 1** (auth),
**Phase 3** (booking), **Phase 5** (SignalR), and **Phase 7** (maps).
