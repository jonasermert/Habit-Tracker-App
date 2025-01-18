import 'package:flutter/material.dart';
import 'package:habit_tracker/main.dart' as main;
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/habit_tracker_model.dart';
import '../widgets/habit_list_item.dart';

class HabitTrackerScreen extends StatelessWidget {
  const HabitTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HabitTrackerModel>(context);
    final themeNotifier = Provider.of<main.ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        actions: [
          IconButton(
            icon: Icon(themeNotifier.isDarkMode
                ? Icons.wb_sunny
                : Icons.nightlight_round),
            onPressed: themeNotifier.toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: model.selectedDate,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            calendarFormat: CalendarFormat.month,
            onDaySelected: (selectedDay, _) =>
                model.setSelectedDate(selectedDay),
            selectedDayPredicate: (day) => isSameDay(day, model.selectedDate),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Neuen Habit hinzufügen',
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        model.addHabit(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: model.habits.length,
              itemBuilder: (context, index) {
                final habit = model.habits[index];
                return HabitListItem(habit: habit);
              },
            ),
          ),
        ],
      ),
    );
  }
}
