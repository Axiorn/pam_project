import 'package:hive/hive.dart';
import '../constants/hive_boxes.dart';
import '../models/user_model.dart';
import '../utils/encryption_helper.dart'; // 

class AuthService {
  late final Box<UserModel> _userBox;
  late final Box<dynamic> _sessionBox;

  AuthService() {
    _userBox = Hive.box<UserModel>(HiveBoxes.users);
    _sessionBox = Hive.box(HiveBoxes.session);
  }

  // ✅ Login dengan verifikasi hash
  bool login(String username, String password) {
    try {
      final user = _userBox.values.firstWhere((u) => u.username == username);
      final isValid = EncryptionHelper.verifyPassword(password, user.password);

      if (!isValid) return false;

      _sessionBox.put('loggedInUser', user.username);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ✅ Register dengan password terenkripsi
  bool register({
    required String username,
    required String password,
    required String fullName,
  }) {
    final existing = _userBox.values.any((u) => u.username == username);
    if (existing) return false;

    final hashedPassword = EncryptionHelper.hashPassword(password);

    final newUser = UserModel(
      username: username,
      password: hashedPassword,
      remainingQuota: 5,
      isSubscribed: false,
      subscriptionUntil: null,
      fullName: fullName,
      profileImagePath: null,
    );

    _userBox.add(newUser);
    return true;
  }

  // ✅ Logout
  void logout() {
    _sessionBox.delete('loggedInUser');
  }

  // ✅ Ambil user yang sedang login
  UserModel? getCurrentUser() {
    final username = _sessionBox.get('loggedInUser');
    if (username == null) return null;

    try {
      final user = _userBox.values.firstWhere((u) => u.username == username);
      return user;
    } catch (e) {
      return null;
    }
  }

  // ✅ Kurangi kuota BMI
  void decreaseQuota() {
    final username = _sessionBox.get('loggedInUser');
    if (username == null) return;

    try {
      final user = _userBox.values.firstWhere((u) => u.username == username);
      if (user.remainingQuota > 0) {
        user.remainingQuota -= 1;
        user.save();
      }
    } catch (e) {
      // user tidak ditemukan
    }
  }

  // ✅ Aktifkan langganan + tambah kuota sesuai paket
  void activateSubscription({required int days, required int additionalQuota}) {
    final username = _sessionBox.get('loggedInUser');
    if (username == null) return;

    try {
      final user = _userBox.values.firstWhere((u) => u.username == username);
      final until = DateTime.now().add(Duration(days: days));
      user.isSubscribed = true;
      user.subscriptionUntil = until.toIso8601String().split('T').first;
      user.remainingQuota += additionalQuota;
      user.save();
    } catch (e) {
      // user tidak ditemukan
    }
  }
}