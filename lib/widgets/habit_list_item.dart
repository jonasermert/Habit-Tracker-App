import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/habit_tracker_model.dart';

class HabitListItem extends StatelessWidget {
  const HabitListItem({super.key, required this.habit});

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final model = context.read<HabitTrackerModel>();
    final theme = Theme.of(context);
    final muted = theme.brightness == Brightness.dark
        ? const Color(0xFFA3A3A3)
        : const Color(0xFF737373);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Checkbox(
              value: habit.isDone,
              onChanged: (_) => model.toggleHabit(habit),
              semanticLabel: habit.isDone ? 'Als offen markieren' : 'Als erledigt markieren',
            ),
            Expanded(
              child: Text(
                habit.title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  decoration: habit.isDone ? TextDecoration.lineThrough : null,
                  color: habit.isDone ? muted : theme.colorScheme.onSurface,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Gewohnheit löschen',
              icon: Icon(Icons.delete_outline, color: muted),
              onPressed: () => model.deleteHabit(habit),
            ),
          ],
        ),
      ),
    );
  }
}
