import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/features/todos/data/datasources/task_firebase_datasource.dart';
import 'package:todo_app/features/todos/data/repository/task_repository_impl.dart';
import 'package:todo_app/features/todos/domain/entities/task.dart';
import 'package:todo_app/features/todos/domain/usecases/add_task.dart';
import 'package:todo_app/features/todos/domain/usecases/get_tasks.dart';

final datasource = Provider<TaskFirebaseDatasource>((ref) {
  return TaskFirebaseDatasource();
});

// Provider for Task Repository
final taskRepositoryProvider = Provider<TaskRepositoryImpl>((ref) {
  return TaskRepositoryImpl(taskFirebaseDatasource: ref.read(datasource));
});

// Provider for GetTasks use case
final getTasksProvider = Provider<GetTasks>((ref) {
  return GetTasks(repository: ref.read(taskRepositoryProvider));
});

// Provider for AddTask use case
final addTasksProvider = Provider<AddTask>((ref) {
  return AddTask(repository: ref.read(taskRepositoryProvider));
});

// StateNotifierProvider for managing tasks state
final taskListNotifierProvider =
    StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  final getTasks = ref.read(getTasksProvider);
  final addTask = ref.read(addTasksProvider);
  return TaskListNotifier(getTasks, addTask);
});

// TaskListNotifier to manage task states (loading, adding tasks)
class TaskListNotifier extends StateNotifier<List<Task>> {
  TaskListNotifier(this._getTasks, this._addTask) : super([]);

  final GetTasks _getTasks;
  final AddTask _addTask;

  // Method to load tasks
  Future<void> loadTasks() async {
    print("taska are loading...");
    final tasks = await _getTasks(); // Fetch tasks using GetTasks use case
    state = tasks; // Update state with the fetched tasks
  }

  // Method to add a new task
  Future<void> addNewTask(Task task) async {
    await _addTask(task); // Add a new task using AddTask use case
    loadTasks(); // Optionally, reload tasks after adding
  }
}
