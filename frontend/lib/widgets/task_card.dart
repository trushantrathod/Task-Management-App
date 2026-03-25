import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../services/api_service.dart';
import '../screens/task_form_screen.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isBlocked = task.blockedBy != null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isBlocked ? Colors.grey.shade200 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: ListTile(
        // ❌ Disable entire tile if blocked
        enabled: !isBlocked,

        // ✅ STATUS TOGGLE BUTTON
        leading: GestureDetector(
          onTap: isBlocked
              ? null
              : () async {
                  await ApiService.updateTask(task.id, {
                    "status":
                        task.status == "Done" ? "To-Do" : "Done"
                  });

                  Provider.of<TaskProvider>(context, listen: false)
                      .fetchTasks();
                },
          child: CircleAvatar(
            backgroundColor: _getStatusColor(task.status),
            child: const Icon(Icons.check, color: Colors.white),
          ),
        ),

        // ✅ TITLE + DETAILS
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description),
            const SizedBox(height: 4),
            Text("Due: ${task.dueDate}",
                style: const TextStyle(fontSize: 12)),
            Text("Status: ${task.status}",
                style: const TextStyle(fontSize: 12)),
          ],
        ),

        // ✅ RIGHT SIDE ACTIONS
        trailing: isBlocked
            ? const Icon(Icons.lock, color: Colors.grey) // 🔒 blocked
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ✏️ EDIT
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskFormScreen(task: task),
                        ),
                      );

                      if (result == true) {
                        Provider.of<TaskProvider>(context,
                                listen: false)
                            .fetchTasks();
                      }
                    },
                  ),

                  // 🗑 DELETE
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await ApiService.deleteTask(task.id);

                      Provider.of<TaskProvider>(context,
                              listen: false)
                          .fetchTasks();
                    },
                  ),
                ],
              ),
      ),
    );
  }

  // 🎨 STATUS COLORS
  Color _getStatusColor(String status) {
    switch (status) {
      case "Done":
        return Colors.green;
      case "In Progress":
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}