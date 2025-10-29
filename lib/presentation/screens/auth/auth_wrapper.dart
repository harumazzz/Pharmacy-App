import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/presentation/providers/auth/auth_provider.dart';
import 'package:pharmacy_app/presentation/providers/auth/auth_state.dart';
import 'package:pharmacy_app/presentation/screens/auth/login_screen.dart';
import 'package:pharmacy_app/presentation/screens/home/home_screen.dart';
import 'package:pharmacy_app/presentation/widgets/loading_spinner.dart';
import 'package:pharmacy_app/presentation/widgets/error_display.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.when(
      initial: () => const LoadingSpinner(),
      loading: () => const LoadingSpinner(),
      authenticated: (_) => const HomeScreen(),
      unauthenticated: () => const LoginScreen(),
      error: (message) => ErrorDisplay(message: message),
    );
  }
}
