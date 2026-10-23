import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/item.dart';
import '../widgets/event_card.dart';
import 'event_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.items,
    required this.onFavoriteToggle,
  });

  final List<Item> items;
  final Function(Item) onFavoriteToggle;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  EventCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Column(
      children: [
        // Вкладки: Upcoming / Past
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
        // Строка поиска
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search events...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
            ),
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
        ),
        // Чипы категорий
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _selectedCategory == null,
                onSelected: (sel) => setState(() => _selectedCategory = null),
              ),
              const SizedBox(width: 8),
              for (final cat in EventCategory.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat.label),
                    selected: _selectedCategory == cat,
                    onSelected: (sel) => setState(() => _selectedCategory = sel ? cat : null),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Список событий по вкладкам
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildEventList(isPast: false, now: now),
              _buildEventList(isPast: true, now: now),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventList({required bool isPast, required DateTime now}) {
    final filtered = widget.items.where((item) {
      final matchesTime = isPast ? item.starts.isBefore(now) : item.starts.isAfter(now) || item.starts.isAtSameMomentAs(now);
      final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.location.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCat = _selectedCategory == null || item.category == _selectedCategory;
      return matchesTime && matchesSearch && matchesCat;
    }).toList();

    if (filtered.isEmpty) {
      return Center(child: Text(isPast ? 'No past events' : 'No upcoming events'));
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return EventCard(
          item: item,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EventDetailScreen(item: item),
              ),
            );
          },
          onFavoriteToggle: () => widget.onFavoriteToggle(item),
        );
      },
    );
  }
}