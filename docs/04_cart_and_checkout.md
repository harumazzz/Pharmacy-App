# Task: Shopping Cart and Checkout

**Goal:** Enable users to add items to a cart, view cart contents, and place orders.

**Instructions:**
- Use Vietnamese text for all UI strings and messages.
- Use Riverpod code generator (@riverpod annotations) for all providers.
- Use Freezed for sealed classes and data models.
- Note: The `CartRepository` and `OrderRepository` are already defined in `01_core_infrastructure.md`. You may need to extend implementations if needed.

- [x] **`CartScreen` (`lib/presentation/screens/cart/cart_screen.dart`):**
    - [x] **UI:**
        - [x] `Scaffold` with an `AppBar` titled "Giỏ hàng".
        - [x] Display a list of cart items using `ListItem` widgets.
        - [x] Each item should show: product name, price, quantity, and subtotal.
        - [x] Include quantity adjustment buttons (+ / -) for each item.
        - [x] Add a "Xóa" (Remove) button or icon for each item.
        - [x] Display the total cart value at the bottom.
        - [x] Add a `PrimaryButton` for "Thanh toán" (Checkout).
    - [x] **State Management:**
        - [x] Use Riverpod code generator to create `cartItemsProvider` (family if needed for user-specific data).
        - [x] Use `ref.watch(cartItemsProvider)` to get the list of cart items.
        - [x] Handle `AsyncValue` states (`data`, `loading`, `error`).
    - [x] **Logic:**
        - [x] When the + button is pressed, call `updateCartItem(cartItemId, newQuantity)`.
        - [x] When the - button is pressed, call `updateCartItem(cartItemId, newQuantity)`.
        - [x] When the Remove button is pressed, call `removeFromCart(cartItemId)`.
        - [x] When the "Thanh toán" button is pressed, navigate to `CheckoutScreen`.
    - [x] **Edge Cases:**
        - [x] While cart items are loading, show a `LoadingSpinner`.
        - [x] If loading fails, show an `ErrorDisplay`.
        - [x] If the cart is empty, show an `EmptyState` widget with a message like "Giỏ hàng trống".
        - [x] Prevent quantity from going below 1 or above a reasonable limit.

- [x] **`CheckoutScreen` (`lib/presentation/screens/checkout/checkout_screen.dart`):**
    - [x] **UI:**
        - [x] `Scaffold` with an `AppBar` titled "Thanh toán".
        - [x] Display an order summary showing all cart items and their subtotals.
        - [x] Display the total order amount.
        - [x] (Optional) Add a simple form for delivery/order notes.
        - [x] Add a `PrimaryButton` for "Đặt hàng" (Place Order).
        - [x] Add a `SecondaryButton` for "Quay lại" (Back to Cart).
    - [x] **State Management:**
        - [x] Use Riverpod code generator to create `checkoutProvider` for managing checkout state.
        - [x] Use `ref.watch(cartItemsProvider)` to display cart items in the summary.
    - [x] **Logic:**
        - [x] When the "Đặt hàng" button is pressed:
            - [x] Call `createOrder(order)` from the `OrderRepository`.
            - [x] Clear the cart using `clearCart()`.
            - [x] Show a success message (e.g., `SnackBar` or dialog).
            - [x] Navigate to `OrderHistoryScreen` or `HomeScreen`.
    - [x] **Edge Cases:**
        - [x] Show a loading indicator while the order is being processed.
        - [x] Handle errors during order creation and display an appropriate message.
        - [x] Disable the "Đặt hàng" button while processing.

- [x] **Logic (using Riverpod and Repositories):**
    - [x] Verify that `CartRepository` in `lib/data/repositories/cart_repository_impl.dart` implements:
        - [x] `addProductToCart(userId, productId)` - already defined in interface.
        - [x] `updateCartItem(cartItemId, quantity)` - update quantity or remove if quantity is 0.
        - [x] `removeFromCart(cartItemId)` - delete the cart item.
        - [x] `clearCart(userId)` - delete all items for a user.
    - [x] Verify that `OrderRepository` in `lib/data/repositories/order_repository_impl.dart` implements:
        - [x] `createOrder(order)` - create an Order and associated OrderItems, then clear the cart.
        - [x] Already defined methods from `01_core_infrastructure.md`.

- [x] **Providers (in `lib/presentation/providers/`):**
    - [x] Create `cartItemsProvider` using Riverpod code generator:
        - [x] Should watch cart items for the current user.
        - [x] Use `watchCartItems(userId)` from the repository.
    - [x] Create `cartTotalProvider` using Riverpod code generator:
        - [x] Should compute the total price based on `cartItemsProvider`.
    - [x] (Optional) Create `checkoutProvider` for managing checkout UI state (loading, error, success).
