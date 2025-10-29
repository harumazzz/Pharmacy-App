# Task: Admin Panel

**Goal:** Create a section for admins to manage users, products, and orders, leveraging existing core infrastructure components.

- [ ] **Access Control:**
    - [ ] **Modify User Model and Database Table:**
        - [ ] In `lib/data/models/user.dart`, add a `bool isAdmin` field with a default value of `false`.
        - [ ] In `lib/data/local/table/users_table.dart`, add a corresponding `boolean` column for `isAdmin`.
        - [ ] Run `flutter pub run build_runner build --delete-conflicting-outputs` to regenerate Drift files.
    - [ ] **Implement Admin Access Guard:**
        - [ ] Create a new widget (e.g., `AdminGuard`) in `lib/presentation/widgets/` that wraps admin-specific routes or screens.
        - [ ] This guard should use `auth_state_provider` (from `lib/presentation/providers/`) to check the `isAdmin` status of the currently logged-in user.
        - [ ] If the user is not an admin, redirect them to a non-admin screen (e.g., home screen) or display an access denied message.

- [ ] **UI (in `lib/presentation/screens/admin/`):**
    - [ ] **`AdminDashboardScreen.dart`:**
        - [ ] Create a `StatelessWidget` for the main admin dashboard.
        - [ ] Include `PrimaryButton.dart` or `SecondaryButton.dart` widgets for navigation to `UserManagementScreen`, `ProductManagementScreen`, and `OrderManagementScreen`.
    - [ ] **`UserManagementScreen.dart`:**
        - [ ] Create a `StatelessWidget` to display a list of all users.
        - [ ] Use `allUsersProvider` (to be created) to fetch user data.
        - [ ] Display each user using `ListItem.dart` (or a similar custom widget), showing user name, email, and `isAdmin` status.
        - [ ] Add functionality (e.g., buttons within `ListItem.dart` or a separate dialog) to toggle a user's `isAdmin` status.
    - [ ] **`ProductManagementScreen.dart`:**
        - [ ] Create a `StatelessWidget` to display a list of all products.
        - [ ] Use `allProductsProvider` (to be created) to fetch product data.
        - [ ] Display each product using `ProductCard.dart` (or a similar custom widget).
        - [ ] Include `PrimaryButton.dart` for "Add New Product" (navigating to `ProductEditScreen`).
        - [ ] For each product, add `SecondaryButton.dart` for "Edit" (navigating to `ProductEditScreen` with product data) and "Delete" (calling `deleteProduct` from `AdminRepository`).
    - [ ] **`ProductEditScreen.dart`:**
        - [ ] Create a `StatefulWidget` for adding or editing a product.
        - [ ] Use `CustomTextField.dart` for product `name`, `description`, `price`, `category_id`, and `image_url`.
        - [ ] Implement form validation for all fields.
        - [ ] Use `PrimaryButton.dart` for "Save" or "Add Product" action.
        - [ ] On save, call `addProduct` or `updateProduct` from `AdminRepository` based on whether it's a new product or an edit.
    - [ ] **`OrderManagementScreen.dart`:**
        - [ ] Create a `StatelessWidget` to display a list of all orders.
        - [ ] Use `allOrdersProvider` (to be created) to fetch order data.
        - [ ] Display each order using `ListItem.dart` (or a similar custom widget), showing order ID, user, total price, and current status.
        - [ ] Add functionality (e.g., dropdown or buttons) to update the `status` of an order using `updateOrderStatus` from `AdminRepository`.
        - [ ] Implement navigation to view detailed order information (potentially reusing `getOrderDetail` from `OrderRepository`).

- [ ] **Logic (using Riverpod and Repositories):**
    - [ ] **`AdminRepository` (in `lib/domain/repositories/admin_repository.dart` and `lib/data/repositories/admin_repository_impl.dart`):**
        - [ ] **`Future<List<User>> getAllUsers()`:** Implement this method in `AdminRepositoryImpl` to fetch all users from the `AppDatabase`'s `UsersDao`.
        - [ ] **`Future<void> toggleUserAdminStatus(int userId, bool isAdmin)`:** Implement this method to update the `isAdmin` flag for a specific user in the database.
        - [ ] **`Future<void> addProduct(Product product)`:** (Already defined, ensure implementation uses `AppDatabase`'s `ProductsDao`).
        - [ ] **`Future<void> updateProduct(Product product)`:** (Already defined, ensure implementation uses `AppDatabase`'s `ProductsDao`).
        - [ ] **`Future<void> deleteProduct(int productId)`:** (Already defined, ensure implementation uses `AppDatabase`'s `ProductsDao`).
        - [ ] **`Future<List<Order>> getAllOrders()`:** Implement this method in `AdminRepositoryImpl` to fetch all orders from the `AppDatabase`'s `OrdersDao`.
        - [ ] **`Future<void> updateOrderStatus(int orderId, String status)`:** Implement this method to update the `status` of a specific order in the database.
    - [ ] **Providers (in `lib/presentation/providers/admin/`):**
        - [ ] **`allUsersProvider`:** Create a `StreamProvider` or `FutureProvider` that exposes `AdminRepository.getAllUsers()`.
        - [ ] **`allProductsProvider`:** Create a `StreamProvider` or `FutureProvider` that exposes `ProductRepository.watchProducts()` (or a new admin-specific method if needed).
        - [ ] **`allOrdersProvider`:** Create a `StreamProvider` or `FutureProvider` that exposes `AdminRepository.getAllOrders()`.
        - [ ] **`adminProductManagementProvider`:** Create a `StateNotifierProvider` to handle product-related actions (add, edit, delete) and state within the `ProductManagementScreen` and `ProductEditScreen`.
        - [ ] **`adminOrderManagementProvider`:** Create a `StateNotifierProvider` to handle order status updates and state within the `OrderManagementScreen`.
        - [ ] **`adminUserManagementProvider`:** Create a `StateNotifierProvider` to handle user admin status toggling and state within the `UserManagementScreen`.
