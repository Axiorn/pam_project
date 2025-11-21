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
  String selectedTimeZone = 'Default (WIB)';

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
    'Default (WIB)',
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
        final matchWeight =
            isSearching ? bmi.weight.toString().contains(query) : true;
        final matchCategory = isFilteringCategory
            ? bmi.category.toLowerCase() == selectedCategory.toLowerCase()
            : true;
        return matchWeight && matchCategory;
      }).toList();
    });
  }

  DateTime convertToTimeZone(DateTime original, String zone) {
    DateTime adjusted;
    switch (zone) {
      case 'WITA':
        adjusted = original.add(const Duration(hours: 1));
        break;
      case 'WIT':
        adjusted = original.add(const Duration(hours: 2));
        break;
      case 'London':
        adjusted = original.subtract(const Duration(hours: 7));
        break;
      default:
        adjusted = original;
    }
    return adjusted;
  }

  String formatDateTime(String rawDateTime) {
    try {
      final original = DateTime.parse(rawDateTime);
      final adjusted = convertToTimeZone(original, selectedTimeZone);
      return '${adjusted.day.toString().padLeft(2, '0')}-'
          '${adjusted.month.toString().padLeft(2, '0')}-'
          '${adjusted.year} ${adjusted.hour.toString().padLeft(2, '0')}:'
          '${adjusted.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return rawDateTime;
    }
  }

  Color getCategoryColor(String category, BuildContext context) {
    switch (category.toLowerCase()) {
      case 'underweight':
        return Colors.blueAccent;
      case 'normal weight':
        return Colors.green;
      case 'overweight':
        return Colors.orangeAccent;
      case 'obesity':
        return Colors.redAccent;
      default:
        return Theme.of(context).colorScheme.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Kalkulasi BMI'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: textTheme.bodyMedium?.color,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔍 SEARCH FIELD
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Cari berdasarkan berat (kg)',
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (_) => applyFilters(),
            ),
            const SizedBox(height: 12),

            // 🧩 FILTERS
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    items: categoryOptions
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c, style: textTheme.bodyMedium),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                        applyFilters();
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Kategori BMI'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedTimeZone,
                    items: timeZoneOptions
                        .map((z) => DropdownMenuItem(
                              value: z,
                              child: Text(z, style: textTheme.bodyMedium),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTimeZone = value!;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Zona Waktu'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 🧾 LIST BMI HISTORY
            Expanded(
              child: filteredBmi.isEmpty
                  ? Center(
                      child: Text(
                        'Tidak ada data yang cocok.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: textTheme.bodyMedium?.color?.withOpacity(0.6),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredBmi.length,
                      itemBuilder: (context, index) {
                        final bmi = filteredBmi[index];
                        final formattedDate = formatDateTime(bmi.dateTime);
                        final categoryColor =
                            getCategoryColor(bmi.category, context);

                        return Card(
                          color: theme.cardColor,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: categoryColor.withOpacity(0.2),
                              child: Icon(Icons.fitness_center,
                                  color: categoryColor),
                            ),
                            title: Text(
                              'BMI: ${bmi.bmi.toStringAsFixed(2)} - ${bmi.category}',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: categoryColor,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'Berat: ${bmi.weight} kg\n'
                                'Tinggi: ${bmi.height} cm\n'
                                'Tanggal: $formattedDate\n'
                                'Format Waktu: ($selectedTimeZone)\n'
                                'Lokasi: ${bmi.location}',
                                style: textTheme.bodySmall?.copyWith(
                                  height: 1.4,
                                  color: textTheme.bodySmall?.color,
                                ),
                              ),
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