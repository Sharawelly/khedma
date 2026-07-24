# AGENTS.md — Khedma Flutter app

Arabic-first (RTL) services marketplace. Two mobile roles: **Customer** (`client`) and **Provider**.
There is **no admin role in this app** — never implement admin endpoints.

The UI is already built. The work in progress is replacing mock data with live calls to the KHDMA
.NET backend.

## Gates — run these before finishing, and fix what they surface

```bash
dart format lib test
flutter analyze
flutter test
```

`flutter analyze` is the hard gate: **zero errors**, and no new issues beyond the existing baseline
(the tree carries some pre-existing `info`/`warning` items that are not yours to fix unless the task
says so).

Use `dart format lib test` — **not** `dart format .`. This repo has a ~1.4 GB `build/` directory;
`dart format .` walks it and stalls for minutes on Windows.

### If you are a sandboxed agent

`flutter analyze`, `dart analyze`, and `flutter test` depend on a Dart **analysis-server child
process** that sandboxed environments typically block. If those commands hang or fail to start, that
is the sandbox — not a repo problem. Run `dart format lib test` only, and let whoever dispatched you
run the analyzer and tests. **Do not** try to launch the analysis server directly or drive its JSON
protocol as a workaround; it burns a lot of time and does not work.

Compensate by re-reading each file you change and verifying by hand that referenced symbols exist,
imports resolve, and every call site of anything you renamed or deleted has been updated.

### Backend id types (a real trap)

Every KHDMA resource id is a **GUID or an Identity string** — never an integer. In Dart these are all
`String`: booking ids, service ids, category ids, review ids, notification ids, and provider ids
(providers use the ASP.NET Identity user id, which is a string). Do not type any id as `int`.

## Architecture — clean architecture, feature-first

```
lib/features/<feature>/
  data/{models, datasources, repositories}
  domain/{entities, repositories, usecases (+ usecases/params)}
  presentation/{cubit, screen(s), widgets}
  <feature>_injection.dart      # setup<Feature>Injection(), registered in lib/injection_container.dart
```

Use `lib/features/auth/` as the reference vertical slice.

**Layer rules:**
- A **Model** extends its **Entity**. Hand-write `fromJson`/`toJson` — this project has **no**
  build_runner, freezed, or json_serializable. Do not add them.
- **Datasource** returns typed models (never `dynamic`), reads its endpoint from a constant, and
  throws `ServerException` when the response envelope reports failure.
- **Repository impl** maps model → entity and converts exceptions to `Left(Failure)`
  (`dartz` `Either<Failure, T>`).
- **UseCase** exposes a single `call(params)`.
- **Cubit** exposes **one** public method; states are initial / loading / success / failure. No model
  mapping inside a cubit.
- **DI**: repositories and use cases → `registerLazySingleton`; cubits → `registerFactory`.

**UI rules:**
- `BlocBuilder` for state. Loading → shimmer from `lib/core/widgets/shimmer/`. Error → red
  `SelectableText.rich`. No business logic in widgets.
- Check `lib/core/widgets/` for an existing widget before writing a new one.
- Colors come from the global `colors.*` getter (`lib/core/utils/values/app_colors.dart`) and text from
  `TextStyles.*`. Do **not** use `Theme.of(context)` for these.
- Sizing uses `flutter_screenutil` (`.w`, `.h`, `.sp`, `.r`).

**Localization:** every user-facing string is a key in `lang/ar.json` **and** `lang/en.json`, read via
the `.tr` extension. Never hardcode display text. Arabic is the default locale — use
`EdgeInsetsDirectional` / `AlignmentDirectional` so RTL stays correct.

## Reuse — do not reinvent

| Need | Use |
|---|---|
| HTTP | `dioConsumer` (`lib/core/api/dio_consumer.dart`) — injects the Bearer token, sets `lang`/`accept-language`, supports multipart `FormData`, maps errors to typed exceptions |
| Interceptors | `AppInterceptors` (`lib/core/api/app_interceptors.dart`) — emits an unauthorized event on 401 via `AuthEventBus` |
| Tokens | `secureStorage` (`lib/core/services/local_storage/app_secure_storage.dart`) |
| User/prefs | `sharedPreferences` (`lib/core/services/local_storage/app_shared_preferences.dart`) |
| Envelopes | `BaseOneResponse`, `BaseListResponse`, `PaginationModel` (`lib/core/base_classes/`) |
| Errors | `lib/core/error/{exceptions,failures}.dart` |

Global getters `dioConsumer`, `secureStorage`, `sharedPreferences`, `colors` come from
`lib/injection_container.dart`.

## Scaffolding skills

`.agents/skills/` holds the project's scaffolding procedures — read the relevant `SKILL.md` before
creating a slice:

- `flutter-new-feature` — a whole new feature, all layers
- `flutter-add-endpoint` — one new API action on an existing feature
- `flutter-generate-model` — model + entity from a JSON payload

Those skill docs contain some **stale paths**. The authoritative layout is the one above:
`domain/repositories/` (not `domain/repository/`), `data/repositories/` (not `data/repository/`),
`presentation/screen(s)/` (not `presentation/pages/`), and endpoint constants live in `ApiConstants`
inside `lib/core/api/dio_consumer.dart` (not `lib/core/utils/constants.dart`).

## KHDMA backend contract

Base URL is configured via `--dart-define=API_BASE_URL=...`; all routes sit under `/api`.
Local dev: Android emulator `http://10.0.2.2:5283/api`, iOS sim `http://localhost:5283/api`.

**Two response envelopes.** Auth (`/api/auth/*`) returns:

```jsonc
{ "isSuccess": true, "errorMessage": null,
  "token": { "accessToken", "refreshToken", "expiresAt", "role", "userName", "userId" } }
```

Everything else returns:

```jsonc
{ "success": true, "message": "...", "statusCode": 200, "data": <T> }
```

Paged responses put the array directly in `data` and add `page`, `pageSize`, `totalCount`,
`totalPages`, `hasNextPage`, `hasPreviousPage` at the **top level** — *not* nested under `data.items`.

**Contract facts that bite:**
- Image URLs are **absolute**. Never prepend a base host.
- `userId` is returned on login/refresh — never decode the JWT to get it.
- Enums serialize as **integers**, except `PendingJobDto.bookingType`, which is a **string**.
- `role` is `"Customer"` or `"Provider"`; route by this, not by a UI selection.

## House rules

- **Never** write process language into code or comments: no "Phase 3", "MVP", "for now", "TODO(plan)",
  ticket ids, or references to this task queue. Comments explain the code, not the project timeline.
- Comment only where intent is non-obvious. Do not narrate what the code already says.
- Keep changes scoped to the task. No opportunistic refactors, renames, or reformatting of untouched
  files.
- **Do not run `git add` or `git commit`.** Leave work uncommitted in the working tree; it is reviewed
  and committed by the orchestrator.
