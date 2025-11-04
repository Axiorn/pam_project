import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: theme.bottomNavigationBarTheme.backgroundColor ??
          theme.scaffoldBackgroundColor,
      selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor ??
          colorScheme.primary,
      unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor ??
          colorScheme.onSurface.withOpacity(0.6),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Kesan'),
        BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'BMI'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        BottomNavigationBarItem(
            icon: Icon(Icons.card_membership), label: 'Langganan'),
      ],
    );
  }
}