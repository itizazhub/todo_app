import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/features/todos/presentation/providers/task_provider.dart';
import 'package:todo_app/features/todos/domain/entities/task.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _taskStatus = false;

  @override
  void initState() {
    super.initState();
    // Load tasks only once when the screen is first initialized
    ref.read(taskListNotifierProvider.notifier).loadTasks();
  }

  Future<void> _addTask() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        // Create a TextEditingController to handle user input
        final TextEditingController titleController = TextEditingController();
        final TextEditingController descriptionController =
            TextEditingController();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Task Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Task Description",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text;
                  final description = descriptionController.text;

                  if (title.isNotEmpty && description.isNotEmpty) {
                    // Call the function to add the task
                    final task = Task(
                        status: false,
                        id: const Uuid().v4(),
                        title: title,
                        description: description);
                    ref
                        .watch(taskListNotifierProvider.notifier)
                        .addNewTask(task);
                    Navigator.pop(
                        context); // Close the bottom sheet after adding
                  }
                },
                child: Text("Add Task"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteTask(String id) async {
    ref.watch(taskListNotifierProvider.notifier).deleteTask(id);
  }

  Future<void> _updateTask(Task task) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        // Create a TextEditingController to handle user input
        final TextEditingController titleController =
            TextEditingController(text: task.title);
        final TextEditingController descriptionController =
            TextEditingController(text: task.description);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Task Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Task Description",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text;
                  final description = descriptionController.text;

                  if (title.isNotEmpty && description.isNotEmpty) {
                    // Call the function to add the task

                    final updatedTask = Task(
                        status: task.status,
                        id: task.id,
                        title: title,
                        description: description);
                    ref
                        .watch(taskListNotifierProvider.notifier)
                        .updateTask(updatedTask);
                    Navigator.pop(
                        context); // Close the bottom sheet after adding
                  }
                },
                child: const Text("Update Task"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateTaskStatus(Task task) async {
    ref.watch(taskListNotifierProvider.notifier).updateTaskStatus(task);
  }

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = ref.watch(
        taskListNotifierProvider); // Make sure tasks is typed as List<Task>

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          "To Do App",
          style: GoogleFonts.outfit(fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await _addTask();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Tasks", style: TextStyle(fontSize: 18)),
          ),
          Expanded(
            child: tasks.isEmpty
                ? Center(child: Text("No tasks available"))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      var task = tasks[index];
                      return ListTile(
                        leading: const Icon(Icons.task_alt),
                        title: Text(
                            task.title), // Assuming task has a 'title' field
                        subtitle: Text(task
                            .description), // Assuming task has a 'description' field
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                                onPressed: () async {
                                  await _updateTaskStatus(Task(
                                      id: task.id,
                                      title: task.title,
                                      description: task.description,
                                      status: task.status ? false : true));
                                },
                                child: Text(
                                  task.status ? "completed" : "Pending...",
                                  style: TextStyle(
                                      color: task.status
                                          ? Colors.green
                                          : Colors.red),
                                )),
                            IconButton(
                              onPressed: () async {
                                await _updateTask(
                                    task); // Implement task editing functionality here
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () async {
                                await _deleteTask(task
                                    .id); // Implement task delete functionality here
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
