# Task: User Order History

**Goal:** Allow users to see their past and current orders.

## Detailed Implementation Tasks

### 1. Data Models (`lib/data/models/`)

*   **`Order` Model:**
    *   [ ] Ensure `lib/data/models/order.dart` defines the `Order` class with properties like `id`, `userId`, `orderDate`, `totalAmount`, `status`, etc.
    *   [ ] Implement `copyWith` method for immutable updates, as per `01_core_infrastructure.md`'s Data Models section.
    *   [ ] Implement `fromJson` and `toJson` methods for serialization/deserialization, as per `01_core_infrastructure.md`'s Data Models section.
*   **`OrderItem` Model:**
    *   [ ] Ensure `lib/data/models/order_item.dart` defines the `OrderItem` class with properties like `id`, `orderId`, `productId`, `quantity`, `price`, etc.
    *   [ ] Implement `copyWith` method for immutable updates, as per `01_core_infrastructure.md`'s Data Models section.
    *   [ ] Implement `fromJson` and `toJson` methods for serialization/deserialization, as per `01_core_infrastructure.md`'s Data Models section.
*   **`Product` Model:**
    *   [ ] Verify `lib/data/models/product.dart` exists and is correctly implemented with `copyWith`, `fromJson`, and `toJson` as `OrderItem` will reference `Product` details.

### 2. Data Layer Implementation (`lib/data/local/table/` and `lib/data/repositories/`)

*   **Drift DAOs for Order and OrderItem:**
    *   [ ] Create `order_dao.dart` in `lib/data/local/table/` to manage `Order` table operations.
        *   Define the `Orders` table schema, mirroring the `Order` model properties.
        *   Implement methods for `insertOrder`, `getOrdersForUser`, `getOrderDetailStream`, `getOrderDetailFuture`.
    *   [ ] Create `order_item_dao.dart` in `lib/data/local/table/` to manage `OrderItem` table operations.
        *   Define the `OrderItems` table schema, mirroring the `OrderItem` model properties and linking to `Orders` and `Products` tables.
        *   Implement methods for `insertOrderItem`, `getOrderItemsForOrder`.
    *   [ ] Integrate these DAOs into `app_database.dart`.

*   **`OrderRepositoryImpl` (`lib/data/repositories/order_repository_impl.dart`):**
    *   [ ] Create `order_repository_impl.dart`.
    *   [ ] Implement the `OrderRepository` interface (from `lib/domain/repositories/order_repository.dart`).
    *   [ ] Inject `OrderDao` and `OrderItemDao` into `OrderRepositoryImpl`.
    *   [ ] Implement `getOrdersForUser(userId)`:
        *   Utilize `OrderDao.getOrdersForUser` to fetch a `Future<List<Order>>`.
    *   [ ] Implement `getOrderDetail(orderId)`:
        *   Utilize `OrderDao.getOrderDetailFuture` to fetch a `Future<Order>`.
        *   Fetch associated `OrderItem`s using `OrderItemDao.getOrderItemsForOrder`.
        *   Combine `Order` and `OrderItem` data into a comprehensive `Order` object (potentially with a list of `OrderItem`s).
    *   [ ] Implement `watchOrders(userId)`:
        *   Utilize `OrderDao.getOrderDetailStream` to provide a `Stream<List<Order>>`.
    *   [ ] Implement `createOrder(order, items)`:
        *   Use `OrderDao.insertOrder` to save the new order.
        *   Use `OrderItemDao.insertOrderItem` for each item in the order.

### 3. Domain Layer (Repository Interface - `lib/domain/repositories/`)

*   **`OrderRepository` (`lib/domain/repositories/order_repository.dart`):**
    *   [ ] Ensure the interface is correctly defined as per `01_core_infrastructure.md`, including:
        *   `Future<List<Order>> getOrdersForUser(int userId)`
        *   `Future<Order> getOrderDetail(int orderId)`
        *   `Stream<List<Order>> watchOrders(int userId)`
        *   `Future<void> createOrder(Order order, List<OrderItem> items)`

### 4. Dependency Injection (`lib/di/injection.dart`)

