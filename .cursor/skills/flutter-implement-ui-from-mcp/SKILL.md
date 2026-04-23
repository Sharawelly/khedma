---
name: flutter-implement-ui-from-mcp
description: Implements a Flutter UI screen or widget from ANY design-source MCP (Figma, Stitch, Claude Design, Penpot, Sketch cloud, Builder.io, Locofy, or any future design MCP server), enforcing this project's clean-architecture UI rules (core widgets first, MyColors/AppColors tokens, TextStyles helpers, ScreenUtil sizing, SVG icons, localized strings, shimmer loading). Use when the user says "implement UI from MCP", "build this screen from design", "implement this design", "create UI from Figma/Stitch/Claude Design", pastes a design-tool link, node id, frame URL, or screenshot, or asks Cursor (especially in Auto mode) to turn any design source into a Flutter screen or widget.
---

# Implement UI from Design MCP → Flutter

Turn a node fetched from **any design-source MCP** (Figma, Stitch, Claude Design, Penpot, Sketch cloud, Builder.io, Locofy, or any other MCP server that exposes design data) into a production-ready Flutter screen or widget inside `lib/features/{feature}/presentation/`. The rules below are source-agnostic: whatever the MCP is called, the same mapping to project tokens applies. This skill is the **UI-only** companion to `flutter-new-feature`; it does not create datasources, repos, usecases, or cubits. If those are also missing, run `flutter-new-feature` first.

## Supported design MCP sources (non-exhaustive)

Any MCP that can return one or more of: node tree, frame / artboard geometry,
fills / strokes / shadows, typography, design tokens / variables, or exported
assets. Examples:

- **Figma MCP** — frames, components, variables, asset exports.
- **Stitch MCP** — generated UI concepts / screens.
- **Claude Design MCP** — AI-generated design artifacts.
- **Penpot / Sketch cloud / Builder.io / Locofy / Zeplin-style MCPs** — any
  server exposing design nodes and assets.
- **Screenshot / image-only MCP** — if only a raster image is available,
  treat it as a visual reference: infer geometry, typography, and palette,
  then still map everything to the project tokens below.

Pick the richest tool the MCP offers (structured node data > raw image) and
fall back to visual inference only when structured data is not available.

## 0. Read before you code

Before generating any widget, the agent MUST open and scan:

1. `lib/core/widgets/` — every file. Reuse before re-implementing.
   Known reusable widgets (non-exhaustive):
   - Buttons: `MyDefaultButton`, `AppOutlinedButton`, `AppTextIconButton`,
     `AuthButton`, `CircularIconButton`, `AppSettingsButton`,
     `AppNotificationBellButton`.
   - Inputs: `AppTextFormField`, `AppDropdownField`, `SearchTextField`,
     `BlockWritingField`, `BlockChoiceOptionTile`.
   - Images: `AppImage` (`.asset` / `.file` / `.network`, `isCached: true`),
     `CachedNetworkImageWithFallback`, `ImageUploadWidget`, `SliderPhoto`.
   - Feedback: `AppShimmer` (primitive) + feature-local `{name}_shimmer.dart`
     widgets (e.g. `FormReasonSelectorShimmer`), `LoadingView`, `NoDataFound`,
     `ErrorText`, `AppSnackBar` (use for one-shot action feedback like
     "saved" / "copied", never for state-level errors), `CustomAlert`,
     `ConfirmationDialog`, `LogoutDialog`, `ExitAppDialog`, `ShowDialog`,
     `ShowModalBottomSheet`, `ModalBottomSheetScaffold`.
   - Layout: `Gaps` (use `Gaps.hGapN` / `Gaps.vGapN` / `Gaps.line` instead of
     raw `SizedBox(width/height: N.w/.h)` whenever a matching N exists),
     `AppDivider`, `CustomAppBar`, `AppBarWithTitle`, `AppCenteredHeaderBar`,
     `AppPageHeader`, `BackButton`, `AppBottomNavBar`, `GuestPlaceholderScreen`.
   - Misc: `Logo`, `TypeWriterEffect`, `OnBoardingPageDots`, `WeekDotCircle`,
     `WatcherCountBadge`, `FilterButton`, `DateTimeRow`, `DiffImg`,
     `FormReasonSelector` / `FormReasonSelectorShimmer`.
2. `lib/core/utils/values/app_colors.dart` — `MyColors` palette + `AppColors`
   theme extension (the list of tokens available as `colors.*` in features).
   Also open `lib/config/themes/app_theme.dart` (`kDefaultAppColors`) and
   `lib/injection_container.dart` (global `colors` getter) so the agent knows
   where to wire new tokens.
3. `lib/core/utils/values/text_styles.dart` — `TextStyles.boldNN` /
   `mediumNN` / `semiBoldNN` / `regularNN` / `lightNN` helpers.
4. Asset catalogues:
   - `lib/core/utils/values/svg_manager.dart` (`SvgAssets`),
   - `lib/core/utils/values/img_manager.dart` (`ImageAssets`),
   - `lib/core/utils/values/lottie_manager.dart` (`LottieAssets`),
   - `lib/core/utils/values/animation_assets.dart` (`AnimationAssets` — also
     Lottie),
   - `lib/core/utils/values/gif_manager.dart` (`GifAssets`).
