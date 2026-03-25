import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TaskProvider>(context, listen: false).fetchTasks());
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("FlowTask")),
      body: Column(
        children: [
          TextField(onChanged: p.search),
          DropdownButton(
            value: "All",
            items: ["All", "To-Do", "In Progress", "Done"]
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => p.filter(v!),
          ),
          Expanded(
            child: p.isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView(
                    children:
                        p.tasks.map((t) => TaskCard(task: t)).toList(),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await Navigator.push(
              context, MaterialPageRoute(builder: (_) => TaskFormScreen()));
          if (res == true) p.fetchTasks();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}