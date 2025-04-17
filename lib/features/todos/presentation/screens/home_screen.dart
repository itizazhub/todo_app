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
  final Set<String> _updatingTaskIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });

    await ref.read(taskListNotifierProvider.notifier).loadTasks();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _addTask() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                  final task = Task(
                    id: const Uuid().v4(),
                    title: title,
                    description: description,
                    status: false,
                  );
                  ref.read(taskListNotifierProvider.notifier).addNewTask(task);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add Task"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateTask(Task task) async {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);

    await showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
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
                  final updatedTask = Task(
                    id: task.id,
                    title: title,
                    description: description,
                    status: task.status,
                  );
                  ref
                      .read(taskListNotifierProvider.notifier)
                      .updateTask(updatedTask);
                  Navigator.pop(context);
                }
              },
              child: const Text("Update Task"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTask(String id) async {
    ref.read(taskListNotifierProvider.notifier).deleteTask(id);
  }

  Future<void> _toggleTaskStatus(Task task) async {
    setState(() {
      _updatingTaskIds.add(task.id);
    });

    await ref.read(taskListNotifierProvider.notifier).updateTaskStatus(
          task.copyWith(status: !task.status),
        );

    setState(() {
      _updatingTaskIds.remove(task.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("To Do App",
            style:
                GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            onPressed: _addTask,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Tasks",
                    style: GoogleFonts.outfit(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  child: tasks.isEmpty
                      ? const Center(child: Text("No tasks available"))
                      : ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return ListTile(
                              leading: const Icon(Icons.task_alt),
                              title: Text(
                                task.title,
                                style: GoogleFonts.outfit(
                                    fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                              subtitle: Text(
                                task.description,
                                style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed:
                                        _updatingTaskIds.contains(task.id)
                                            ? null
                                            : () => _toggleTaskStatus(task),
                                    child: _updatingTaskIds.contains(task.id)
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            task.status
                                                ? "Completed"
                                                : "Pending...",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal,
                                              color: task.status
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          ),
                                  ),
                                  InkWell(
                                    onTap: () => _updateTask(task),
                                    child: const Icon(Icons.edit),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () => _deleteTask(task.id),
                                    child: const Icon(Icons.delete),
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
