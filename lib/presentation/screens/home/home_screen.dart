import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import 'bottom_navbar.dart';
import '../profile/profile_screen.dart';
import '../feedback/feedback_screen.dart';
import '../bmi/bmi_calculator_screen.dart';
import '../bmi/bmi_history_screen.dart';
import '../subscription/subscription_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2; // default ke BMI Calculator

  final List<Widget> _pages = const [
    ProfileScreen(),
    FeedbackScreen(),
    BmiCalculatorScreen(),
    BmiHistoryScreen(),
    SubscriptionScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}