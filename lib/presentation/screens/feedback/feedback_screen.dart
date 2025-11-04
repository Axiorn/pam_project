import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kesan & Pesan'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Section
            Icon(
              Icons.emoji_people_rounded,
              size: 80,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Terima Kasih!',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Berikut kesan dan pesan saya selama mengikuti mata kuliah ini.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 28),

            // Kesan Card
            const FeedbackCard(
              title: 'Kesan',
              emoji: '💡',
              content:
                  'Mata kuliah ini sangat membantu saya memahami praktik pengembangan aplikasi mobile secara nyata. Saya jadi lebih percaya diri membangun aplikasi Flutter yang modular dan terintegrasi.',
            ),
            const SizedBox(height: 20),

            // Pesan Card
            const FeedbackCard(
              title: 'Pesan',
              emoji: '📚',
              content:
                  'Semoga ke depannya materi bisa lebih banyak studi kasus nyata dan diberikan tantangan proyek yang lebih kompleks agar kami bisa belajar lebih dalam dan siap menghadapi dunia kerja.',
            ),

            const SizedBox(height: 40),

            // Footer Message
            Text(
              '✨ Keep learning and keep building amazing things! ✨',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedbackCard extends StatelessWidget {
  final String title;
  final String content;
  final String emoji;

  const FeedbackCard({
    super.key,
    required this.title,
    required this.content,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      elevation: isDark ? 2 : 4,
      shadowColor: isDark
          ? Colors.black.withOpacity(0.4)
          : Colors.grey.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with emoji
            Row(
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}