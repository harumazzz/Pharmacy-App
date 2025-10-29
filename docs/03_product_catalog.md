# Task: Product Catalog & Search

**Goal:** Allow users to view, search, and see details for products and categories, using our existing component library.

**Instructions:**
- Use Vietnamese text for all UI strings and messages.
- Use Riverpod code generator (@riverpod annotations) for all providers.
- Use Freezed for sealed classes and data models.

- [ ] **`HomeScreen` (`lib/presentation/screens/home_screen.dart`):**
    - [ ] **UI:**
        - [ ] Use a `Scaffold` with an `AppBar` titled "Trang chủ".
        - [ ] Add a `CustomTextField` for the search bar in the `AppBar` or below it.
        - [ ] Display a horizontal list of categories using `CategoryCard` widgets.
        - [ ] Display a grid or vertical list of products using `ProductCard` widgets.
    - [ ] **State Management:**
        - [ ] Use Riverpod code generator to create `categoryListProvider` and `productListProvider`.
        - [ ] Use `ref.watch(categoryListProvider)` to get the list of categories.
        - [ ] Use `ref.watch(productListProvider)` to get the list of products.
        - [ ] Handle the `AsyncValue` states (`data`, `loading`, `error`) for both providers.
    - [ ] **Logic:**
        - [ ] When a `CategoryCard` is tapped, navigate to `ProductListScreen` with the category ID.
        - [ ] When a `ProductCard` is tapped, navigate to `ProductDetailScreen` with the product ID.
        - [ ] As the user types in the `CustomTextField`, update a search provider's state.
    - [ ] **Edge Cases:**
        - [ ] While categories are loading, show a `LoadingSpinner` in the category section.
        - [ ] If categories fail to load, show an `ErrorDisplay` widget.
        - [ ] If there are no categories, show an `EmptyState` widget.
        - [ ] Handle loading, error, and empty states for the product list similarly using `LoadingSpinner`, `ErrorDisplay`, and `EmptyState`.

- [ ] **`ProductListScreen` (`lib/presentation/screens/product_list_screen.dart`):**
    - [ ] **UI:**
        - [ ] `Scaffold` with an `AppBar` showing the category name as the title.
        - [ ] Display a grid or list of `ProductCard`s.
    - [ ] **State Management:**
        - [ ] Accept a `categoryId` as a parameter.
        - [ ] Use Riverpod code generator to create `productListProvider` family.
        - [ ] Use `ref.watch(productListProvider(categoryId))` to get the filtered list of products.
        - [ ] Handle `AsyncValue` states.
    - [ ] **Logic:**
        - [ ] When a `ProductCard` is tapped, navigate to `ProductDetailScreen`.
    - [ ] **Edge Cases:**
        - [ ] While products are loading, show a `LoadingSpinner`.
        - [ ] If loading fails, show an `ErrorDisplay`.
        - [ ] If no products are found for the category, show an `EmptyState` widget with a message like "Không có sản phẩm trong danh mục này."

- [ ] **`ProductDetailScreen` (`lib/presentation/screens/product_detail_screen.dart`):**
    - [ ] **UI:**
        - [ ] `Scaffold` with the product name in the `AppBar`.
        - [ ] Display a large image of the product.
        - [ ] Show product name, description, and price using `Text` widgets.
        - [ ] Include a `PrimaryButton` with the text "Thêm vào giỏ hàng".
    - [ ] **State Management:**
        - [ ] Accept a `productId` as a parameter.
        - [ ] Use Riverpod code generator to create `productDetailProvider` family.
        - [ ] Use `ref.watch(productDetailProvider(productId))` to get the product details.
        - [ ] Use `ref.read(cartRepositoryProvider)` to call the `addProductToCart` method.
    - [ ] **Logic:**
        - [ ] When the `PrimaryButton` is pressed, call the `addProductToCart` method from the `CartRepository`.
        - [ ] Show a confirmation message (e.g., a `SnackBar`) after adding to the cart.
    - [ ] **Edge Cases:**
        - [ ] While product details are loading, display a `LoadingSpinner`.
        - [ ] If loading fails, display an `ErrorDisplay`.
        - [ ] Disable the `PrimaryButton` while the add operation is in progress.

- [ ] **Search Functionality:**
    - [ ] **State Management:**
        - [ ] Create a `searchQueryProvider` (`StateProvider<String>`) using Riverpod code generator.
        - [ ] Create a `searchedProductsProvider` (`StreamProvider.autoDispose.family`) using Riverpod code generator that takes the search query and calls the `searchProducts` method of the repository.
    - [ ] **UI:**
        - [ ] In `HomeScreen`, the `CustomTextField`'s `onChanged` callback should update the `searchQueryProvider`.
        - [ ] Display the results from `searchedProductsProvider` instead of the default product list when the search query is not empty.
    - [ ] **Edge Cases:**
        - [ ] While search results are loading, show a `LoadingSpinner`.
        - [ ] If the search fails, show an `ErrorDisplay`.
        - [ ] If the search yields no results, show an `EmptyState` with a message like "Không tìm thấy sản phẩm cho '[query]'".
