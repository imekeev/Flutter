import 'package:flutter/material.dart';
import 'data/seed.dart';
import 'models/item.dart';
import 'screens/favorites_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/event_form_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;




  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Events',
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: MainContainer(onThemeChanged: _toggleTheme, isDarkMode: _themeMode == ThemeMode.dark),
    );
  }
}

class MainContainer extends StatefulWidget {
  const MainContainer({super.key, required this.onThemeChanged, required this.isDarkMode});

  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;
  late List<Item> _items;

  @override
  void initState() {
    super.initState();
    _items = buildSeed();
  }

  void _toggleFavorite(Item item) {
    setState(() {
      final index = _items.indexWhere((element) => element.id == item.id);
      if (index != -1) {
        _items[index] = item.copyWith(favourite: !item.favourite);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(items: _items, onFavoriteToggle: _toggleFavorite),
      FavoritesScreen(items: _items, onFavoriteToggle: _toggleFavorite),
      ProfileScreen(onThemeChanged: widget.onThemeChanged, isDarkMode: widget.isDarkMode),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Events'),
      ),
      body: screens[_currentIndex],
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newItem = await Navigator.of(context).push<Item>(
            MaterialPageRoute(
              builder: (context) => const EventFormScreen(),
            ),
          );
          if (newItem != null) {
            setState(() {
              _items.insert(0, newItem);
            });
          }
        },
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}