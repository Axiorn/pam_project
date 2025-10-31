import 'package:hive/hive.dart';

part 'bmi_result_model.g.dart';

@HiveType(typeId: 1)
class BmiResultModel extends HiveObject {
  @HiveField(0)
  late String username;

  @HiveField(1)
  late double weight;

  @HiveField(2)
  late double height;

  @HiveField(3)
  late double bmi;

  @HiveField(4)
  late String category;

  @HiveField(5)
  late String dateTime;

  @HiveField(6)
  late String location;

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