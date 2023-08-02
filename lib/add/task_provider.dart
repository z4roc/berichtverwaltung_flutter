import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  List<String> selectedTasks = [];

  void onTaskSelected(String task) {
    if (selectedTasks.contains(task)) {
      selectedTasks.remove(task);
    } else {
      selectedTasks.add(task);
    }
    notifyListeners();
  }
}
