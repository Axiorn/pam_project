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
    'USD': 0.00065,
    'YEN': 0.097,
    'SGD': 0.00088,
  };

  @override
  void initState() {
    super.initState();
    selectedPackage = packages[0];
    selectedCurrency = currencies[0];
  }

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(title: const Text('Langganan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.isSubscribed
                  ? 'Langganan aktif hingga ${user.subscriptionUntil}'
                  : 'Anda belum berlangganan',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            const Text('Pilih Paket:', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedPackage,
              items: packages.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPackage = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Pilih Mata Uang:', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedCurrency,
              items: currencies.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCurrency = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Harga: ${convertedPrice.toStringAsFixed(2)} $selectedCurrency',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final quota = packageQuota[selectedPackage]!;
                authService.activateSubscription(days: 30, additionalQuota: quota);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Langganan $selectedPackage berhasil diaktifkan!')),
                );
                setState(() {});
              },
              child: const Text('Aktifkan Langganan'),
            ),
          ],
        ),
      ),
    );
  }
}