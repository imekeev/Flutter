import 'package:flutter/material.dart';
import '../models/item.dart';
import '../utils/format.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = item.category.color(theme.colorScheme);

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Категория
            Chip(
              avatar: Icon(item.category.icon, color: categoryColor),
              label: Text(item.category.label),
              backgroundColor: categoryColor.withOpacity(0.1),
            ),
            const SizedBox(height: 16),

            // Время и Место
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 8),
                Text(formatDateTime(item.starts), style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(item.online ? Icons.link : Icons.location_on, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.location,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Вместимость
            LinearProgressIndicator(
              value: item.count / item.capacity,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 8),
            Text(
              'Участники: ${item.count} / ${item.capacity} (свободно: ${item.free})',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            // Описание
            if (item.description != null && item.description!.isNotEmpty) ...[
              Text('Описание', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(item.description!, style: theme.textTheme.bodyLarge),
            ],
          ],
        ),
      ),
    );
  }
}