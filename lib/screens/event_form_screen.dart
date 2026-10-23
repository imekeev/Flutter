import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/item.dart';

class EventFormScreen extends StatefulWidget {
  const EventFormScreen({super.key});

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _location = '';
  String? _description;
  int _capacity = 20;
  EventCategory _category = EventCategory.tech;
  bool _online = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.isEmpty ? 'Enter title' : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Location / URL'),
                validator: (value) => value == null || value.isEmpty ? 'Enter location' : null,
                onSaved: (value) => _location = value!,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<EventCategory>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: EventCategory.values.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat.label),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _category = val);
                  }
                },
              ),
              SwitchListTile(
                title: const Text('Online Event'),
                value: _online,
                onChanged: (val) => setState(() => _online = val),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Capacity'),
                initialValue: '20',
                keyboardType: TextInputType.number,
                onSaved: (val) => _capacity = int.tryParse(val ?? '') ?? 20,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description (optional)'),
                maxLines: 3,
                onSaved: (val) => _description = val,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newItem = Item(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: _title,
                      category: _category,
                      starts: DateTime.now().add(const Duration(days: 1)),
                      capacity: _capacity,
                      location: _location,
                      online: _online,
                      description: _description,
                    );
                    Navigator.of(context).pop(newItem);
                  }
                },
                child: const Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}