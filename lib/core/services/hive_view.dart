import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/hive_boxes.dart';
import '../models/user_model.dart';
import '../models/bmi_result_model.dart';

class HiveViewerScreen extends StatelessWidget {
  const HiveViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box<UserModel>(HiveBoxes.users);
    final bmiBox = Hive.box<BmiResultModel>(HiveBoxes.bmi);
    final sessionBox = Hive.box(HiveBoxes.session);

    return Scaffold(
      appBar: AppBar(title: const Text('Hive Viewer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('👤 Users', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ValueListenableBuilder(
              valueListenable: userBox.listenable(),
              builder: (context, Box<UserModel> box, _) {
                if (box.isEmpty) return const Text('Tidak ada data user.');
                return Column(
                  children: box.values.map((user) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text('Username : ${user.username}'),
                        subtitle: Text(
                          'Nama: ${user.fullName}\n'
                          'Password (hash): ${user.password}\n'
                          'Kuota: ${user.remainingQuota}\n'
                          'Langganan: ${user.isSubscribed ? "Aktif" : "Tidak"}\n'
                          'Sampai: ${user.subscriptionUntil ?? "-"}',
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text('📦 BMI Records', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ValueListenableBuilder(
              valueListenable: bmiBox.listenable(),
              builder: (context, Box<BmiResultModel> box, _) {
                if (box.isEmpty) return const Text('Tidak ada data BMI.');
                return Column(
                  children: box.values.map((bmi) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text('${bmi.username} - ${bmi.category}'),
                        subtitle: Text(
                          'Berat: ${bmi.weight} kg\n'
                          'Tinggi: ${bmi.height} cm\n'
                          'BMI: ${bmi.bmi.toStringAsFixed(2)}\n'
                          'Waktu: ${bmi.dateTime}\n'
                          'Lokasi: ${bmi.location}',
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text('🔑 Session', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ValueListenableBuilder(
              valueListenable: sessionBox.listenable(),
              builder: (context, Box box, _) {
                final loggedIn = box.get('loggedInUser');
                return Text('loggedInUser: ${loggedIn ?? "Tidak ada"}');
              },
            ),
          ],
        ),
      ),
    );
  }
}