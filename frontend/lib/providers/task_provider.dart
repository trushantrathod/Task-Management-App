import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _filtered = [];
  bool _loading = false;

  List<Task> get tasks => _filtered;
  bool get isLoading => _loading;

  Future<void> fetchTasks() async {
    _loading = true;
    notifyListeners();

    _tasks = await ApiService.fetchTasks();
    _filtered = _tasks;

    _loading = false;
    notifyListeners();
  }

  void search(String q) {
    _filtered = _tasks
        .where((t) => t.title.toLowerCase().contains(q.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void filter(String status) {
    if (status == "All") {
      _filtered = _tasks;
    } else {
      _filtered = _tasks.where((t) => t.status == status).toList();
    }
    notifyListeners();
  }
}