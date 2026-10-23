import 'package:flutter/material.dart';
import '../models/item.dart';
import '../widgets/event_card.dart';
import 'event_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({
    super.key,
    required this.items,
    required this.onFavoriteToggle,
  });

  final List<Item> items;
  final Function(Item) onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final favoriteItems = items.where((item) => item.favourite).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Events')),
      body: favoriteItems.isEmpty
          ? const Center(child: Text('No favorite events yet'))
          : ListView.builder(
        itemCount: favoriteItems.length,
        itemBuilder: (context, index) {
          final item = favoriteItems[index];
          return EventCard(
            item: item,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EventDetailScreen(item: item),
                ),
              );
            },
            onFavoriteToggle: () => onFavoriteToggle(item),
          );
        },
      ),
    );
  }
}