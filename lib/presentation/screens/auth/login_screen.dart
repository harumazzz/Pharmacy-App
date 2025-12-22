import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/presentation/providers/auth/auth_provider.dart';
import 'package:pharmacy_app/presentation/providers/auth/auth_state.dart';
import 'package:pharmacy_app/presentation/screens/admin/admin_screen.dart';
import 'package:pharmacy_app/presentation/screens/home/home_screen.dart';
import 'package:pharmacy_app/presentation/widgets/custom_text_field.dart';
import 'package:pharmacy_app/presentation/widgets/primary_button.dart';
import 'package:pharmacy_app/presentation/widgets/secondary_button.dart';
import 'package:pharmacy_app/presentation/screens/auth/register_screen.dart';
import 'package:pharmacy_app/utils/toast_extension.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeAnimationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _slideAnimationController,
            curve: Curves.elasticOut,
          ),
        );
    _fadeAnimationController.forward();
    _slideAnimationController.forward();

    ref.listenManual(authProvider, (previous, next) {
      next.when(
        initial: () {},
        loading: () {},
        authenticated: (user) {
          context.showToast(
            'Đăng nhập thành công!',
            backgroundColor: Colors.green,
          );
          final nextScreen = user.role == 'admin'
              ? const AdminScreen()
              : const HomeScreen();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => nextScreen),
          );
        },
        unauthenticated: () {},
        error: (message) {
          String displayMessage;
          if (message == "Invalid email or password") {
            displayMessage = 'Email hoặc mật khẩu không hợp lệ.';
          } else {
            displayMessage = 'Đã xảy ra lỗi. Vui lòng thử lại sau.';
            debugPrint('Login error: $message');
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(displayMessage),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor.withValues(alpha: 0.1),
              Theme.of(context).primaryColor.withValues(alpha: 0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.local_pharmacy,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Chào mừng trở lại!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Đăng nhập để tiếp tục mua sắm',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomTextField(
                            controller: _emailController,
                            labelText: 'Email',
                            hintText: 'Nhập địa chỉ email của bạn',
                            prefixIcon: Icons.email_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập email của bạn';
                              }
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(value)) {
                                return 'Vui lòng nhập một email hợp lệ';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          CustomTextField(
                            controller: _passwordController,
                            labelText: 'Mật khẩu',
                            hintText: 'Nhập mật khẩu của bạn',
                            prefixIcon: Icons.lock_outline,
                            suffixIcon: _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            onSuffixIconPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            obscureText: !_isPasswordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mật khẩu của bạn';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // TODO: Implement forgot password
                              },
                              child: Text(
                                'Quên mật khẩu?',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          PrimaryButton(
                            text: 'Đăng nhập',
                            icon: Icons.login,
                            isLoading: authState.maybeWhen(
                              loading: () => true,
                              orElse: () => false,
                            ),
                            onPressed: authState.maybeWhen(
                              loading: () => null,
                              orElse: () => () {
                                if (_formKey.currentState!.validate()) {
                                  ref
                                      .read(authProvider.notifier)
                                      .login(
                                        _emailController.text,
                                        _passwordController.text,
                                      );
                                }
                              },
                            ),
                          ),

                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey[300],
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'hoặc',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey[300],
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          SecondaryButton(
                            text: 'Tạo tài khoản mới',
                            icon: Icons.person_add_outlined,
                            onPressed: authState.maybeWhen(
                              loading: () => null,
                              orElse: () => () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
