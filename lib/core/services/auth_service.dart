import 'package:hive/hive.dart';
import '../constants/hive_boxes.dart';
import '../models/user_model.dart';
import '../utils/encryption_helper.dart';
import 'notification_controller.dart';

class AuthService {
  late final Box<UserModel> _userBox;
  late final Box<dynamic> _sessionBox;

  AuthService() {
    _userBox = Hive.box<UserModel>(HiveBoxes.users);
    _sessionBox = Hive.box(HiveBoxes.session);
  }

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

  void logout() {
    _sessionBox.delete('loggedInUser');
  }

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

  Future<void> activateSubscription({
    required int days,
    required int additionalQuota,
    required String packageName,
  }) async {
    final username = _sessionBox.get('loggedInUser');
    if (username == null) return;

    try {
      final user = _userBox.values.firstWhere((u) => u.username == username);
      final until = DateTime.now().add(Duration(days: days));
      user.isSubscribed = true;
      user.subscriptionUntil = until.toIso8601String().split('T').first;
      user.remainingQuota += additionalQuota;
      await user.save();

      await NotificationController.showSuccessNotification(
        'Langganan $packageName Aktif',
        'Paket $packageName berhasil diaktifkan hingga ${user.subscriptionUntil}.',
      );
    } catch (e) {
      // user tidak ditemukan
    }
  }
}