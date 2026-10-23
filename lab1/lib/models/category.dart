import 'package:flutter/material.dart';

/// Ровно 5 значений: в защите может выпасть задача "добавь шестое".
enum EventCategory {
  tech('Tech', Icons.computer),
  music('Music', Icons.music_note),
  sport('Sport', Icons.sports_soccer),
  art('Art', Icons.palette),
  career('Career', Icons.work);

  const EventCategory(this.label, this.icon);

  final String label;
  final IconData icon;

  /// R2: исчерпывающий switch-expression, возвращает роль из colorScheme.
  /// Добавишь значение в enum - компилятор сам покажет, где не хватает ветки.
  Color color(ColorScheme scheme) => switch (this) {
    EventCategory.tech => scheme.primary,
    EventCategory.music => scheme.secondary,
    EventCategory.sport => scheme.tertiary,
    EventCategory.art => scheme.error,
    EventCategory.career => scheme.primaryContainer,
  };
}