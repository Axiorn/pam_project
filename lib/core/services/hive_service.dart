import 'package:hive/hive.dart';
import '../constants/hive_boxes.dart';
import '../models/bmi_result_model.dart';

class HiveService {
  Future<bool> saveBmiResult(BmiResultModel result) async {
    try {
      final box = Hive.box<BmiResultModel>(HiveBoxes.bmi);
      await box.add(result);
      return true;
    } catch (e) {
      return false;
    }
  }
}