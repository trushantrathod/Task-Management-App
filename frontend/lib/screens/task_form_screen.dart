import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/task.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final title = TextEditingController();
  final desc = TextEditingController();

  String status = "To-Do";
  DateTime? date;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      // ✅ EDIT MODE
      title.text = widget.task!.title;
      desc.text = widget.task!.description;
      status = widget.task!.status;

      if (widget.task!.dueDate.isNotEmpty) {
        date = DateTime.tryParse(widget.task!.dueDate);
      }
    } else {
      // ✅ CREATE MODE
      loadDraft();
    }
  }

  // ✅ SAVE DRAFT (ONLY FOR CREATE)
  void saveDraft() async {
    if (widget.task != null) return;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("draft_title", title.text);
    prefs.setString("draft_desc", desc.text);
  }

  // ✅ LOAD DRAFT
  void loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    title.text = prefs.getString("draft_title") ?? "";
    desc.text = prefs.getString("draft_desc") ?? "";
    setState(() {});
  }

  // ✅ CLEAR DRAFT
  void clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("draft_title");
    prefs.remove("draft_desc");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? "Create Task" : "Edit Task"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: title,
              decoration: InputDecoration(labelText: "Title"),
              onChanged: (_) => saveDraft(),
            ),

            SizedBox(height: 10),

            TextField(
              controller: desc,
              decoration: InputDecoration(labelText: "Description"),
              onChanged: (_) => saveDraft(),
            ),

            SizedBox(height: 15),

            DropdownButtonFormField(
              value: status,
              decoration: InputDecoration(labelText: "Status"),
              items: ["To-Do", "In Progress", "Done"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => status = v!),
            ),

            SizedBox(height: 15),

            ElevatedButton(
              onPressed: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: date ?? DateTime.now(),
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2030),
                );

                if (d != null) {
                  setState(() => date = d);
                }
              },
              child: Text(
                date == null
                    ? "Select Due Date"
                    : "Due: ${date!.toString().split(" ")[0]}",
              ),
            ),

            SizedBox(height: 25),

            loading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () async {
                      if (title.text.isEmpty || desc.text.isEmpty) return;

                      setState(() => loading = true);

                      if (widget.task != null) {
                        // ✅ UPDATE
                        await ApiService.updateTask(widget.task!.id, {
                          "title": title.text,
                          "description": desc.text,
                          "status": status,
                          "due_date":
                              date?.toString().split(" ")[0],
                        });
                      } else {
                        // ✅ CREATE
                        await ApiService.createTask(
                          title: title.text,
                          description: desc.text,
                          status: status,
                          dueDate:
                              date?.toString().split(" ")[0] ?? "",
                        );
                      }

                      clearDraft();

                      setState(() => loading = false);

                      Navigator.pop(context, true);
                    },
                    child: Text("Save"),
                  ),
          ],
        ),
      ),
    );
  }
}