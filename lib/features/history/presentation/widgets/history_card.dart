import 'package:flutter/material.dart';
import '../../domain/entities/history.dart';

class HistoryCard extends StatelessWidget {
  final History history;
  final VoidCallback? onTap;

  const HistoryCard({
    super.key,
    required this.history,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final confidencePercent = (history.confidence * 100).toStringAsFixed(1);
    final formattedDate =
        '${history.date.day}/${history.date.month}/${history.date.year}';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.health_and_safety,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          history.conditionName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Tingkat Akurasi: $confidencePercent%'),
            Text(
              'Tanggal: $formattedDate',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
