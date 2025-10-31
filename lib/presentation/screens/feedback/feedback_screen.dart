import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kesan dan Pesan'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            FeedbackCard(
              title: 'Kesan',
              content:
                  'Mata kuliah ini sangat membantu saya memahami praktik pengembangan aplikasi mobile secara nyata. Saya jadi lebih percaya diri membangun aplikasi Flutter yang modular dan terintegrasi.',
            ),
            SizedBox(height: 16),
            FeedbackCard(
              title: 'Pesan',
              content:
                  'Semoga ke depannya materi bisa lebih banyak studi kasus nyata dan diberikan tantangan proyek yang lebih kompleks agar kami bisa belajar lebih dalam dan siap menghadapi dunia kerja.',
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

  const FeedbackCard({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            Text(content,
                style: const TextStyle(
                  fontSize: 16,
                )),
          ],
        ),
      ),
    );
  }
}