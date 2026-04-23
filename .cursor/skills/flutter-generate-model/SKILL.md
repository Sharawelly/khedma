---
name: flutter-generate-model
description: Generates a Flutter data model and its domain entity from a JSON payload. Use when the user says "generate model from JSON", "create model", "create entity", provides a JSON and asks to generate only the model/entity layer, or needs to add a new response model to an existing feature.
---

# Flutter Generate Model

Generates a response model + domain entity pair from a JSON payload.

## Step 1 — Determine Response Type

| JSON shape | Base class |
|---|---|
| `data` is an array | `BaseListResponse` |
| `data` is an object | `BaseOneResponse` |

## Step 2 — Create the Entity

File: `lib/features/{feature}/domain/entities/{name}_entity.dart`

```dart
class {Name}Entity {
  final int? id;
  final String? name;
  // ... all fields

  const {Name}Entity({this.id, this.name});
}
```

- Plain Dart class, final fields, no JSON logic.

## Step 3 — Create the Model

File: `lib/features/{feature}/data/models/{name}_model.dart`

**List variant:**
```dart
class {Name}sRespModel extends BaseListResponse {
  final List<{Name}Model>? items;

  {Name}sRespModel.fromJson(Map<String, dynamic> json)
      : items = List<{Name}Model>.from(
            (json["data"]["items"] ?? [])
                .map((x) => {Name}Model.fromJson(x))),
        super.fromJson(json);
}

class {Name}Model extends {Name}Entity {
  const {Name}Model({super.id, super.name});

  factory {Name}Model.fromJson(Map<String, dynamic> json) =>
      {Name}Model(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
```

**Single object variant:**
```dart
class {Name}RespModel extends BaseOneResponse {
  final {Name}Model? data;

  {Name}RespModel.fromJson(Map<String, dynamic> json)
      : data = json["data"] == null
            ? null
            : {Name}Model.fromJson(json["data"]),
        super.fromJson(json);
}
```

## Rules

- Use the exact list key name from the JSON (e.g. `json["data"]["products"]`).
- Never use `dynamic`. Use typed lists.
- `copyWith()` only if fields will be mutated after creation.
- Follow the same style as `CountriesRespModel` and `CountryModel`.