5. Core extensions / helpers in `lib/core/utils/`:
   - `extension.dart` — `ColorFilterExtension.setColor(...)`,
     `ColorFilterExtension.getFocustextColor(focusNode)`,
     `ImageExtension.cacheSize(context)`,
     `CircularProgressIndicatorExtension.appLoading`.
   - `media_query_values.dart` — `context.height`, `context.width`,
     `context.toPadding`, `context.bottom`.
   - `fixed_text_scale.dart` — `FixedTextScale` wrapper for fixed-layout areas.
   - `convert_string_color.dart` — `convertStringColor('#RRGGBB')` for hex
     strings coming from the API/data layer.
   - `validator.dart` — form field validators.
   - `date_format.dart` / `date_excetension.dart` — dates.
6. `lib/core/widgets/gaps.dart` — catalogue of `Gaps.hGapN` / `Gaps.vGapN`
   constants available (use these before introducing a new `SizedBox`).
7. `lib/core/utils/constants.dart` — shimmer base/highlight colors
   (`baseColorShimmer`, `highlightColorShimmer`), `Constants.showLoading`,
   `Constants.hideLoading`, `Constants.makePhoneCall`, `Constants.launchEmail`,
   `Constants.getInitials`, `ArabicNumeric.*`, etc. Also `ApiConstants.baseUrl`
   for any URL composition.
8. `lib/config/routes/app_routes.dart` — the `Routes` class holds every route
   path (`Routes.loginScreenRoute`, `Routes.homeRoute`, …). Use these
   constants for GoRouter navigation; add a new constant here if the design
   introduces a new screen.
9. `lib/config/locale/app_localizations.dart` — defines the `.tr` extension
   (reads from `appLocalizations.text(key)` which loads
   `lang/{locale}.json`). Also exposes `appLocalizations.isArLocale` /
   `isEnLocale` for locale-aware logic.
10. `lang/en.json` and `lang/ar.json` for existing translation keys.
    **Both files are flat, snake_case key/value maps** (e.g.
    `"email_is_empty": "..."`). Keys are NOT dotted (`home.title` ❌ →
    `home_title` ✅). Both files may be currently empty — the agent must add
    every new key to **both** before using `.tr`.

If an exact match exists in core, use it. If something close exists but needs
a new variation, **extend core first**; do not fork styling into a feature.

## 1. Fetch the design from the MCP

1. Identify which design MCP is available (Figma, Stitch, Claude Design,
   Penpot, Builder.io, …). Read its tool descriptors under
   `C:/Users/Lenovo/.cursor/projects/d-Flutter-khedma/mcps/<server>/tools/`
   before calling, so required arguments are correct.
2. Use the richest tool the MCP offers to fetch the target node — frame,
   screen, artboard, component, or generated concept. Prefer, in order:
   structured node tree → design-token / variable list → exported assets →
   raw image. Only fall back to visual inference from a screenshot when
   structured data is unavailable.
3. Extract, per element: geometry (w/h, padding, gap), fill / stroke / shadow,
   corner radius, typography (family, weight, size, line-height, letter-spacing),
   and any bound design-system variable / token name.
4. Download assets:
   - **Icons → SVG.** Save under `assets/icons/` and add a constant to
     `SvgAssets` in `lib/core/utils/values/svg_manager.dart`.
   - **Non-icon images (photos, illustrations) → PNG or JPG.** Save under
     `assets/images/` and add a constant to `ImageAssets` in
     `lib/core/utils/values/img_manager.dart`.
   - For remote / cached URLs, add them as constants in `ImageAssets` (or an
     equivalent constants file) and render via `AppImage.network(isCached: true)`
     or `CachedNetworkImageWithFallback`.
   - Never embed raw asset paths or URLs in feature widgets.
5. Register any new asset directories in `pubspec.yaml` if not already covered.

## 2. Map design tokens → project tokens

Translate every value coming from the design MCP to a project token before
writing code. Never hardcode. The mapping is the same regardless of whether
the source is Figma, Stitch, Claude Design, or another MCP.

### Colors — use the injected `colors` getter (`AppColors` from GetIt)

**In every feature widget, the final color reference must be the injected
`colors.*` getter, not `MyColors.*` and never an inline `Color(0xFF…)`.**

The project exposes a global getter in `lib/injection_container.dart`:

```dart
AppColors get colors => ServiceLocator.instance<AppColors>();
```

It resolves the `AppColors` `ThemeExtension` registered at startup
(`kDefaultAppColors` in `lib/config/themes/app_theme.dart`), and is re-injected
on theme change via `ServiceLocator.injectAppColors`. This is the single
source of truth for runtime color values in features.

#### How to use in a widget

```dart
import 'package:khedma/injection_container.dart'; // exposes `colors`

Container(
  color: colors.backGround,
  child: Text(
    'home_title'.tr,
    style: TextStyles.semiBold16(color: colors.textColor),
  ),
);
```

- Use `colors.main`, `colors.homeHeadline`, `colors.errorColor`,
  `colors.mainAlpha20`, `colors.kitsCardBorder`, etc.
- For opacity on an injected color, prefer an existing alpha token
  (`colors.mainAlpha20 / 26 / 31 / 40 / 50 / 60`). If a different alpha is
  truly needed, prefer adding a new alpha token (see "Adding a missing color"
  below). When a one-off alpha is genuinely justified (e.g. scrim /
  `barrierColor`), use the modern Flutter API
  `colors.textColor.withValues(alpha: 0.65)` — **never** the deprecated
  `.withOpacity(...)`.

