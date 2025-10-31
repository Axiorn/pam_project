import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/hive_service.dart';
import '../../../core/utils/location_helper.dart';
import '../../../core/utils/date_time_helper.dart';
import '../../../core/models/bmi_result_model.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/models/user_model.dart';

class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  State<BmiCalculatorScreen> createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final authService = AuthService();
  final apiService = ApiService();
  final hiveService = HiveService();
  final notificationService = NotificationService();

  String resultText = '';
  String category = '';
  bool isLoading = false;
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = authService.getCurrentUser();
  }

  void calculateBmi() async {
    final user = authService.getCurrentUser();
    if (user == null || user.remainingQuota <= 0) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Kuota Habis'),
          content: const Text('Silakan berlangganan untuk melanjutkan.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final weight = double.tryParse(weightController.text);
    final heightCm = double.tryParse(heightController.text);
    if (weight == null || heightCm == null) return;

    final heightM = heightCm / 100;
    setState(() => isLoading = true);

    final response = await apiService.fetchBmi(weight, heightM);
    setState(() => isLoading = false);

    if (response == null) {
      notificationService.showError(context, 'Gagal menghitung BMI.');
      return;
    }

    final bmiValue = response['bmi'];
    final healthCategory = response['Category']?.toString() ?? 'Tidak diketahui';

    if (bmiValue == null || healthCategory.isEmpty) {
      notificationService.showError(context, 'Data dari API tidak lengkap.');
      return;
    }

    setState(() {
      resultText = bmiValue.toString();
      category = healthCategory;
    });

    final location = await LocationHelper.getCurrentLocation();
    final timestamp = DateTimeHelper.getFormattedNow();
    final username = authService.getCurrentUser()?.username ?? 'unknown';

    final bmiResult = BmiResultModel(
      weight: weight,
      height: heightCm,
      bmi: bmiValue,
      category: healthCategory,
      dateTime: timestamp,
      location: location,
      username: username,
    );

    final success = await hiveService.saveBmiResult(bmiResult);
    if (success) {
      notificationService.showSuccess(context, 'Data BMI berhasil disimpan.');
      authService.decreaseQuota();
      setState(() {
        currentUser = authService.getCurrentUser(); // ✅ refresh kuota
      });
    } else {
      notificationService.showError(context, 'Gagal menyimpan data BMI.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kalkulator BMI')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Sisa kuota: ${currentUser?.remainingQuota ?? 0}x'),
            const SizedBox(height: 16),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Berat (kg)'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Tinggi (cm)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : calculateBmi,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Hitung'),
            ),
            const SizedBox(height: 24),
            if (resultText.isNotEmpty)
              Column(
                children: [
                  Text('BMI: $resultText', style: const TextStyle(fontSize: 24)),
                  Text('Kategori: $category', style: const TextStyle(fontSize: 18)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}