import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(controller: usernameController, label: 'Username'),
            CustomTextField(controller: passwordController, label: 'Password', obscureText: true),
            const SizedBox(height: 20),
            CustomButton(text: 'Login', onPressed: handleLogin),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.register),
              child: const Text('Belum punya akun? Register'),
            ),
          ],
        ),
      ),
    );
  }
}