#### Where `MyColors.*` is allowed

`MyColors` is the **palette definition** — the raw `static const Color`
values. It must only be referenced in:

- `lib/core/utils/values/app_colors.dart` itself (defining `MyColors`).
- `lib/config/themes/app_theme.dart` (wiring `kDefaultAppColors` and any
  Material theme fields).
- Any other core-level theme / service wiring that runs before `AppColors`
  is injected.

**Never** use `MyColors.*` inside `lib/features/**` UI. Inside features, go
through `colors.*`. (The same rule applies to `Theme.of(context).extension<AppColors>()` —
prefer the global `colors` getter to keep widgets clean; only reach for the
theme extension if a widget must rebuild on live theme swaps that bypass DI.)

#### Decision flow for a color coming from the design

1. Search `AppColors` fields (and `MyColors` for the hex) — match by **hex
   value**, not by the design-tool's name.
2. If the hex already exists → use `colors.<existingToken>`, even if its
   name differs from the design.
3. If it does **not** exist → **add it to `MyColors` + `AppColors` +
   `kDefaultAppColors` first**, then use `colors.<newToken>` in the widget.
4. Never write `Color(0xFF...)`, `Colors.grey[300]`, `Colors.black54`, or
   `Colors.white.withOpacity(0.5)` inline in feature UI.

Common mappings already in the palette (reference by `colors.*`):

| Design intent | Injected token |
|---|---|
| Primary brand green | `colors.main` (`#1FA971`) |
| Secondary / warm accent | `colors.secondary` (`#E0A04B`) |
| Page background (white) | `colors.backGround` |
| Soft cream surface | `colors.upBackGround` |
| Primary body text | `colors.textColor` |
| Muted / caption text | `colors.lightTextColor` |
| Light neutral surface | `colors.lightBackGroundColor` |
| Error / destructive | `colors.errorColor` |
| Pure white on color | `colors.whiteColor` |
| Rating / review amber | `colors.review` |
| Primary with opacity | `colors.mainAlpha20 / 26 / 31 / 40 / 50 / 60` |
| Soft card shadow | `colors.shadowCardLight` / `shadowCardMedium` / `shadowSoft` |
| Home headings / progress / captions | `colors.homeHeadline` / `homeProgressLabel` / `homeCaption` |
| Blocks surfaces | `colors.blocksStatSurface` / `blocksStatBorder` / `blocksHeroChipBg` / … |
| Paths info chip | `colors.pathsInfoSurface` / `pathsInfoAccent` |
| Onboarding palette | `colors.onboarding*` |
| Disabled button bg / text | `colors.disabledButtonBg` / `disabledButtonText` |

#### Adding a missing color

When the design uses a hex that doesn't exist yet, all four places must be
updated **in the same change** — otherwise DI resolution for the new token
will crash at runtime.

1. **Name it by role, not by hue.** Prefix with the feature / surface family
   so it's discoverable (e.g. `kitsCardBorder`, `pathsInfoAccent`,
   `blocksStatSurface`), not `green1` / `lightGrey2`.
2. **Palette** — add a `static const Color` to `MyColors` in
   `lib/core/utils/values/app_colors.dart`, grouped with related tokens.
3. **Theme extension** — in the same file, update `AppColors`:
   - Add `final Color yourNewToken;` field.
   - Add `required this.yourNewToken` to the constructor.
   - Add an optional named arg and branch in `copyWith`.
   - Add a `Color.lerp(...)` line in `lerp`.
4. **Default instance** — in
   `lib/config/themes/app_theme.dart`, add
   `yourNewToken: MyColors.yourNewToken,` to `kDefaultAppColors`.
5. **Use** `colors.yourNewToken` in the feature widget. Never the raw hex,
   never `MyColors.yourNewToken` from inside `lib/features/**`.

Example — adding `kitsCardBorder` = `#E6EEF5`:

```dart
// lib/core/utils/values/app_colors.dart

class MyColors {
  // ...existing tokens...

  /// Kits — card outline.
  static const Color kitsCardBorder = Color(0xFFE6EEF5);
}

@immutable
class AppColors extends ThemeExtension<AppColors> {
  // ...existing fields...
  final Color kitsCardBorder;

  const AppColors({
    // ...existing required params...
    required this.kitsCardBorder,
  });

  @override
  AppColors copyWith({
    // ...existing optional params...
    Color? kitsCardBorder,
  }) {
    return AppColors(
      // ...existing ?? this.x...
      kitsCardBorder: kitsCardBorder ?? this.kitsCardBorder,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors> other, double t) {
    if (other is! AppColors) return this;
    final appColors = AppColors(
      // ...existing Color.lerp lines...
      kitsCardBorder:
          Color.lerp(kitsCardBorder, other.kitsCardBorder, t) ??
          kitsCardBorder,
    );
    ServiceLocator.injectAppColors(appColors: appColors);
    return appColors;
  }
}
```

```dart
// lib/config/themes/app_theme.dart

final AppColors kDefaultAppColors = AppColors(
  // ...existing params...
  kitsCardBorder: MyColors.kitsCardBorder,
);
```