*   [ ] Register `OrderDao`, `OrderItemDao`, and `OrderRepositoryImpl` with the dependency injection system (e.g., GetIt, Riverpod's `Provider` for repositories).
*   [ ] Ensure `orderRepositoryProvider` is correctly set up to provide `OrderRepositoryImpl`.

### 5. State Management (Riverpod Providers - `lib/presentation/providers/`)

*   **`orderHistoryProvider` (`lib/presentation/providers/order_history_provider.dart`):**
    *   [ ] Create `order_history_provider.dart`.
    *   [ ] Define `orderHistoryProvider` as a `StreamProvider<List<Order>>`.
    *   [ ] It should depend on `orderRepositoryProvider` and the current user's ID (e.g., from an `authProvider`).
    *   [ ] Call `orderRepository.watchOrders(currentUserId)` to expose the stream of orders.
*   **`orderDetailProvider` (`lib/presentation/providers/order_detail_provider.dart`):**
    *   [ ] Create `order_detail_provider.dart`.
    *   [ ] Define `orderDetailProvider` as a `FutureProvider.family<Order, int>`.
    *   [ ] It should depend on `orderRepositoryProvider`.
    *   [ ] Call `orderRepository.getOrderDetail(orderId)` to fetch a specific order's details.

### 6. UI Implementation (`lib/presentation/screens/` and `lib/presentation/widgets/`)

*   **`OrderHistoryScreen.dart` (`lib/presentation/screens/order_history_screen.dart`):**
    *   [ ] Create the `OrderHistoryScreen` widget (e.g., `ConsumerWidget`).
    *   [ ] Watch `orderHistoryProvider` to get the list of orders.
    *   [ ] Handle loading state: Display `LoadingSpinner` (from `01_core_infrastructure.md`) while orders are being fetched.
    *   [ ] Handle error state: Display `ErrorDisplay` (from `01_core_infrastructure.md`) if an error occurs.
    *   [ ] Handle empty state: Display `EmptyState` (from `01_core_infrastructure.md`) if `orderHistoryProvider` yields an empty list.
    *   [ ] Use `ListView.builder` to render the list of orders.
    *   [ ] For each order, use the `ListItem` widget (from `01_core_infrastructure.md`) to display:
        *   Leading: An icon or small image representing an order.
        *   Title: Order ID or a summary (e.g., "Order #12345").
        *   Subtitle: Order date and status.
        *   Trailing: Total amount of the order.
    *   [ ] Implement navigation: On tapping a `ListItem`, navigate to `OrderDetailScreen`, passing the `orderId`.

*   **`OrderDetailScreen.dart` (`lib/presentation/screens/order_detail_screen.dart`):**
    *   [ ] Create the `OrderDetailScreen` widget (e.g., `ConsumerWidget`), accepting `orderId` as a parameter.
    *   [ ] Watch `orderDetailProvider(orderId)` to get the specific order details.
    *   [ ] Handle loading state: Display `LoadingSpinner` (from `01_core_infrastructure.md`).
    *   [ ] Handle error state: Display `ErrorDisplay` (from `01_core_infrastructure.md`).
    *   [ ] Display the main order details (ID, date, status, total amount).
    *   [ ] Use a `ListView.builder` or `Column` of `ListItem` widgets to display each `OrderItem`:
        *   Leading: Product image (if available, from `ProductCard` or similar).
        *   Title: Product name (from `Product` model).
        *   Subtitle: Quantity (e.g., "Qty: 2").
        *   Trailing: Price per item or total for that item.

### 7. Navigation

*   [ ] Update `lib/main.dart` or the main routing configuration to include routes for `OrderHistoryScreen` and `OrderDetailScreen`.
*   [ ] Add a navigation entry (e.g., in a `BottomNavigationBar` or `Drawer`) to access `OrderHistoryScreen`.

## Integration with Core Infrastructure

This section outlines how the Order Management features leverage the core infrastructure components defined in `01_core_infrastructure.md`.

-   **UI Components:**
    -   `OrderHistoryScreen.dart` and `OrderDetailScreen.dart` will utilize `ListItem` for displaying individual order items or orders in a list.
    -   `LoadingSpinner.dart` will be used to indicate data loading states.
    -   `EmptyState.dart` will be used when a user has no orders.
    -   `ErrorDisplay.dart` will be used to show any errors during order fetching.

-   **Data Models:**
    -   The `Order` and `OrderItem` models (defined in `lib/data/models/`) are central to order management and adhere to the `copyWith`, `fromJson`, and `toJson` implementations specified in the core infrastructure.

-   **Domain Layer (Repositories):**
    -   The `OrderRepository` interface (defined in `lib/domain/repositories/`) provides the contract for fetching order data, including `getOrdersForUser(userId)` and `getOrderDetail(orderId)`.

-   **Data Layer (Repository Implementations):**
    -   `OrderRepositoryImpl` (in `lib/data/repositories/`) will implement the `OrderRepository` interface, interacting with the local database (via Drift DAOs) to retrieve and manage order data.

-   **State Management (Riverpod Providers):**
    -   `orderHistoryProvider` (in `lib/presentation/providers/`) will be a `StreamProvider` that exposes the order data stream from the `OrderRepository`, making it accessible to the UI for reactive updates.
