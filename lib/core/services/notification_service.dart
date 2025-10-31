import 'package:flutter/material.dart';

class NotificationService {
  void showSuccess(BuildContext context, String message) {
    _showSnackbar(context, message, Colors.green);
  }

  void showError(BuildContext context, String message) {
    _showSnackbar(context, message, Colors.red);
  }

  void _showSnackbar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}