```dart
// lib/features/kits/presentation/widgets/kits_card.dart

Container(
  decoration: BoxDecoration(
    color: colors.whiteColor,
    border: Border.all(color: colors.kitsCardBorder, width: 1),
    borderRadius: BorderRadius.circular(12.r),
  ),
);
```

**Rules (enforced):**
- Features use `colors.*` only. `MyColors.*` stays in the palette +
  `app_theme.dart`.
- Never write `Color(0xFF...)`, `Colors.grey[N]`, `Colors.black54`, or the
  deprecated `.withOpacity(...)` inside feature UI. For a genuine one-off
  alpha, use `.withValues(alpha: 0.NN)` on a `colors.*` token, but first
  check whether an alpha token (`mainAlpha20` / …) already covers it.
- Never introduce the same hex under a second name — reuse the existing
  token.
- Adding a token **must** update `MyColors` + `AppColors` (field +
  constructor + `copyWith` + `lerp`) + `kDefaultAppColors` in the same
  change. Leaving any of them out of sync is a bug and will throw at DI
  resolve time.
- For alpha variants of `colors.main`, prefer existing
  `colors.mainAlpha20 / 26 / 31 / 40 / 50 / 60` before adding a new one.

### Typography (`TextStyles` in `lib/core/utils/values/text_styles.dart`)

Cairo via Google Fonts, sized with `.sp` through ScreenUtil. Pick the helper
matching the design's weight + size (whatever the source tool calls it):

| Design weight | Helper family |
|---|---|
| 300 | `TextStyles.lightNN` |
| 400 | `TextStyles.regularNN` |
| 500 | `TextStyles.mediumNN` |
| 600 | `TextStyles.semiBoldNN` |
| 700+ | `TextStyles.boldNN` |

Use the closest available `NN` (e.g. 10, 12, 13, 14, 15, 16, 17, 18, 20, 22, 24, 28, 32…).
If the exact size is missing:

1. Add a new static to `TextStyles` following the existing pattern before
   using it.
2. Use `.copyWith` for one-off color / height / letterSpacing / decoration.

Use `Theme.of(context).textTheme` **only** when a Material role is required
(e.g. inside an `InputDecoration` label) and no `TextStyles` helper fits.

### Sizing (`flutter_screenutil`)

Every pixel value coming from the design (regardless of source MCP) must be
wrapped:

- Widths, horizontal padding/margin, gaps: `.w`
- Heights, vertical padding/margin, gaps: `.h`
- Border radii, icon sizes, small square buttons/avatars: `.r`
- Font sizes: `.sp` (already inside `TextStyles`)

Examples:

```dart
padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 12.h),
BorderRadius.circular(12.r),
Icon(Icons.check, size: 20.r),
```

Do **not** use raw `double` literals for padding, `SizedBox`, container sizes,
or `BorderRadius.circular` inside feature UI.

#### Gaps — prefer `Gaps.*` over raw `SizedBox`

`lib/core/widgets/gaps.dart` exposes constant gaps at the common Figma
spacings (both `.w` for horizontal, `.h` for vertical). Use them before
introducing a `SizedBox`:

- Horizontal (between items in a `Row`): `Gaps.hGap4`, `hGap8`, `hGap10`,
  `hGap12`, `hGap16`, `hGap20`, `hGap24`, `hGap30`, `hGap32`, `hGap36`,
  `hGap40`, `hGap50`, …
- Vertical (between sections in a `Column` / `ListView`): `Gaps.vGap4`,
  `vGap8`, `vGap10`, `vGap12`, `vGap16`, `vGap20`, `vGap24`, `vGap32`,
  `vGap40`, `vGap50`, `vGap60`, `vGap72`, `vGap100`, …
- `Gaps.line` for a thin hairline (design-system divider alternative to
  `AppDivider`), `Gaps.empty` for a no-op widget.

If the design needs a spacing that isn't in `Gaps`, **add a new `Gaps.hGapN`
or `vGapN` constant first** (following the existing naming, `.w` / `.h`
wrapping) instead of inlining `SizedBox(height: N.h)` in a feature widget.

#### Directionality / RTL

The app supports Arabic (`ar_SA`) — every screen will be mirrored on RTL.
The agent must:

- Use `EdgeInsetsDirectional.only(start:, end:, top:, bottom:)` and
  `EdgeInsetsDirectional.symmetric(...)` instead of `EdgeInsets.only(left/right)`.
- Use `AlignmentDirectional.centerStart` / `centerEnd` / `topStart` / etc.
  instead of `Alignment.centerLeft` / `centerRight`.
- Use `PositionedDirectional(start:, end:, …)` inside `Stack` instead of
  `Positioned(left:, right:, …)`.
- Use `textDirection` / `Directionality.of(context)` only when the design
  explicitly mandates LTR (e.g. numeric fields). Default: inherit.
- For asymmetric borders, shadows, or gradients that should flip in RTL,
  make sure the flip is honored (e.g. use `BorderRadiusDirectional`).
- Do not hardcode "left" / "right" semantics where "start" / "end" applies.

#### Media-query helpers

For screen-size-aware layouts, use the `MediaQueryValues` extension from
`lib/core/utils/media_query_values.dart`:

- `context.height`, `context.width` — logical device size.
- `context.toPadding` — top status-bar inset.
- `context.bottom` — bottom viewInsets (keyboard).

Prefer these over manually reading `MediaQuery.of(context)` in features.

#### Text scaling

