import 'package:flutter/material.dart';
import 'package:pam_project/presentation/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_service.dart';
import '../../../routes/app_routes.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_snackbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  void handleRegister() {
    final fullName = fullNameController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    final success = authService.register(
      username: username,
      password: password,
      fullName: fullName,
    );

    if (success) {
      showCustomSnackbar(context, 'Registrasi berhasil!');
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      showCustomSnackbar(context, 'Username sudah digunakan.');
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
              // 🔹 Header Icon & Title
              Icon(
                Icons.person_add_alt_1_outlined,
                size: 80,
                color: isDark ? Colors.tealAccent : Colors.teal,
              ),
              const SizedBox(height: 16),
              Text(
                'Buat Akun Baru',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Lengkapi data di bawah untuk mendaftar',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // 🔹 Form Card
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
                        controller: fullNameController,
                        label: 'Nama Lengkap',
                      ),
                      const SizedBox(height: 16),
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

                      // 🔹 Tombol Register
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: 'Register',
                          onPressed: handleRegister,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 🔹 Navigasi ke Login
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                            context, AppRoutes.login),
                        child: Text(
                          'Sudah punya akun? Login',
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