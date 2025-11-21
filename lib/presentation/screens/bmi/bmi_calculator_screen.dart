import 'package:flutter/material.dart';
import 'package:pam_project/presentation/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/hive_service.dart';
import '../../../core/utils/location_helper.dart';
import '../../../core/models/bmi_result_model.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/notification_controller.dart';

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
    final timestamp = DateTime.now().toIso8601String();
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
      await NotificationController.showSuccessNotification(
        'BMI Tersimpan',
        'BMI kamu berhasil dihitung dan disimpan.',
      );
      authService.decreaseQuota();
      setState(() {
        currentUser = authService.getCurrentUser();
      });
    } else {
      notificationService.showError(context, 'Gagal menyimpan data BMI.');
    }
  }

  @override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final textTheme = theme.textTheme;

  return Scaffold(
    backgroundColor: theme.scaffoldBackgroundColor,
    resizeToAvoidBottomInset: true, // biar keyboard bisa scroll tampilan, tanpa overflow
    body: SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // tutup keyboard
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Bagian atas
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(4),
                                child: IconButton(
                                  icon: Icon(
                                    theme.brightness == Brightness.dark
                                        ? Icons.nightlight_round
                                        : Icons.wb_sunny_rounded,
                                    color: colorScheme.primary,
                                  ),
                                  onPressed: () {
                                    // toggle theme pakai provider
                                    final provider = Provider.of<ThemeProvider>(context, listen: false);
                                    provider.toggleTheme(theme.brightness != Brightness.dark);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Welcome ${currentUser?.fullName ?? ''}',
                              style: textTheme.bodyMedium?.copyWith(
                                color: textTheme.bodyMedium?.color?.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'BMI Calculator',
                              style: textTheme.titleLarge,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Sisa kuota: ${currentUser?.remainingQuota ?? 0}x',
                              style: textTheme.bodyMedium?.copyWith(
                                color: textTheme.bodyMedium?.color?.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 8),
                                    Text('Weight (kg)', style: textTheme.bodyMedium),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: weightController,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: textTheme.titleLarge?.copyWith(fontSize: 40),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'XX',
                                        hintStyle: textTheme.titleLarge?.copyWith(
                                          fontSize: 40,
                                          color: textTheme.bodyMedium?.color?.withOpacity(0.4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 8),
                                    Text('Height (cm)', style: textTheme.bodyMedium),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: heightController,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: textTheme.titleLarge?.copyWith(fontSize: 40),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'XXX',
                                        hintStyle: textTheme.titleLarge?.copyWith(
                                          fontSize: 40,
                                          color: textTheme.bodyMedium?.color?.withOpacity(0.4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Bagian bawah: hasil + tombol
                        Column(
                          children: [
                            if (resultText.isNotEmpty) ...[
                              Text('BMI: $resultText',
                                  style: textTheme.titleLarge?.copyWith(fontSize: 28)),
                              const SizedBox(height: 6),
                              Text('Kategori: $category',
                                  style: textTheme.bodyMedium?.copyWith(fontSize: 18)),
                              const SizedBox(height: 30),
                            ],
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : calculateBmi,
                                child: isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text("Let's Go"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
}