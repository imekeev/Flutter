import 'category.dart';
import 'countdown.dart';

/// R1: все поля final, const-конструктор, copyWith.
/// Список имён приватный, наружу отдаётся только неизменяемая копия.
class Item {
  const Item({
    required this.id,
    required this.title,
    required this.category,
    required this.starts,
    required this.capacity,
    required this.location,
    this.online = false,
    this.description,
    this.favourite = false,
    List<String> attendees = const [],
  }) : _attendees = attendees;

  /// R3: значения по умолчанию для нового элемента.
  Item.empty()
      : this(
    id: '',
    title: '',
    category: EventCategory.tech,
    starts: DateTime.now().add(const Duration(days: 1)),
    capacity: 10,
    location: '',
  );

  final String id;
  final String title; // 3-60 символов (проверяется в форме)
  final EventCategory category;
  final DateTime starts;
  final int capacity; // лимит
  final String location; // при online == true это ссылка
  final bool online; // меняет смысл и валидацию location
  final String? description; // необязательный текст
  final bool favourite;
  final List<String> _attendees;

  // ---- R4: производные значения - геттеры, не поля ----
  List<String> get attendees => List.unmodifiable(_attendees);
  int get count => _attendees.length;
  int get free => capacity - count;
  bool get isFull => count >= capacity;
  bool get isPast => starts.isBefore(DateTime.now());
  bool contains(String name) => _attendees.contains(name);

  /// R5: record-геттер. Разбирается так: final (:taken, :free) = item.places;
  ({int taken, int free}) get places => (taken: count, free: free);

  /// R9: обратный отсчёт. Через 3 часа после старта считаем, что закончилось.
  Countdown countdownAt(DateTime now) {
    final diff = starts.difference(now);
    if (!diff.isNegative) return Upcoming(diff);
    if (diff.abs() < const Duration(hours: 3)) return Started(diff.abs());
    return const Ended();
  }

  Item copyWith({
    String? id,
    String? title,
    EventCategory? category,
    DateTime? starts,
    int? capacity,
    String? location,
    bool? online,
    String? description,
    bool clearDescription = false,
    bool? favourite,
    List<String>? attendees,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      starts: starts ?? this.starts,
      capacity: capacity ?? this.capacity,
      location: location ?? this.location,
      online: online ?? this.online,
      description: clearDescription ? null : (description ?? this.description),
      favourite: favourite ?? this.favourite,
      attendees: attendees == null ? _attendees : List.of(attendees),
    );
  }
}