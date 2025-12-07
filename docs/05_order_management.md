# Task: User Order History

**Goal:** Allow users to see their past and current orders.

## Detailed Implementation Tasks

### 1. Dependency Injection (`lib/di/injection.dart`)

*   [x] Register `OrderDao`, `OrderItemDao`, and `OrderRepositoryImpl` with the dependency injection system (e.g., GetIt, Riverpod's `Provider` for repositories).
*   [x] Ensure `orderRepositoryProvider` is correctly set up to provide `OrderRepositoryImpl`.

### 2. State Management (Riverpod Providers - `lib/presentation/providers/`)

*   **`orderHistoryProvider` (`lib/presentation/providers/order_history_provider.dart`):**
    *   [x] Create `order_history_provider.dart`.
    *   [x] Define `orderHistoryProvider` as a `StreamProvider<List<Order>>`.
    *   [x] It should depend on `orderRepositoryProvider` and the current user's ID (e.g., from an `authProvider`).
    *   [x] Call `orderRepository.watchOrders(currentUserId)` to expose the stream of orders.
*   **`orderDetailProvider` (`lib/presentation/providers/order_detail_provider.dart`):**
    *   [x] Create `order_detail_provider.dart`.
    *   [x] Define `orderDetailProvider` as a `FutureProvider.family<Order, int>`.
    *   [x] It should depend on `orderRepositoryProvider`.
    *   [x] Call `orderRepository.getOrderDetail(orderId)` to fetch a specific order's details.

### 3. UI Implementation (`lib/presentation/screens/` and `lib/presentation/widgets/`)

*   **`OrderHistoryScreen.dart` (`lib/presentation/screens/order_history_screen.dart`):**
    *   [x] Create the `OrderHistoryScreen` widget (e.g., `ConsumerWidget`).
    *   [x] Watch `orderHistoryProvider` to get the list of orders.
    *   [x] Handle loading state: Display `LoadingSpinner` (from `01_core_infrastructure.md`) while orders are being fetched.
    *   [x] Handle error state: Display `ErrorDisplay` (from `01_core_infrastructure.md`) if an error occurs.
    *   [x] Handle empty state: Display `EmptyState` (from `01_core_infrastructure.md`) if `orderHistoryProvider` yields an empty list.
    *   [x] Use `ListView.builder` to render the list of orders.
    *   [x] For each order, use the `ListItem` widget (from `01_core_infrastructure.md`) to display:
        *   [x] Leading: An icon or small image representing an order.
        *   [x] Title: Order ID or a summary (e.g., "Order #12345").
        *   [x] Subtitle: Order date and status.
        *   [x] Trailing: Total amount of the order.
    *   [x] Implement navigation: On tapping a `ListItem`, navigate to `OrderDetailScreen`, passing the `orderId`.

*   **`OrderDetailScreen.dart` (`lib/presentation/screens/order_detail_screen.dart`):**
    *   [x] Create the `OrderDetailScreen` widget (e.g., `ConsumerWidget`), accepting `orderId` as a parameter.
    *   [x] Watch `orderDetailProvider(orderId)` to get the specific order details.
    *   [x] Handle loading state: Display `LoadingSpinner` (from `01_core_infrastructure.md`).
    *   [x] Handle error state: Display `ErrorDisplay` (from `01_core_infrastructure.md`).
    *   [x] Display the main order details (ID, date, status, total amount).
    *   [x] Use a `ListView.builder` or `Column` of `ListItem` widgets to display each `OrderItem`:
        *   [x] Leading: Product image (if available, from `ProductCard` or similar).
        *   [x] Title: Product name (from `Product` model).
        *   [x] Subtitle: Quantity (e.g., "Qty: 2").
        *   [x] Trailing: Price per item or total for that item.

### 4. Navigation

*   [x] Update `lib/main.dart` or the main routing configuration to include routes for `OrderHistoryScreen` and `OrderDetailScreen`.
*   [x] Add a navigation entry (e.g., in a `BottomNavigationBar` or `Drawer`) to access `OrderHistoryScreen`.
