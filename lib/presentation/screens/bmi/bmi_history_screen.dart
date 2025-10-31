import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../core/constants/hive_boxes.dart';
import '../../../core/models/bmi_result_model.dart';

class BmiHistoryScreen extends StatelessWidget {
  const BmiHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionBox = Hive.box(HiveBoxes.session);
    final loggedInUser = sessionBox.get('loggedInUser');

    final bmiBox = Hive.box<BmiResultModel>(HiveBoxes.bmi);
    final bmiList = bmiBox.values
        .where((bmi) => bmi.username == loggedInUser)
        .toList()
        .reversed
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat BMI')),
      body: bmiList.isEmpty
          ? const Center(child: Text('Belum ada data BMI untuk akun ini.'))
          : ListView.builder(
              itemCount: bmiList.length,
              itemBuilder: (context, index) {
                final bmi = bmiList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text('BMI: ${bmi.bmi.toStringAsFixed(2)} - ${bmi.category}'),
                    subtitle: Text(
                      'Berat: ${bmi.weight} kg\n'
                      'Tinggi: ${bmi.height} cm\n'
                      'Tanggal: ${bmi.dateTime}\n'
                      'Lokasi: ${bmi.location}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}