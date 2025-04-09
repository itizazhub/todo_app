import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/features/todos/presentation/providers/task_provider.dart';
import 'package:todo_app/features/todos/domain/entities/task.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load tasks only once when the screen is first initialized
    // ref.read(taskListNotifierProvider.notifier).loadTasks();
  }

  void _addTask() {
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
                decoration: InputDecoration(
                  labelText: "Task Title",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: "Task Description",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text;
                  final description = descriptionController.text;

                  if (title.isNotEmpty && description.isNotEmpty) {
                    // Call the function to add the task
                    final task = Task(
                        status: false,
                        id: "1",
                        title: title,
                        description: description);
                    ref
                        .read(taskListNotifierProvider.notifier)
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
            onPressed: () {
              _addTask();
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
                            IconButton(
                              onPressed: () {
                                // Implement task editing functionality here
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                // Implement task delete functionality here
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
