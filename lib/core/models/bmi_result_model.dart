import 'package:hive/hive.dart';

part 'bmi_result_model.g.dart';

@HiveType(typeId: 1)
class BmiResultModel extends HiveObject {
  @HiveField(0)
  double weight;

  @HiveField(1)
  double height;

  @HiveField(2)
  double bmi;

  @HiveField(3)
  String category;

  @HiveField(4)
  String dateTime;

  @HiveField(5)
  String location;

  @HiveField(6)
  String username;

  BmiResultModel({
    required this.weight,
    required this.height,
    required this.bmi,
    required this.category,
    required this.dateTime,
    required this.location,
    required this.username,
  });
}