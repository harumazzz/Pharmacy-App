class InvalidCredentialsException implements Exception {
  final String message;
  const InvalidCredentialsException([this.message = "Invalid email or password"]);

  @override
  String toString() => "InvalidCredentialsException: $message";
}

class EmailAlreadyInUseException implements Exception {
  final String message;
  const EmailAlreadyInUseException([this.message = "Email already in use"]);

  @override
  String toString() => "EmailAlreadyInUseException: $message";
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = "An unknown authentication error occurred"]);

  @override
  String toString() => "AuthException: $message";
}
