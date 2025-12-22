import 'package:pharmacy_app/di/injection.dart';
import 'package:pharmacy_app/domain/exceptions/auth_exceptions.dart';
import 'package:pharmacy_app/domain/repositories/auth_repository.dart';
import 'package:pharmacy_app/presentation/providers/auth/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/user.dart' as model;

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  late final AuthRepository _authRepository;

  @override
  AuthState build() {
    _authRepository = getIt<AuthRepository>();
    _checkInitialAuth();
    return const AuthState.initial();
  }

  Future<void> _checkInitialAuth() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> checkAuthStatus() async {
    await _checkInitialAuth();
  }

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _authRepository.login(email, password);
      state = AuthState.authenticated(user);
    } on InvalidCredentialsException catch (e) {
      state = AuthState.error(e.message);
    } on AuthException catch (e) {
      state = AuthState.error(e.message);
    } catch (e) {
      state = AuthState.error('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> register(String fullName, String email, String password) async {
    state = const AuthState.loading();
    try {
      final userToRegister = model.User(
        id: 0,
        username: email,
        password: password,
        fullName: fullName,
        role: 'user',
      );
      final user = await _authRepository.register(userToRegister);
      state = AuthState.authenticated(user);
    } on EmailAlreadyInUseException catch (e) {
      state = AuthState.error(e.message);
    } on AuthException catch (e) {
      state = AuthState.error(e.message);
    } catch (e) {
      state = AuthState.error('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = const AuthState.unauthenticated();
  }
}