When the design has a fixed layout that would break under large
`textScaleFactor` (e.g. small chips with fixed height), wrap only that
subtree in `FixedTextScale(child: ...)` from
`lib/core/utils/fixed_text_scale.dart`. Do **not** blanket-wrap entire screens.

### Strings (localization)

- Every user-visible string lives in `lang/en.json` **and** `lang/ar.json`.
- Keys are **flat snake_case**, never dotted. Good: `'email_is_empty'.tr`,
  `'home_greeting'.tr`, `'login_welcome_title'.tr`. Bad: `'home.title'`,
  `'HomeGreeting'`, `'home-greeting'`.
- In widgets, render via the `.tr` extension on `String` (defined in
  `lib/config/locale/app_localizations.dart`): `'home_greeting'.tr`.
- Never call `appLocalizations.text('key')` directly in features, and never
  hardcode an Arabic or English literal in a widget.
- When adding a new key, write it to **both** `lang/en.json` and
  `lang/ar.json` in the same change (both files may be empty today — the
  agent must add the entry in each). Keep the same key list in both files.
- For locale-aware branches (e.g. choosing `nameEn` vs `nameAr`), use
  `appLocalizations.isArLocale` / `isEnLocale` instead of reading the
  `Locale` manually.

### Assets

- **Icons (SVG):**
  `SvgPicture.asset(SvgAssets.xxx, width: 24.r, height: 24.r, colorFilter: ColorFilterExtension.setColor(colors.main))`.
  Prefer the `ColorFilterExtension.setColor(...)` shorthand from
  `lib/core/utils/extension.dart` over raw
  `ColorFilter.mode(..., BlendMode.srcIn)`. For icons inside a focusable
  field, use `ColorFilterExtension.getFocustextColor(focusNode)`.
- **Local raster images:** `AppImage.asset(ImageAssets.xxx, ...)`.
- **Remote images:** `AppImage.network(url, isCached: true, ...)` or
  `CachedNetworkImageWithFallback`. For large remote images in lists, pass
  `cacheWidth: someLogicalWidth.cacheSize(context)` /
  `cacheHeight: someLogicalHeight.cacheSize(context)` using
  `ImageExtension.cacheSize(context)` to avoid decoding at full resolution.
  Always supply an `errorBuilder` when using raw `Image.network` (avoided in
  features; kept in core).
- **Animations (Lottie):** use `LottieAssets.*` from
  `lib/core/utils/values/lottie_manager.dart` (or `AnimationAssets.*` from
  `animation_assets.dart` for the extra set). Render with the `lottie`
  package; add new constants before inlining a path.
- **Animations (GIF):** use `GifAssets.*` from
  `lib/core/utils/values/gif_manager.dart` via `AppImage.asset`.
- **API-provided colors:** if the data layer returns a hex string (e.g.
  `"#1FA971"`), convert once at the cubit/model boundary with
  `convertStringColor(hex)` from `lib/core/utils/convert_string_color.dart`.
  Never parse hex strings inside widgets.

If the design references an asset format the catalogues don't yet have (new
Lottie, new GIF, new icon), **download it and add the constant to the
matching `*Assets` class first**, then reference the constant.

## 3. File placement

Strict per `api.mdc`:

