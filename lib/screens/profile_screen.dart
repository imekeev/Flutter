import 'package:flutter/material.dart';
import '../models/profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Profile _profile = const Profile(
    name: 'Student User',
    group: 'CS-201',
  );

  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _groupController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _profile.name);
    _groupController = TextEditingController(text: _profile.group);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    setState(() {
      _profile = Profile(
        name: _nameController.text,
        group: _groupController.text,
      );
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveProfile();
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
              const SizedBox(height: 24),
              if (_isEditing) ...[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _groupController,
                  decoration: const InputDecoration(
                    labelText: 'Group',
                    border: OutlineInputBorder(),
                  ),
                ),
              ] else ...[
                Text(
                  _profile.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  _profile.group,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
              ],
              const SizedBox(height: 32),
              SwitchListTile(
                title: const Text('Dark Theme'),
                secondary: const Icon(Icons.dark_mode),
                value: widget.isDarkMode,
                onChanged: widget.onThemeChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}