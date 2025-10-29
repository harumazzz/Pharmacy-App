# Task: Shopping Cart and Checkout

**Goal:** Enable users to add items to a cart and place an order.

- [ ] **UI (in `lib/presentation/screens/`):**
    *   **View Cart:**
        *   **Frontend (Mobile/Web):**
            *   User Interface to display cart contents.
            *   Display product details (name, price, quantity, subtotal).
            *   Display calculated total cart value.
            *   Call to Cart service/repository to fetch cart data.
        *   **Database (Database Setup):**
            *   Query cart and product tables/collections (referencing `01_core_infrastructure.md` - Database Schema Design).    - [ ] `CheckoutScreen.dart`:
        - [ ] A simple form for the user to confirm their order.
        - [ ] Display a summary of the order.
        - [ ] A "Place Order" button.

- [ ] **Logic (using Riverpod and Repositories):**
    - [ ] `CartRepository`:
        - [ ] Implement `getCartItems()`.
*   **Add Item to Cart:**
    *   **Frontend (Mobile/Web):**
        *   User Interface for product selection and quantity input.
        *   Client-side validation of quantity.
        *   Call to Cart service/repository.
    *   **Database (Database Setup):**
        *   Update cart table/collection (referencing `01_core_infrastructure.md` - Database Schema Design).
        - [ ] Implement `updateCartItem(cartItemId, quantity)`.
        - [ ] Implement `removeFromCart(cartItemId)`.
        - [ ] Implement `clearCart()`.
    - [ ] `OrderRepository`:
        - [ ] Implement `createOrder(order)`. This will read the cart, create an `Order` and associated `OrderItems`, and clear the cart.
    - [ ] **Providers (in `lib/presentation/providers/`):**
        - [ ] Create a `cartProvider` to manage the state of the shopping cart.
