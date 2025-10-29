import 'package:pharmacy_app/di/injection.dart';
import 'package:pharmacy_app/domain/exceptions/auth_exceptions.dart';
import 'package:pharmacy_app/domain/repositories/auth_repository.dart';
import 'package:pharmacy_app/presentation/providers/auth/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/user.dart' as model;

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  late final AuthRepository _authRepository;

  @override
  AuthState build() {
    _authRepository = getIt<AuthRepository>();
    return const AuthState.initial();
  }

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      await _authRepository.login(email, password);
      state = const AuthState.authenticated();
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
      await _authRepository.register(userToRegister);
      state = const AuthState.authenticated();
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
