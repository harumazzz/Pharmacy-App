import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/presentation/providers/auth/auth_provider.dart';
import 'package:pharmacy_app/presentation/providers/auth/auth_state.dart';
import 'package:pharmacy_app/presentation/screens/auth/login_screen.dart';
import 'package:pharmacy_app/presentation/screens/admin/admin_screen.dart';
import 'package:pharmacy_app/presentation/screens/home/home_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.when(
      initial: () => const LoginScreen(),
      loading: () => const LoginScreen(),
      authenticated: (user) {
        if (user.role == 'admin') {
          return const AdminScreen();
        }
        return const HomeScreen();
      },
      unauthenticated: () => const LoginScreen(),
      error: (_) => const LoginScreen(),
    );
  }
}
