import 'package:berichtverwaltung_flutter/add/task_provider.dart';
import 'package:berichtverwaltung_flutter/services/firestore_service.dart';
import 'package:berichtverwaltung_flutter/widgets/flyout_nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TextEditingController taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Neuer Task"),
                content: TextFormField(
                  controller: taskController,
                  decoration: const InputDecoration(
                    hintText: "Task",
                  ),
                ),
                actions: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                    ),
                    child: const Text(
                      "Cancel",
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      FirestoreService().addTask(taskController.text);
                      taskController.text = "";
                      //state.
                    },
                    child: const Text("Hinzufügen"),
                  ),
                ],
              );
            },
          );
        },
        label: const Text("Neu"),
        icon: const Icon(Icons.edit_outlined),
      ),
      body: Column(
        children: [
          const Text("Hier kannst du wiederkehrende Aufgaben hinzufügen!"),
          Expanded(
            child: StreamBuilder(
              stream: FirestoreService().taskStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final tasks = snapshot.data ?? [];

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        background: Container(
                          color: Colors.redAccent,
                          child: const Icon(Icons.delete),
                        ),
                        onDismissed: (direction) async {
                          FirestoreService().removeTask(tasks[index]);
                        },
                        key: Key(index.toString()),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  tasks[index],
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Checkbox(
                              onChanged: (value) {
                                state.onTaskSelected(tasks[index]);
                              },
                              value: state.selectedTasks.contains(tasks[index]),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