| Artifact | Path |
|---|---|
| Screen | `lib/features/{feature}/presentation/screen/{feature}_screen.dart` (follow the feature's existing `screen/` vs `screens/` convention) |
| Feature widgets | `lib/features/{feature}/presentation/widgets/{name}.dart` (one file per widget or small related group) |
| Feature-local shimmer | `lib/features/{feature}/presentation/widgets/{name}_shimmer.dart` — only if the core shimmer primitives don't cover the layout |

**Never** split a screen with private `Widget _buildHeader()` / `_buildCard()`
methods. Every visual chunk becomes a **named public widget class** in
`presentation/widgets/` and is composed in the screen.

### Splitting rules — keep the screen file thin

A screen file is the **composition root**; the visual content lives in
widget files. Enforce these targets:

- **Screen file budget: ~150 lines max** (≤ 200 in exceptional cases).
  It should contain: imports, the `StatelessWidget` / `StatefulWidget`
  declaration, the `Scaffold`/`AppBar`/`body` scaffolding, the `BlocBuilder` /
  `BlocListener` plumbing, and a tight list of child widgets. Nothing else.
- **Widget file budget: ~200 lines max.** If a widget grows past that,
  split nested pieces into their own files (e.g. `HomeHeader` may compose
  `HomeGreetingRow`, `HomeNotificationBell`, `HomeSearchChip`).
- **One public widget per file** (small tightly-coupled helpers — a private
  tile used by only one list widget — may live in the same file, but never
  multiple top-level named widgets that are used elsewhere).

#### When to extract a new widget (any of these → extract)

1. The chunk has a **distinct name in the design** (header, hero card,
   stats strip, progress tile, bottom CTA). One-to-one with a Figma frame /
   auto-layout group.
2. The chunk **renders independently** of its siblings' data.
3. It has **2+ child widgets or 20+ lines** of build code.
4. It will be **reused** (even once) anywhere else.
5. It has **its own shimmer** state.
6. It owns **local state** (controller, focus, expansion flag) that the
   rest of the screen doesn't need.

#### Splitting workflow

Given a design frame:

1. Walk the design's node tree top-down. Each top-level section of the
   screen → one widget class in `presentation/widgets/`.
2. Name by role + feature prefix: `HomeHeader`, `HomeStatsRow`,
   `HomeDailyKitCard`, `KitsCurrentKitHero`, `BlocksProgressTile`,
   `PathsInfoChip`. Avoid `HomeWidget1`, `Section2`, `CustomContainer`.
3. Pass only the data a widget needs via a typed constructor param
   (entity, value object, primitives) — not the full cubit state.
4. Keep callbacks as `VoidCallback` / `ValueChanged<T>` parameters; the
   screen wires them to `context.read<XCubit>().xxx()`. Never inject a
   cubit into a leaf widget just to call one method.
5. Shared subtree (used by 2+ features) → move to `lib/core/widgets/`
   and reuse via `colors.*` + `TextStyles.*`. Feature-only subtree stays
   in `features/{feature}/presentation/widgets/`.
6. If a widget needs its own loading state, create a matching
   `{name}_shimmer.dart` sibling file.

#### Example decomposition

A Figma "Home" frame with `Header + StatsRow + DailyKitCard + RecentList`
decomposes as:

```
lib/features/home/presentation/
├── screen/
│   └── home_screen.dart                # composition only (~120 lines)
└── widgets/
    ├── home_header.dart                # greeting + bell + avatar
    ├── home_header_shimmer.dart
    ├── home_stats_row.dart             # 3 small stat tiles
    ├── home_stats_tile.dart            # one stat (reused 3x in the row)
    ├── home_daily_kit_card.dart
    ├── home_daily_kit_card_shimmer.dart
    ├── home_recent_list.dart           # ListView.builder wrapper
    └── home_recent_item.dart           # single row
```

`home_screen.dart` then reads like a table of contents — only widget
references, gaps, and state plumbing — never raw `Container` trees.

## 4. Widget authoring rules

- `const` everywhere possible.
- Prefer `StatelessWidget`; use `StatefulWidget` only for local UI state
  (controllers, focus, tab index).
- No business logic in UI — only cubit reads and dispatches.
- No `dynamic`; full null-safety.
- Meaningful names: `HomeHeader`, `KitHeroCard`, `BlocksProgressTile` — not
  `Widget1`, `CustomContainer`, `MyWidget`.
- `log` (from `dart:developer`) instead of `print`.
- `textCapitalization`, `keyboardType`, `textInputAction` on every text field
  (including `AppTextFormField`).
- Validate form fields with helpers from `lib/core/utils/validator.dart`; do
  not re-implement email / phone / required checks inline.
- Use `RefreshIndicator` for pull-to-refresh.
- Use `ListView.builder` for lists; never `ListView(children: [...])` for
  dynamic data.

### Scaffold, app bar, modals, navigation

- **Scaffold background.** The theme's default `scaffoldBackgroundColor` is
  `MyColors.whiteColor`. Omit `backgroundColor` on `Scaffold` unless the
  design clearly uses a different surface — in which case use `colors.*`
  (e.g. `colors.upBackGround`, `colors.onboardingBackground`).
- **App bar.** If the design has a top bar, reuse one of `CustomAppBar`,
  `AppBarWithTitle`, `AppCenteredHeaderBar`, or `AppPageHeader` before
  building a raw `AppBar`. If you need a back chevron, use the project
  `BackButton` from `lib/core/widgets/back_button.dart`, not `IconButton` +
  `Navigator.pop`.
- **Dialogs.** Use `ShowDialog`, `ConfirmationDialog`, `LogoutDialog`,
  `ExitAppDialog`, or `CustomAlert` from `lib/core/widgets/`. Do **not** call
  `showDialog(...)` directly with an inline `AlertDialog` in features.
- **Bottom sheets.** Use `ShowModalBottomSheet` + `ModalBottomSheetScaffold`
  (both in `lib/core/widgets/`) — not raw `showModalBottomSheet(...)`.
- **One-shot feedback.** Use `AppSnackBar` (success / info after an action).
  State failures still render inside the screen as `SelectableText.rich`.
- **Navigation.** Use `GoRouter` for any `push` / `go` / deep link. Route
  paths live as constants in `lib/config/routes/app_routes.dart`
  (the `Routes` class — e.g. `Routes.loginScreenRoute`,
  `Routes.homeRoute`, `Routes.blockDetailRoute`). Add a new `Routes.*`
  constant before adding a matching `GoRoute` and using it via
  `context.go(Routes.xxx)` / `context.push(Routes.xxx)`. Never hardcode a
  route string in a widget.
- **Snackbars.** Use the named helper `showAppSnackBar(context: context,
  message: 'key'.tr, type: ToastType.success | error | warning | info)`
  from `lib/core/widgets/app_snack_bar.dart`. `ToastType` is defined in
  that same file (not in `enums.dart`). Reserve snackbars for one-shot
  action feedback only.

## 5. State rendering (inside `BlocBuilder` / `BlocConsumer`)

| State | Render |
|---|---|
| Loading | A shimmer built on `AppShimmer` (`lib/core/widgets/app_shimmer.dart`) — either an existing feature-local `{name}_shimmer.dart` widget or a new one in `lib/features/{feature}/presentation/widgets/`. No `CircularProgressIndicator` unless the user explicitly asks (then use `showLoading` from `lib/core/utils/constants.dart`). |
| Success | The real layout built from cubit data. |
| Empty | Handled in the same screen — usually `NoDataFound`. |
| Error | `SelectableText.rich` in `colors.errorColor`. No SnackBars for state errors. |

Feature-local shimmer widgets must **mirror the success layout's boxes**
(same sizes, radii, gaps) and be wrapped in `AppShimmer`. The base / highlight
colors are pre-configured via `baseColorShimmer` / `highlightColorShimmer`
inside `AppShimmer`; don't override them per feature.

`AppSnackBar` is **only** for one-shot action feedback (copied / saved /
shared). State-level errors (failed loads, failed submits handled by
`BlocBuilder`) render as `SelectableText.rich`.

## 6. Implementation workflow

Track progress with this checklist:

```
UI Implementation:
- [ ] Identified the active design MCP (Figma / Stitch / Claude Design / other)
- [ ] Opened core widgets, Gaps, colors, text styles, asset catalogues, extensions
- [ ] Fetched design node + tokens + assets via MCP (structured data preferred)
- [ ] Downloaded icons as SVG → SvgAssets, images as PNG/JPG → ImageAssets,
      animations as Lottie → LottieAssets / AnimationAssets, GIFs → GifAssets
- [ ] Mapped every color to an injected `colors.*` token (added new ones to MyColors + AppColors + kDefaultAppColors when missing)
- [ ] Mapped every text style to TextStyles (added new helpers where needed)
- [ ] Replaced raw `SizedBox(...)` with `Gaps.*` (added new `Gaps.*` constants if sizes were missing)
- [ ] Used `EdgeInsetsDirectional` / `AlignmentDirectional` / `PositionedDirectional` for RTL safety
- [ ] Used `ColorFilterExtension.setColor(...)` for SVG tinting
- [ ] Replaced any remote-image `cacheWidth`/`cacheHeight` with `ImageExtension.cacheSize(context)`
- [ ] Used injected `colors` only (no `MyColors.*` or hex in features)
- [ ] Used core AppBar / Dialog / BottomSheet / Validator wrappers (no raw Material calls)
- [ ] Added missing translation keys (flat snake_case) to BOTH
      `lang/en.json` and `lang/ar.json`
- [ ] Walked the design's node tree and split every top-level section into
      a named public widget in `presentation/widgets/` (one widget per file,
      `{feature}_{role}.dart`)
- [ ] Screen file stays ≤ ~150 lines — composition only, no inline layout
      trees, no private `Widget _buildXxx()` helpers
- [ ] Any widget > ~200 lines was further split (nested sections → own files)
- [ ] Each widget receives only the data it needs (typed param), callbacks
      via `VoidCallback` / `ValueChanged<T>` — cubit is read in the screen
- [ ] Built screen composing widgets + BlocBuilder
- [ ] Replaced any `CircularProgressIndicator` with `AppShimmer`-based shimmer
- [ ] Replaced any hardcoded strings with `'key'.tr` (snake_case)
- [ ] Replaced every raw px with `.w` / `.h` / `.r`
- [ ] Navigation goes through GoRouter + `Routes.*` in
      `lib/config/routes/app_routes.dart` (no hardcoded route strings)
- [ ] Action feedback uses `showAppSnackBar(..., type: ToastType.xxx)`
- [ ] Replaced any `.withOpacity(...)` with `.withValues(alpha:)` or a
      proper alpha token
- [ ] Ran ReadLints on edited files, fixed issues
```

## 7. Minimal screen template

Use as a starting shape; rename and fill with real widgets from the design.
Note how the screen is **pure composition** — every visual section is its
own widget in `presentation/widgets/`, the screen just wires state → widgets
and widgets → callbacks.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/core/utils/values/text_styles.dart';
import 'package:khedma/core/widgets/gaps.dart';
import 'package:khedma/features/your_feature/presentation/cubit/your_feature_cubit.dart';
import 'package:khedma/features/your_feature/presentation/cubit/your_feature_state.dart';
import 'package:khedma/features/your_feature/presentation/widgets/your_feature_header.dart';
import 'package:khedma/features/your_feature/presentation/widgets/your_feature_stats_row.dart';
import 'package:khedma/features/your_feature/presentation/widgets/your_feature_hero_card.dart';
import 'package:khedma/features/your_feature/presentation/widgets/your_feature_items_list.dart';
import 'package:khedma/features/your_feature/presentation/widgets/your_feature_shimmer.dart';
import 'package:khedma/injection_container.dart'; // `colors`

class YourFeatureScreen extends StatelessWidget {
  const YourFeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.backGround,
      body: SafeArea(
        child: BlocBuilder<YourFeatureCubit, YourFeatureState>(
          builder: (context, state) {
            if (state is YourFeatureLoading) {
              return const YourFeatureShimmer();
            }
            if (state is YourFeatureFailure) {
              return Padding(
                padding: EdgeInsets.all(16.w),
                child: SelectableText.rich(
                  TextSpan(
                    text: state.message,
                    style: TextStyles.regular14(color: colors.errorColor),
                  ),
                ),
              );
            }
            if (state is YourFeatureSuccess) {
              return RefreshIndicator(
                onRefresh: () => context.read<YourFeatureCubit>().load(),
                child: ListView(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  children: [
                    YourFeatureHeader(data: state.data.header),
                    Gaps.vGap16,
                    YourFeatureStatsRow(stats: state.data.stats),
                    Gaps.vGap24,
                    YourFeatureHeroCard(
                      hero: state.data.hero,
                      onAction: () =>
                          context.read<YourFeatureCubit>().onHeroTap(),
                    ),
                    Gaps.vGap24,
                    YourFeatureItemsList(items: state.data.items),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
```

Each referenced widget (`YourFeatureHeader`, `YourFeatureStatsRow`,
`YourFeatureHeroCard`, `YourFeatureItemsList`, …) lives in its own file
under `lib/features/your_feature/presentation/widgets/` and receives only
the data it needs plus callbacks — the screen stays short.

## 8. Auto-mode quick reference (do / don't)

**Do**
- `colors.main`, `colors.homeHeadline`, `colors.mainAlpha20`,
  `colors.errorColor` (injected `AppColors` via `colors` getter)
- `TextStyles.semiBold16(color: colors.textColor)`
- `Gaps.vGap16`, `Gaps.hGap8`, `Gaps.line` instead of raw `SizedBox`
- `BorderRadius.circular(12.r)`, `.w` / `.h` / `.r`
- `EdgeInsetsDirectional.only(start: 16.w, end: 8.w)`,
  `AlignmentDirectional.centerStart`, `PositionedDirectional(start: 0, …)`
- `'home_title'.tr` (flat snake_case keys in both `lang/en.json` and
  `lang/ar.json`), `appLocalizations.isArLocale` for locale branches
- `SvgPicture.asset(SvgAssets.navHome, width: 24.r, height: 24.r,
  colorFilter: ColorFilterExtension.setColor(colors.main))`
- `AppImage.network(url, isCached: true, cacheWidth: 320.cacheSize(context))`
- `MyDefaultButton(...)`, `AppTextFormField(...)`, `AppShimmer(...)`,
  `CustomAppBar(...)`, `ShowDialog(...)`, `ShowModalBottomSheet(...)`,
  `AppSnackBar(...)`, `NoDataFound()`, `BackButton()`
- `LottieAssets.*` / `AnimationAssets.*` for animations,
  `GifAssets.*` for GIFs
- `context.height` / `context.width` / `context.toPadding` / `context.bottom`
  from `MediaQueryValues`
- `convertStringColor(hex)` when the API returns a color string (at cubit /
  model boundary, not in widgets)
- `Validator.*` for form field validation
- `GoRouter` + `Routes.*` constants from `lib/config/routes/app_routes.dart`
  for navigation (`context.go(Routes.homeRoute)`)
- `showAppSnackBar(context: context, message: 'saved'.tr, type: ToastType.success)`
  for one-shot action feedback
- If a color from the design is missing → add it to `MyColors` + `AppColors`
  + `kDefaultAppColors`, then use `colors.newToken`
- If a gap size is missing from `Gaps` → add the new `Gaps.hGapN` / `vGapN`
  constant first, then use it
- One named public widget per file in `presentation/widgets/`, named
  `{Feature}{Role}` (e.g. `HomeHeader`, `KitsHeroCard`, `BlocksProgressTile`)
- Screen file ≤ ~150 lines, widget file ≤ ~200 lines — split further when
  exceeded

**Don't**
- `MyColors.main` (or any `MyColors.*`) inside `lib/features/**`
- `Theme.of(context).extension<AppColors>()!.main` inside features (prefer
  the global `colors` getter)
- `Color(0xFF1FA971)` / `Colors.grey[300]` / `Colors.black54` /
  `.withOpacity(...)` on a color token inline in features
- `TextStyle(fontSize: 16, fontWeight: FontWeight.w600)` inline
- `SizedBox(height: 24)`, `BorderRadius.circular(12)`, raw `double` sizes
- `SizedBox(height: 16.h)` when `Gaps.vGap16` already exists
- `EdgeInsets.only(left:, right:)` / `Alignment.centerLeft` /
  `Positioned(left:, right:)` in layouts that must mirror in RTL
- `Text('Welcome')` or `appLocalizations.text('welcome')`
- `Image.asset(...)`, `Image.network(...)`, `CachedNetworkImage` in features
- `ColorFilter.mode(colors.main, BlendMode.srcIn)` (use
  `ColorFilterExtension.setColor(colors.main)`)
- `CircularProgressIndicator` for state loading
- `SnackBar` for state errors (that's `SelectableText.rich` in the screen)
- Raw `showDialog(...)` / `showModalBottomSheet(...)` / inline `AlertDialog`
- Raw `AppBar(...)` when a `CustomAppBar` variant fits
- `Navigator.pushNamed(...)` / `context.push('/home')` with hardcoded route
  strings (use GoRouter + `Routes.*` from `lib/config/routes/app_routes.dart`)
- Dotted translation keys (`'home.title'` ❌ — use `'home_title'` ✅)
- Adding a translation key to only one of the two JSON files (must land in
  both `lang/en.json` and `lang/ar.json` in the same change)
- `Widget _buildHeader()` / `_buildCard()` private helpers inside a screen
- Long screens (> ~200 lines) built from inline `Container` / `Column`
  trees instead of composed named widgets
- Passing a `Cubit` / full `State` down into a leaf widget when a typed
  value param + callback would do
- Multiple public widgets in a single file (one widget per file, except for
  tightly-coupled private helpers used by only that file)
- Duplicating a widget that already exists in `lib/core/widgets/`
