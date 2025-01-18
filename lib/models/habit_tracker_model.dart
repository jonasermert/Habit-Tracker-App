import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/habit_tracker_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitTrackerModel()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode:
                themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const HabitTrackerScreen(),
          );
        },
      ),
    );
  }
}

class HabitTrackerModel extends ChangeNotifier {
  Map<String, List<Habit>> _habits = {};
  DateTime _selectedDate = DateTime.now();

  HabitTrackerModel() {
    _loadData();
  }

  DateTime get selectedDate => _selectedDate;

  List<Habit> get habits => _habits[_dateKey(_selectedDate)] ?? [];

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void addHabit(String title) {
    final key = _dateKey(_selectedDate);
    if (!_habits.containsKey(key)) {
      _habits[key] = [];
    }
    _habits[key]!.add(Habit(title: title));
    notifyListeners();
    _saveData();
  }

  void toggleHabit(Habit habit) {
    habit.isDone = !habit.isDone;
    notifyListeners();
    _saveData();
  }

  void deleteHabit(Habit habit) {
    _habits[_dateKey(_selectedDate)]?.remove(habit);
    notifyListeners();
    _saveData();
  }

  String _dateKey(DateTime date) => "${date.year}-${date.month}-${date.day}";

  Future<void> _saveData() async {
    final file = await _localFile;
    await file.writeAsString(jsonEncode(_habits));
  }

  Future<void> _loadData() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final data =
            jsonDecode(await file.readAsString()) as Map<String, dynamic>;
        _habits = data.map((key, value) => MapEntry(
            key, (value as List).map((e) => Habit.fromJson(e)).toList()));
        notifyListeners();
      }
    } catch (e) {}
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/habits.json');
  }
}

class Habit {
  String title;
  bool isDone;

  Habit({required this.title, this.isDone = false});

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        title: json['title'],
        isDone: json['isDone'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'isDone': isDone,
      };
}

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
