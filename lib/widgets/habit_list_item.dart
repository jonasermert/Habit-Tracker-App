import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/habit_tracker_model.dart';

class HabitListItem extends StatelessWidget {
  final Habit habit;

  const HabitListItem({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HabitTrackerModel>(context);

    return ListTile(
      title: Text(
        habit.title,
        style: TextStyle(
          decoration: habit.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Checkbox(
        value: habit.isDone,
        onChanged: (_) => model.toggleHabit(habit),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () => model.deleteHabit(habit),
      ),
    );
  }
}
