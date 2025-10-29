# Task: Product Catalog & Search

**Goal:** Allow users to view, search, and see details for products and categories, using our existing component library.

**Instructions:**
- Use Vietnamese text for all UI strings and messages.
- Use Riverpod code generator (@riverpod annotations) for all providers.
- Use Freezed for sealed classes and data models.

- [x] **`HomeScreen` (`lib/presentation/screens/home_screen.dart`):**
    - [x] **UI:**
        - [x] Use a `Scaffold` with an `AppBar` titled "Trang chủ".
        - [x] Add a `CustomTextField` for the search bar in the `AppBar` or below it.
        - [x] Display a horizontal list of categories using `CategoryCard` widgets.
        - [x] Display a grid or vertical list of products using `ProductCard` widgets.
    - [x] **State Management:**
        - [x] Use Riverpod code generator to create `categoryListProvider` and `productListProvider`.
        - [x] Use `ref.watch(categoryListProvider)` to get the list of categories.
        - [x] Use `ref.watch(productListProvider)` to get the list of products.
        - [x] Handle the `AsyncValue` states (`data`, `loading`, `error`) for both providers.
    - [x] **Logic:**
        - [x] When a `CategoryCard` is tapped, navigate to `ProductListScreen` with the category ID.
        - [x] When a `ProductCard` is tapped, navigate to `ProductDetailScreen` with the product ID.
        - [x] As the user types in the `CustomTextField`, update a search provider's state.
    - [x] **Edge Cases:**
        - [x] While categories are loading, show a `LoadingSpinner` in the category section.
        - [x] If categories fail to load, show an `ErrorDisplay` widget.
        - [x] If there are no categories, show an `EmptyState` widget.
        - [x] Handle loading, error, and empty states for the product list similarly using `LoadingSpinner`, `ErrorDisplay`, and `EmptyState`.

- [x] **`ProductListScreen` (`lib/presentation/screens/product_list/product_list_screen.dart`):**
    - [x] **UI:**
        - [x] `Scaffold` with an `AppBar` showing the category name as the title.
        - [x] Display a grid or list of `ProductCard`s.
    - [x] **State Management:**
        - [x] Accept a `categoryId` as a parameter.
        - [x] Use Riverpod code generator to create `productListProvider` family.
        - [x] Use `ref.watch(productListProvider(categoryId))` to get the filtered list of products.
        - [x] Handle `AsyncValue` states.
    - [x] **Logic:**
        - [x] When a `ProductCard` is tapped, navigate to `ProductDetailScreen`.
    - [x] **Edge Cases:**
        - [x] While products are loading, show a `LoadingSpinner`.
        - [x] If loading fails, show an `ErrorDisplay`.
        - [x] If no products are found for the category, show an `EmptyState` widget with a message like "Không có sản phẩm trong danh mục này."

- [x] **`ProductDetailScreen` (`lib/presentation/screens/product_detail/product_detail_screen.dart`):**
    - [x] **UI:**
        - [x] `Scaffold` with the product name in the `AppBar`.
        - [x] Display a large image of the product.
        - [x] Show product name, description, and price using `Text` widgets.
        - [x] Include a `PrimaryButton` with the text "Thêm vào giỏ hàng".
    - [x] **State Management:**
        - [x] Accept a `productId` as a parameter.
        - [x] Use Riverpod code generator to create `productDetailProvider` family.
        - [x] Use `ref.watch(productDetailProvider(productId))` to get the product details.
        - [x] Use `ref.read(cartRepositoryProvider)` to call the `addProductToCart` method.
    - [x] **Logic:**
        - [x] When the `PrimaryButton` is pressed, call the `addProductToCart` method from the `CartRepository`.
        - [x] Show a confirmation message (e.g., a `SnackBar`) after adding to the cart.
    - [x] **Edge Cases:**
        - [x] While product details are loading, display a `LoadingSpinner`.
        - [x] If loading fails, display an `ErrorDisplay`.
        - [x] Disable the `PrimaryButton` while the add operation is in progress.

- [x] **Search Functionality:**
    - [x] **State Management:**
        - [x] Create a `searchQueryProvider` (`StateProvider<String>`) using Riverpod code generator.
        - [x] Create a `searchedProductsProvider` (`StreamProvider.autoDispose.family`) using Riverpod code generator that takes the search query and calls the `searchProducts` method of the repository.
    - [x] **UI:**
        - [x] In `HomeScreen`, the `CustomTextField`'s `onChanged` callback should update the `searchQueryProvider`.
        - [x] Display the results from `searchedProductsProvider` instead of the default product list when the search query is not empty.
    - [x] **Edge Cases:**
        - [x] While search results are loading, show a `LoadingSpinner`.
        - [x] If the search fails, show an `ErrorDisplay`.
        - [x] If the search yields no results, show an `EmptyState` with a message like "Không tìm thấy sản phẩm cho '[query]'".
