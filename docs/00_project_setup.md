# Task: Project Setup & Configuration

**Goal:** Configure the foundational tools and project settings to establish a robust and scalable architecture for the pharmacy application.

- [x] **Drift Setup:**
    - [x] **Define Database Tables:**
        - [x] Create `users_table.dart` in `lib/data/local/table/` and define the `Users` table with columns for `id`, `name`, `email`, `password`, and `address`.
        - [x] Create `products_table.dart` in `lib/data/local/table/` and define the `Products` table with columns for `id`, `name`, `description`, `price`, `category_id`, and `image_url`.
        - [x] Create `categories_table.dart` in `lib/data/local/table/` and define the `Categories` table with columns for `id`, `name`, and `description`.
        - [x] Create `cart_items_table.dart` in `lib/data/local/table/` and define the `CartItems` table with columns for `id`, `user_id`, `product_id`, and `quantity`.
        - [x] Create `orders_table.dart` in `lib/data/local/table/` and define the `Orders` table with columns for `id`, `user_id`, `total_price`, `status`, and `order_date`.
        - [x] Create `order_items_table.dart` in `lib/data/local/table/` and define the `OrderItems` table with columns for `id`, `order_id`, `product_id`, `quantity`, and `price`.
    - [x] **Configure AppDatabase:**
        - [x] In `lib/data/local/app_database.dart`, import all table classes.
        - [x] Add all tables to the `@DriftDatabase` annotation.
        - [x] Define abstract DAOs for each table within the `AppDatabase` class.
    - [x] **Generate Database Code:**
        - [x] Run `flutter pub run build_runner build --delete-conflicting-outputs` to generate the necessary Drift files (`.g.dart` and `.drift.dart`).
        - [x] Verify that the generated files are free of errors.

- [x] **Riverpod Setup:**
    - [x] **Initialize ProviderScope:**
        - [x] In `lib/main.dart`, wrap the `MyApp` widget with a `ProviderScope` to make providers available throughout the widget tree.

- [x] **Dependency Injection:**
    - [x] **Configure Service Providers:**
        - [x] In `lib/di/injection.dart`, create a provider for the `AppDatabase` instance.
        - [x] Create providers for each repository, injecting the `AppDatabase` DAOs as dependencies.
        - [x] Create providers for any other services, such as a hypothetical `ApiService` for remote data.

- [x] **Project Structure:**
    - [x] **Create Presentation Layer Directories:**
        - [x] Create `lib/presentation/screens/` for application screens (e.g., `auth`, `home`, `products`, `cart`, `profile`).
        - [x] Create `lib/presentation/widgets/` for reusable UI components.
    - [x] **Review Linting Rules:**
        - [x] Open `analysis_options.yaml` and ensure the linting rules are configured to enforce best practices (e.g., `avoid_print`, `prefer_const_constructors`).
