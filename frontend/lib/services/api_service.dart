import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  static Future<List<Task>> fetchTasks() async {
    final res = await http.get(Uri.parse("$baseUrl/tasks/"));
    List data = json.decode(res.body);
    return data.map((e) => Task.fromJson(e)).toList();
  }

  static Future<void> createTask({
    required String title,
    required String description,
    required String status,
    required String dueDate,
    int? blockedBy,
  }) async {
    await Future.delayed(Duration(seconds: 2));

    await http.post(
      Uri.parse("$baseUrl/tasks/"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "title": title,
        "description": description,
        "due_date": dueDate,
        "status": status,
        "blocked_by": blockedBy,
      }),
    );
  }

  static Future<void> updateTask(int id, Map data) async {
    await http.put(
      Uri.parse("$baseUrl/tasks/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
  }

  static Future<void> deleteTask(int id) async {
    await http.delete(Uri.parse("$baseUrl/tasks/$id"));
  }
}