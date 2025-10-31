import 'package:crypto/crypto.dart';
import 'dart:convert';

class EncryptionHelper {
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static bool verifyPassword(String inputPassword, String storedHash) {
    final inputHash = hashPassword(inputPassword);
    return inputHash == storedHash;
  }
}