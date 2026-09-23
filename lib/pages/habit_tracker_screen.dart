import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../main.dart';
import '../models/habit_tracker_model.dart';
import '../theme/app_theme.dart';
import '../widgets/habit_list_item.dart';

class HabitTrackerScreen extends StatefulWidget {
  const HabitTrackerScreen({super.key});

  @override
  State<HabitTrackerScreen> createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addHabit(HabitTrackerModel model) {
    if (_controller.text.trim().isEmpty) return;
    model.addHabit(_controller.text);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<HabitTrackerModel>();
    final themeNotifier = context.watch<ThemeNotifier>();
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final muted = dark ? const Color(0xFFA3A3A3) : const Color(0xFF737373);
    final border = dark ? const Color(0xFF404040) : const Color(0xFFE5E5E5);
    final accent = dark ? AppTheme.accentDark : AppTheme.accentLight;
    final completed = model.habits.where((habit) => habit.isDone).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gewohnheiten', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: themeNotifier.isDarkMode ? 'Helles Design' : 'Dunkles Design',
            icon: Icon(themeNotifier.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            onPressed: themeNotifier.toggleTheme,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Text(
              'Ein Schritt nach dem anderen.',
              style: theme.textTheme.bodyLarge?.copyWith(color: muted),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TableCalendar(
                  focusedDay: model.selectedDate,
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  calendarFormat: CalendarFormat.month,
                  availableCalendarFormats: const {CalendarFormat.month: 'Monat'},
                  onDaySelected: (selectedDay, _) => model.setSelectedDate(selectedDay),
                  selectedDayPredicate: (day) => isSameDay(day, model.selectedDate),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(color: accent, fontWeight: FontWeight.bold),
                    selectedDecoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(color: theme.colorScheme.onPrimary),
                    outsideTextStyle: TextStyle(color: muted),
                    weekendTextStyle: TextStyle(color: theme.colorScheme.onSurface),
                    defaultTextStyle: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: Text('Deine Gewohnheiten', style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
                ),
                Text('$completed / ${model.habits.length}', style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w700,
                )),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintText: 'Neue Gewohnheit',
                      prefixIcon: Icon(Icons.edit_outlined),
                    ),
                    onSubmitted: (_) => _addHabit(model),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  tooltip: 'Gewohnheit hinzufügen',
                  onPressed: () => _addHabit(model),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (model.habits.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                  child: Column(
                    children: [
                      Icon(Icons.check_circle_outline, size: 38, color: muted),
                      const SizedBox(height: 12),
                      const Text('Noch keine Gewohnheiten für diesen Tag.',
                        textAlign: TextAlign.center),
                      const SizedBox(height: 6),
                      Text('Füge oben deine erste Gewohnheit hinzu.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: muted)),
                    ],
                  ),
                ),
              )
            else
              ...model.habits.map((habit) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: HabitListItem(habit: habit),
              )),
            if (model.habits.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: LinearProgressIndicator(
                  value: completed / model.habits.length,
                  color: accent,
                  backgroundColor: border,
                  borderRadius: BorderRadius.circular(8),
                  minHeight: 6,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
