import 'package:flutter/material.dart';
import 'package:pam_project/presentation/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_service.dart';
import '../../../routes/app_routes.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  void handleLogin() {
    final success = authService.login(
      usernameController.text.trim(),
      passwordController.text.trim(),
    );

    if (success) {
      showCustomSnackbar(context, 'Login berhasil!');
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      showCustomSnackbar(context, 'Login gagal. Periksa username dan password.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 Logo / Header
              Icon(
                Icons.lock_outline,
                size: 80,
                color: isDark ? Colors.tealAccent : Colors.teal,
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Masuk ke akun Anda untuk melanjutkan',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // 🔹 Card Container untuk form
              Card(
                color: isDark ? Colors.grey[900] : Colors.white,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: usernameController,
                        label: 'Username',
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: passwordController,
                        label: 'Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),

                      // 🔹 Tombol login
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: 'Login',
                          onPressed: handleLogin,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 🔹 Tombol navigasi ke register
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                            context, AppRoutes.register),
                        child: Text(
                          'Belum punya akun? Register',
                          style: TextStyle(
                            color: isDark ? Colors.tealAccent : Colors.teal,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}