import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String password;

  @HiveField(2)
  int remainingQuota;

  @HiveField(3)
  bool isSubscribed;

  @HiveField(4)
  String? subscriptionUntil;

  @HiveField(5)
  String fullName;

  @HiveField(6)
  String? profileImagePath;

  UserModel({
    required this.username,
    required this.password,
    required this.remainingQuota,
    required this.isSubscribed,
    this.subscriptionUntil,
    required this.fullName,
    this.profileImagePath,
  });
}