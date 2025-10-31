import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../core/constants/hive_boxes.dart';
import '../../../core/models/bmi_result_model.dart';

class BmiHistoryScreen extends StatefulWidget {
  const BmiHistoryScreen({super.key});

  @override
  State<BmiHistoryScreen> createState() => _BmiHistoryScreenState();
}

class _BmiHistoryScreenState extends State<BmiHistoryScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedCategory = 'Semua';
  String selectedTimeZone = 'Default';

  List<BmiResultModel> allBmi = [];
  List<BmiResultModel> filteredBmi = [];

  final List<String> categoryOptions = [
    'Semua',
    'Underweight',
    'Normal weight',
    'Overweight',
    'Obesity',
  ];

  final List<String> timeZoneOptions = [
    'Default',
    'WIB',
    'WITA',
    'WIT',
    'London',
  ];

  @override
  void initState() {
    super.initState();
    loadBmiData();
  }

  void loadBmiData() {
    final sessionBox = Hive.box(HiveBoxes.session);
    final loggedInUser = sessionBox.get('loggedInUser');

    final bmiBox = Hive.box<BmiResultModel>(HiveBoxes.bmi);
    final userBmi = bmiBox.values
        .where((bmi) => bmi.username == loggedInUser)
        .toList()
        .reversed
        .toList();

    setState(() {
      allBmi = userBmi;
      filteredBmi = userBmi;
    });
  }

  void applyFilters() {
    final query = searchController.text.trim();
    final isSearching = query.isNotEmpty;
    final isFilteringCategory = selectedCategory != 'Semua';

    setState(() {
      filteredBmi = allBmi.where((bmi) {
        final matchWeight = isSearching
            ? bmi.weight.toString().contains(query)
            : true;
        final matchCategory = isFilteringCategory
            ? bmi.category.toLowerCase() == selectedCategory.toLowerCase()
            : true;
        return matchWeight && matchCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat BMI')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Cari berdasarkan berat (kg)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (_) => applyFilters(),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    items: categoryOptions
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) {
                      selectedCategory = value!;
                      applyFilters();
                    },
                    decoration: const InputDecoration(
                      labelText: 'Kategori BMI',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedTimeZone,
                    items: timeZoneOptions
                        .map((z) => DropdownMenuItem(value: z, child: Text(z)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTimeZone = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Zona Waktu',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredBmi.isEmpty
                  ? const Center(child: Text('Tidak ada data yang cocok.'))
                  : ListView.builder(
                      itemCount: filteredBmi.length,
                      itemBuilder: (context, index) {
                        final bmi = filteredBmi[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
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
            ),
          ],
        ),
      ),
    );
  }
}