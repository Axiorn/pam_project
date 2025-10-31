import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/hive_boxes.dart';
import '../models/user_model.dart';

class HiveViewerScreen extends StatelessWidget {
  const HiveViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box<UserModel>(HiveBoxes.users);
    final users = userBox.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Hive Viewer')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final u = users[index];
          return ListTile(
            title: Text(u.username),
            subtitle: Text('Password: ${u.password}\nKuota: ${u.remainingQuota}'),
          );
        },
      ),
    );
  }
}