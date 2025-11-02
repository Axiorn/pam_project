// ignore_for_file: dead_code
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'core/constants/hive_boxes.dart';
import 'core/models/user_model.dart';
import 'core/models/bmi_result_model.dart';
import 'core/services/hive_view.dart';
import 'presentation/screens/subscription/subscription_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/bmi/bmi_history_screen.dart';
import 'presentation/themes/app_theme.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'alerts',
        channelName: 'Alerts',
        channelDescription: 'Notifikasi untuk BMI dan langganan',
        defaultColor: Colors.deepPurple,
        ledColor: Colors.deepPurple,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      )
    ],
    debug: true,
  );

  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);

  Hive.registerAdapter(UserModelAdapter()); // typeId: 0
  Hive.registerAdapter(BmiResultModelAdapter()); // typeId: 1

  const isDevMode = false; //reset database hive
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
        AppRoutes.hivebox: (context) => const HiveViewerScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.history: (context) => const BmiHistoryScreen(),
        AppRoutes.subscription: (context) => const SubscriptionScreen(),
      },
    );
  }
}