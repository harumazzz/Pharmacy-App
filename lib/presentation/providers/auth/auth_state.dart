import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmacy_app/data/models/user.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}

extension AuthStateExtension on AuthState {
  bool get isAuthenticated => this is _Authenticated;

  int? get userId {
    if (this is _Authenticated) {
      return (this as _Authenticated).user.id;
    }
    return null;
  }
}
