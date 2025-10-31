import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(controller: fullNameController, label: 'Nama Lengkap'),
            CustomTextField(controller: usernameController, label: 'Username'),
            CustomTextField(controller: passwordController, label: 'Password', obscureText: true),
            const SizedBox(height: 20),
            CustomButton(text: 'Register', onPressed: handleRegister),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
              child: const Text('Sudah punya akun? Login'),
            ),
          ],
        ),
      ),
    );
  }
}