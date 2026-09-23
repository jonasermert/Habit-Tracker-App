import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

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
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    _habits.putIfAbsent(_dateKey(_selectedDate), () => []).add(Habit(title: trimmed));
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
        final data = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
        _habits = data.map((key, value) => MapEntry(
          key,
          (value as List).map((entry) => Habit.fromJson(entry as Map<String, dynamic>)).toList(),
        ));
        notifyListeners();
      }
    } on FileSystemException catch (error) {
      debugPrint('Gewohnheiten konnten nicht geladen werden: $error');
    } on FormatException catch (error) {
      debugPrint('Ungültige Gewohnheitsdaten: $error');
    }
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
    title: json['title'] as String,
    isDone: json['isDone'] as bool,
  );

  Map<String, dynamic> toJson() => {'title': title, 'isDone': isDone};
}
