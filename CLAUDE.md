# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter-based pharmacy e-commerce application with offline-first architecture using Drift (SQLite) for local data persistence, Riverpod for state management, and Injectable/GetIt for dependency injection.

## Build & Development Commands

### Code Generation
The project uses build_runner for generating Drift, Freezed, Injectable, and JSON serialization code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
Run this after modifying:
- Database tables (in `lib/data/local/table/`)
- DAOs (in `lib/data/local/dao/`)
- Models with `@freezed` annotation (in `lib/data/models/`)
- Providers with `@riverpod` annotation
- Injectable classes with `@injectable`, `@singleton`, or `@lazySingleton`

### Running the App
```bash
flutter run
```

### Analysis & Linting
```bash
flutter analyze
```

### Testing
```bash
flutter test
```

## Architecture

### Layer Structure (Clean Architecture)

1. **Domain Layer** (`lib/domain/repositories/`): Abstract repository interfaces defining contracts
2. **Data Layer** (`lib/data/`):
   - `models/`: Freezed data classes with JSON serialization
   - `local/table/`: Drift table definitions
   - `local/dao/`: Drift DAOs for database operations
   - `repositories/`: Concrete repository implementations
3. **Presentation Layer** (`lib/presentation/`):
   - `widgets/`: Reusable UI components
   - `screens/`: Screen implementations
   - `providers/`: Riverpod providers for state management
4. **Dependency Injection** (`lib/di/`): Injectable configuration with GetIt

### Database Architecture (Drift)

The app uses Drift for SQLite database management with these tables:
- `Users`: User accounts with authentication data
- `Categories`: Product categories
- `Products`: Product catalog with pricing and inventory
- `CartItems`: Shopping cart entries
- `Orders`: Order records
- `OrderItems`: Line items for each order

Each table has:
- A table definition in `lib/data/local/table/`
- A DAO in `lib/data/local/dao/` for database operations
- All tables and DAOs are registered in `AppDatabase` (`lib/data/local/app_database.dart`)

### Dependency Injection Pattern

The app uses Injectable with GetIt:
- Initialize DI in `main()` with `configureDependencies()`
- Mark implementations with:
  - `@LazySingleton(as: Interface)` for repository implementations
  - `@singleton` for database and other singletons
- The AppDatabase is a singleton injected into repository implementations

### State Management Pattern

Uses Riverpod with two approaches:
- **Legacy**: Manual provider definitions (existing auth providers)
- **Recommended**: Riverpod code generator with `@riverpod` annotations (use for new code)

Provider types:
- `StreamProvider`: For real-time data from Drift (e.g., product lists, cart items)
- `FutureProvider`: For one-time async operations
- `StateNotifierProvider`: For complex state management (e.g., auth state)

### Model Pattern

All data models use Freezed:
```dart
@freezed
sealed class ModelName with _$ModelName {
  const factory ModelName({
    required int id,
    required String field,
  }) = _ModelName;

  factory ModelName.fromJson(Map<String, dynamic> json) =>
      _$ModelNameFromJson(json);
}
```

### Repository Implementation Pattern

Repositories bridge domain layer (interfaces) to data layer (Drift DAOs):

1. Define interface in `lib/domain/repositories/`
2. Implement in `lib/data/repositories/` with:
   - `@LazySingleton(as: InterfaceType)` annotation
   - Constructor injecting `AppDatabase`
   - Convert Drift table classes to domain models
   - Use `.watch()` for streams, `.get()` or `.getSingle()` for futures

Example pattern:
```dart
@LazySingleton(as: domain.ProductRepository)
class ProductRepositoryImpl implements domain.ProductRepository {
  final AppDatabase _db;

  const ProductRepositoryImpl(this._db);

  @override
  Stream<List<model.Product>> watchProducts({int? categoryId}) {
    final query = _db.select(_db.products);
    if (categoryId != null) {
      query.where((p) => p.categoryId.equals(categoryId));
    }
    return query.watch().map((rows) => rows.map(_toModel).toList());
  }
}
```

### UI Component Library

Reusable widgets in `lib/presentation/widgets/`:
- `CustomTextField`: Form input with validation
- `PrimaryButton`/`SecondaryButton`: Styled action buttons
- `ProductCard`: Product display with add-to-cart
- `CategoryCard`: Category display
- `ListItem`: Generic list item for carts/orders
- `LoadingSpinner`: Loading indicator
- `EmptyState`: Empty list placeholder
- `ErrorDisplay`: Error message with retry

### Vietnamese Language Requirement

All UI strings and user-facing messages must be in Vietnamese (as specified in project docs).

## Development Workflow

### Adding a New Feature

1. Define model in `lib/data/models/` with Freezed
2. Create table in `lib/data/local/table/`
3. Create DAO in `lib/data/local/dao/`
4. Register table and DAO in `AppDatabase`
5. Run `flutter pub run build_runner build --delete-conflicting-outputs`
6. Define repository interface in `lib/domain/repositories/`
7. Implement repository in `lib/data/repositories/`
8. Create Riverpod providers in `lib/presentation/providers/`
9. Build UI screens and widgets

### Modifying Database Schema

When changing tables:
1. Update table definition in `lib/data/local/table/`
2. Increment `schemaVersion` in `AppDatabase`
3. Add migration logic if needed
4. Run build_runner to regenerate code
5. Update affected DAOs and repositories

## Implementation Status

Completed features (see `docs/` for detailed task lists):
- Core infrastructure and UI component library
- Database setup with Drift
- Authentication flow (login/register)
- User authentication state management

In progress/upcoming features (see project docs):
- Product catalog and search functionality
- Shopping cart and checkout
- Order management and history
- Admin panel for product/order management
