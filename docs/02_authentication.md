# Task: User Authentication

**Goal:** Implement a complete and robust user registration and login flow, including state management and error handling.

- [x] **UI (in `lib/presentation/screens/auth/`):**
    - [x] **`LoginScreen.dart`**:
        - [x] Build the UI using a `Scaffold` and a `Form`.
        - [x] Use two `CustomTextField` widgets for email and password.
        - [x] Add a `PrimaryButton` for the "Login" action.
        - [x] Include a `SecondaryButton` or `TextButton` to navigate to the Register Screen.
        - [x] Implement form validation for email and password fields (e.g., not empty, valid email format).
    - [x] **`RegisterScreen.dart`**:
        - [x] Build the UI similar to the Login Screen, adding fields for username and any other required user information.
        - [x] Use `CustomTextField` for all input fields.
        - [x] Use a `PrimaryButton` for the "Register" action.
        - [x] Implement robust form validation for all fields.
    - [x] **`AuthWrapper.dart`**:
        - [x] Create a `ConsumerWidget` that listens to the `auth_state_provider`.
        - [x] Based on the authentication state, conditionally display:
            - `LoadingSpinner` if the state is `Authenticating`.
            - The main `HomeScreen` if the state is `Authenticated`.
            - `LoginScreen` if the state is `Unauthenticated` or `AuthenticationError`.

- [x] **Logic (in `lib/presentation/providers/auth_state_provider.dart`):**
    - [x] **Create an `AuthState` class:**
        - [x] Define an enum or sealed class for the authentication status: `initial`, `authenticating`, `authenticated`, `unauthenticated`, `error`.
        - [x] The state should hold the current `User` object (if authenticated) and an error message (if an error occurred). (Note: User object is not directly stored in AuthState.authenticated() due to current AuthRepository API limitations, but the state indicates authentication.)
    - [x] **Implement `AuthStateNotifier`:**
        - [x] Create a `StateNotifier` that manages the `AuthState`.
        - [x] **`login(String email, String password)` method:**
            - [x] Set state to `authenticating`.
            - [x] Call the `login` method from the `AuthRepository`.
            - [x] On success, fetch the user data, set the state to `authenticated`, and store the user object. (Note: User object is not directly stored in AuthState.authenticated() due to current AuthRepository API limitations, but the state indicates authentication.)
            - [x] On failure (e.g., invalid credentials), set the state to `error` with an appropriate message.
        - [x] **`register(User user, String password)` method:**
            - [x] Set state to `authenticating`.
            - [x] Call the `register` method from the `AuthRepository`. (Note: The `register` method in `AuthRepository` expects a `User` object, not `User` and `password` separately. This was handled by constructing a `User` object in the provider.)
            - [x] On success, automatically log the user in and set the state to `authenticated`. (Note: User object is not directly stored in AuthState.authenticated() due to current AuthRepository API limitations, but the state indicates authentication.)
            - [x] On failure (e.g., user already exists), set the state to `error` with an appropriate message.
        - [x] **`logout()` method:**
            - [x] Call the `logout` method from the `AuthRepository`.
            - [x] Set the state to `unauthenticated`.
        - [ ] **`checkInitialAuth()` method:**
            - [ ] Implement a method to check the user's authentication status when the app starts.
            - [ ] This could involve checking for a stored token or session in a secure local storage.
            - [ ] Update the state accordingly.

- [x] **Error Handling:**
    - [x] **Displaying Errors:**
        - [x] In `LoginScreen` and `RegisterScreen`, listen to the `auth_state_provider`.
        - [x] When the state is `error`, display the error message to the user, for instance, using a `SnackBar` or by rendering an `ErrorDisplay` widget.
    - [x] **Specific Cases:**
        - [x] Handle "Invalid email or password" on the Login Screen.
        - [x] Handle "Email already in use" on the Register Screen.
        - [x] Handle generic network or server errors gracefully.