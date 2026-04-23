---
name: flutter-add-endpoint
description: Adds a single new API action to an existing Flutter feature, wiring the full clean architecture stack: params class, datasource method, repository interface update, repository implementation update, new use case, and a new cubit. Use when the user says "add endpoint", or asks to add a new API call to an existing feature without rebuilding the whole feature from scratch.
---

# Flutter Add Endpoint

Adds one new API action to an **existing** feature. Work through each step in order.

## Step 1 — Params (if any input is required)

File: `lib/features/{feature}/domain/usecases/params/{Feature}{Action}Params.dart`

```dart
class {Feature}{Action}Params {
  final String? fieldName;
  const {Feature}{Action}Params({this.fieldName});

  Map<String, dynamic> toJson() => {"field_name": fieldName};

  {Feature}{Action}Params copyWith({String? fieldName}) =>
      {Feature}{Action}Params(
        fieldName: fieldName ?? this.fieldName,
      );
}
```

Skip this step if the endpoint takes no input.

## Step 2 — Datasource Method

File: `lib/features/{feature}/data/datasources/{feature}_remote_datasource.dart`

- Add the method to the abstract class and its implementation.
- Use the endpoint constant from `lib/core/utils/constants.dart`. Add it there if missing.
- Return the typed model — never `dynamic`.

```dart
// Abstract
Future<{Name}RespModel> {action}{Name}({Feature}{Action}Params params);

// Implementation
@override
Future<{Name}RespModel> {action}{Name}({Feature}{Action}Params params) async {
  final response = await _dio.post(
    ApiConstants.{endpointConstant},
    data: params.toJson(),
  );
  return {Name}RespModel.fromJson(response.data);
}
```

## Step 3 — Repository Interface

File: `lib/features/{feature}/domain/repository/{feature}_repository.dart`

Add the abstract method:
```dart
Future<Either<Failure, {Name}Entity>> {action}{Name}(
  {Feature}{Action}Params params,
);
```

## Step 4 — Repository Implementation

File: `lib/features/{feature}/data/repository/{feature}_repository_impl.dart`

```dart
@override
Future<Either<Failure, {Name}Entity>> {action}{Name}(
  {Feature}{Action}Params params,
) async {
  try {
    final result = await remoteDataSource.{action}{Name}(params);
    return Right(result.data!);
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  }
}
```

## Step 5 — Use Case

File: `lib/features/{feature}/domain/usecases/{action}_{feature}.dart`

```dart
class {Action}{Feature} {
  final {Feature}Repository repository;
  {Action}{Feature}(this.repository);

  Future<Either<Failure, {Name}Entity>> call(
    {Feature}{Action}Params params,
  ) => repository.{action}{Name}(params);
}
```

## Step 6 — Cubit + State

State: `lib/features/{feature}/presentation/cubit/{action}_{feature}_state.dart`
Cubit: `lib/features/{feature}/presentation/cubit/{action}_{feature}_cubit.dart`

- States: initial, loading, success(`{Name}Entity`), failure(`String`).
- Cubit exposes **one method** only.

## Step 7 — Dependency Injection

In `lib/features/{feature}/{feature}_injection.dart`, register:

```dart
ServiceLocator.instance
  ..registerLazySingleton(() => {Action}{Feature}(ServiceLocator.instance()))
  ..registerFactory(() => {Action}{Feature}Cubit(ServiceLocator.instance()));
```
