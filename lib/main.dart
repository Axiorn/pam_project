import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pam_project/presentation/screens/subscription/subscription_screen.dart';

import 'core/constants/hive_boxes.dart';
import 'core/models/user_model.dart';
import 'core/models/bmi_result_model.dart';
import 'routes/app_routes.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/themes/app_theme.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/bmi/bmi_history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);

  Hive.registerAdapter(UserModelAdapter()); // typeId: 0
  Hive.registerAdapter(BmiResultModelAdapter()); // typeId: 1

  const isDevMode = false;
  if (isDevMode) {
    if (Hive.isBoxOpen(HiveBoxes.users)) {
      await Hive.box(HiveBoxes.users).close();
    }
    await Hive.deleteBoxFromDisk(HiveBoxes.users);

    if (Hive.isBoxOpen(HiveBoxes.bmi)) {
      await Hive.box(HiveBoxes.bmi).close();
    }
    await Hive.deleteBoxFromDisk(HiveBoxes.bmi);
  }

  await Hive.openBox<UserModel>(HiveBoxes.users);
  await Hive.openBox(HiveBoxes.session);
  await Hive.openBox<BmiResultModel>(HiveBoxes.bmi);
  // await Hive.deleteBoxFromDisk(HiveBoxes.bmi); // untuk menghapus hive

  final sessionBox = Hive.box(HiveBoxes.session);
  final isLoggedIn = sessionBox.get('loggedInUser') != null;

  runApp(MyApp(initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI App',
      theme: AppTheme.lightTheme,
      initialRoute: initialRoute,
      debugShowCheckedModeBanner: false,
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.history: (context) => const BmiHistoryScreen(),
        AppRoutes.subscription: (context) => const SubscriptionScreen(),
      },
    );
  }
}