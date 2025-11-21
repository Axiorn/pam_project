import 'package:flutter/material.dart';
import 'package:pam_project/core/services/auth_service.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final authService = AuthService();
  late String selectedPackage;
  late String selectedCurrency;

  final List<String> packages = ['Bronze', 'Silver', 'Gold'];
  final List<String> currencies = ['IDR', 'USD', 'YEN', 'SGD'];

  final Map<String, int> packageQuota = {
    'Bronze': 5,
    'Silver': 10,
    'Gold': 15,
  };

  final Map<String, int> packagePriceIDR = {
    'Bronze': 10000,
    'Silver': 20000,
    'Gold': 30000,
  };

  final Map<String, double> currencyRates = {
    'IDR': 1.0,
    'USD': 0.0000598,
    'YEN': 0.00926,
    'SGD': 0.0000778,
  };

  @override
  void initState() {
    super.initState();
    selectedPackage = packages[0];
    selectedCurrency = currencies[0];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = authService.getCurrentUser();

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('User tidak ditemukan')),
      );
    }

    final basePrice = packagePriceIDR[selectedPackage]!;
    final rate = currencyRates[selectedCurrency]!;
    final convertedPrice = basePrice * rate;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Langganan'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.workspace_premium_rounded,
                    size: 80,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Paket Langganan',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user.isSubscribed
                        ? 'Langganan aktif hingga ${user.subscriptionUntil}'
                        : 'Anda belum berlangganan',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Pilih Paket
            Text(
              'Pilih Paket:',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedPackage,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.inputDecorationTheme.fillColor,
              ),
              dropdownColor: theme.cardColor,
              items: packages
                  .map(
                    (p) => DropdownMenuItem(
                      value: p,
                      child: Text(
                        '$p — ${packageQuota[p]} kuota',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedPackage = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            Text(
              'Pilih Mata Uang:',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedCurrency,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.inputDecorationTheme.fillColor,
              ),
              dropdownColor: theme.cardColor,
              items: currencies
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(
                        c,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCurrency = value!;
                });
              },
            ),
            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Harga',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${convertedPrice.toStringAsFixed(2)} $selectedCurrency',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: const Text('Aktifkan Langganan'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  final quota = packageQuota[selectedPackage]!;
                  await authService.activateSubscription(
                    days: 30,
                    additionalQuota: quota,
                    packageName: selectedPackage,
                  );
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Langganan aktif selama 30 hari • Kuota akan ditambahkan otomatis',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}