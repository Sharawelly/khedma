---
name: flutter-new-feature
description: Scaffolds a complete Flutter clean architecture feature from scratch or from a JSON payload. Use when the user says "create new feature", "scaffold feature", "full feature from JSON", or provides a JSON and asks to build a complete feature end-to-end including model, entity, datasource, repository, usecase, cubit, and UI screen.
---

# Flutter New Feature

Generates all layers of a clean architecture feature in order. Replace `{feature}` and `{Feature}` with the feature name throughout.

## Execution Order

Work through these 7 steps sequentially. Do not skip any step.

### Step 1 — Model(s)

File: `lib/features/{feature}/data/models/{name}_resp_model.dart`

- List response → extend `BaseListResponse`, parse `data` as:
  `List<{Name}Model>.from((json["data"]["items"] ?? []).map((x) => {Name}Model.fromJson(x)))`
- Single response → extend `BaseOneResponse`, parse `data` as:
  `json["data"] == null ? null : {Name}Model.fromJson(json["data"])`
- Every model generates `fromJson()` and `toJson()`.

### Step 2 — Entity/Entities

File: `lib/features/{feature}/domain/entities/{name}_entity.dart`

- Plain Dart class with final fields.
- The corresponding model must extend this entity.

### Step 3 — Remote Data Source

File: `lib/features/{feature}/data/datasources/{feature}_remote_datasource.dart`

- Add method returning the model type (no `dynamic`, no business logic).
- Use endpoint constant from `lib/core/utils/constants.dart`. Add the constant there if missing.
- Accept a `Params` object if the call requires any input (see Step 3b).

**Step 3b — Params class** (if the call has any input):

File: `lib/features/{feature}/domain/usecases/params/{Feature}{Action}Params.dart`

```dart
class {Feature}{Action}Params {
  final String? field;
  const {Feature}{Action}Params({this.field});

  Map<String, dynamic> toJson() => {"field": field};

  {Feature}{Action}Params copyWith({String? field}) =>
      {Feature}{Action}Params(field: field ?? this.field);
}
```

### Step 4 — Repository Interface

File: `lib/features/{feature}/domain/repository/{feature}_repository.dart`

```dart
abstract class {Feature}Repository {
  Future<Either<Failure, {Name}Entity>> get{Name}(...);
}
```

### Step 5 — Repository Implementation

File: `lib/features/{feature}/data/repository/{feature}_repository_impl.dart`

- Call data source, convert model → entity, catch exceptions → return `Failure`.

### Step 6 — Use Case

File: `lib/features/{feature}/domain/usecases/get_{feature}.dart`

```dart
class Get{Feature} {
  final {Feature}Repository repository;
  Get{Feature}(this.repository);

  Future<Either<Failure, {Name}Entity>> call({Feature}Params params) =>
      repository.get{Name}(params);
}
```

### Step 7 — Cubit + State

State file: `lib/features/{feature}/presentation/cubit/{feature}_state.dart`
Cubit file: `lib/features/{feature}/presentation/cubit/{feature}_cubit.dart`

- States: initial, loading, success, failure.
- Cubit has **one public method** only.
- No model mapping inside cubit.

### Step 8 — UI Screen

File: `lib/features/{feature}/presentation/pages/{feature}_page.dart`

- Uses `BlocBuilder` on the cubit.
- Loading state → shimmer from `lib/core/widgets/shimmer/`.
- Error state → `SelectableText.rich` in red.
- No business logic in UI.
- Check `lib/core/widgets/` for reusable widgets before creating new ones.
- Figma assets rule: if the image is an icon, download/use it as SVG;
  otherwise download/use it as PNG or JPG.

## Dependency Injection

File: `lib/features/{feature}/{feature}_injection.dart`

```dart
void setup{Feature}Injection() {
  ServiceLocator.instance
    ..registerLazySingleton<{Feature}Repository>(
        () => {Feature}RepositoryImpl(ServiceLocator.instance()))
    ..registerLazySingleton(() => Get{Feature}(ServiceLocator.instance()))
    ..registerFactory(() => {Feature}Cubit(ServiceLocator.instance()));
}
```

Register `setup{Feature}Injection()` inside `lib/injection_container.dart`.
