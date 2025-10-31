import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authService = AuthService();
  final picker = ImagePicker();

  void _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final user = authService.getCurrentUser();
      if (user != null) {
        user.profileImagePath = picked.path;
        await user.save();
        setState(() {}); // refresh UI
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = authService.getCurrentUser();

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'User tidak ditemukan.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  authService.logout();
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ],
          ),
        ),
      );
    }

    final hasImage = user.profileImagePath != null && user.profileImagePath!.isNotEmpty;
    final imageProvider = hasImage ? FileImage(File(user.profileImagePath!)) : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: imageProvider,
                  child: imageProvider == null
                      ? const Icon(Icons.person, size: 100)
                      : null,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 4, right: 4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 2,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.black),
                    onPressed: _pickImage,
                    tooltip: 'Ganti Foto Profil',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              user.fullName.isNotEmpty ? user.fullName : '(Nama belum diisi)',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Username: ${user.username}'),
            Text('Sisa kuota BMI: ${user.remainingQuota}x'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                authService.logout();
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}