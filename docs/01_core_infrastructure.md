# Task: Core Infrastructure

**Goal:** Build the reusable components and data layers that will be used across the entire app.

- [x] **UI Component Library (in `lib/presentation/widgets/`):**
    - [x] **`CustomTextField.dart`**: 
        - [x] Implement a `StatelessWidget` that wraps a `TextFormField`.
        - [x] Add parameters for `controller`, `labelText`, `hintText`, `validator`, and `obscureText`.
        - [x] Apply consistent styling from a theme.
    - [x] **`PrimaryButton.dart`**:
        - [x] Implement a `StatelessWidget` that wraps an `ElevatedButton`.
        - [x] Add parameters for `onPressed` and `text`.
        - [x] Style it as the main call-to-action button.
    - [x] **`SecondaryButton.dart`**:
        - [x] Implement a `StatelessWidget` that wraps an `OutlinedButton` or `TextButton`.
        - [x] Add parameters for `onPressed` and `text`.
        - [x] Style it as an alternative action button.
    - [x] **`ProductCard.dart`**:
        - [x] Implement a `StatelessWidget` to display a product.
        - [x] Include an image, product name, price, and an 'Add to Cart' button.
        - [x] Take a `Product` object as a parameter.
    - [x] **`CategoryCard.dart`**:
        - [x] Implement a `StatelessWidget` to display a category.
        - [x] Include the category name and a representative icon or image.
        - [x] Take a `Category` object as a parameter.
    - [x] **`ListItem.dart`**:
        - [x] Create a generic list item widget for use in shopping carts, order history, etc.
        - [x] Include parameters for a leading widget (e.g., image), title, subtitle, and trailing widget (e.g., price, quantity controls).
    - [x] **`LoadingSpinner.dart`**:
        - [x] Implement a `StatelessWidget` that displays a centered `CircularProgressIndicator`.
    - [x] **`EmptyState.dart`**:
        - [x] Implement a `StatelessWidget` to show when a list is empty.
        - [x] Include a message and an optional icon.
    - [x] **`ErrorDisplay.dart`**:
        - [x] Implement a `StatelessWidget` to show when an error occurs.
        - [x] Include an error message and a 'Retry' button.

- [x] **Data Models (in `lib/data/models/`):**
    - [x] **Implement `copyWith`, `fromJson`, and `toJson`:**
        - [x] For each model (`User`, `Product`, `Category`, `CartItem`, `Order`, `OrderItem`), implement the `copyWith` method for immutable updates.
        - [x] Implement `fromJson` and `toJson` methods for serialization/deserialization, even if only used for future remote API integration.

- [x] **Domain Layer (in `lib/domain/repositories/`):**
    - [x] **Define Repository Interfaces:**
        - [x] **`AuthRepository`**: `Future<void> login(String email, String password)`, `Future<void> register(User user)`, `Future<void> logout()`.
        - [x] **`ProductRepository`**: `Stream<List<Product>> watchProducts({String? categoryId})`, `Stream<List<Product>> searchProducts({String name})`, `Future<Product> getProductDetails(String productId)`.
        - [x] **`CategoryRepository`**: `Stream<List<Category>> watchCategories()`.
        - [x] **`CartRepository`**: `Stream<List<CartItem>> watchCartItems(int userId)`, `Future<void> addProductToCart(int userId, int productId)`, `Future<void> removeProductFromCart(int cartItemId)`.
        - [x] **`OrderRepository`**: `Stream<List<Order>> watchOrders(int userId)`, `Future<List<Order>> getOrdersForUser(int userId)`, `Future<Order> getOrderDetail(int orderId)`, `Future<void> createOrder(Order order, List<OrderItem> items)`.
        - [x] **`AdminRepository`**: `Future<void> addProduct(Product product)`, `Future<void> updateProduct(Product product)`, `Future<void> deleteProduct(int productId)`.

- [x] **Data Layer (implementations in `lib/data/repositories/`):**
    - [x] **Implement Concrete Repositories:**
        - [x] Create a class for each repository interface (e.g., `AuthRepositoryImpl`).
        - [x] Inject the appropriate Drift DAO into each repository implementation.
        - [x] Implement the methods defined in the interfaces by calling the DAO methods to interact with the local database.

- [x] **State Management (in `lib/presentation/providers/`):**
    - [x] **Create Riverpod Providers:**
        - [x] Create a `Provider` for each repository implementation.
        - [x] Create a `StateNotifierProvider` for authentication state (`auth_state_provider`) to manage the current user's status (logged in/out).
        - [x] Create `StreamProvider`s to expose the data streams from the repositories (e.g., `productsStreamProvider`, `cartItemsStreamProvider`, `orderHistoryProvider` to fetch and display the list of orders).