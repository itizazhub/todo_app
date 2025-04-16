import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/features/todos/data/datasources/task_firebase_datasource.dart';
import 'package:todo_app/features/todos/data/repository/task_repository_impl.dart';
import 'package:todo_app/features/todos/domain/entities/task.dart';
import 'package:todo_app/features/todos/domain/usecases/add_task.dart';
import 'package:todo_app/features/todos/domain/usecases/delete_task.dart';
import 'package:todo_app/features/todos/domain/usecases/get_tasks.dart';
import 'package:todo_app/features/todos/domain/usecases/update_task.dart';
import 'package:todo_app/features/todos/domain/usecases/update_task_status.dart';

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
final addTaskProvider = Provider<AddTask>((ref) {
  return AddTask(repository: ref.read(taskRepositoryProvider));
});

final deleteTaskProvider = Provider<DeleteTask>((ref) {
  return DeleteTask(repository: ref.read(taskRepositoryProvider));
});
final updateTaskProvider = Provider<UpdateTask>((ref) {
  return UpdateTask(repository: ref.read(taskRepositoryProvider));
});

final updateTaskStatusProvider = Provider<UpdateTaskStatus>((ref) {
  return UpdateTaskStatus(repository: ref.read(taskRepositoryProvider));
});

// StateNotifierProvider for managing tasks state
final taskListNotifierProvider =
    StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  final getTasks = ref.read(getTasksProvider);
  final addTask = ref.read(addTaskProvider);
  final deleteTask = ref.read(deleteTaskProvider);
  final updateTask = ref.read(updateTaskProvider);
  final updateTaskStatus = ref.read(updateTaskStatusProvider);
  return TaskListNotifier(
      getTasks, addTask, deleteTask, updateTask, updateTaskStatus);
});

// TaskListNotifier to manage task states (loading, adding tasks)
class TaskListNotifier extends StateNotifier<List<Task>> {
  TaskListNotifier(this._getTasks, this._addTask, this._deleteTask,
      this._updateTask, this._updateTaskStatus)
      : super([]);

  final GetTasks _getTasks;
  final AddTask _addTask;
  final DeleteTask _deleteTask;
  final UpdateTask _updateTask;
  final UpdateTaskStatus _updateTaskStatus;

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

  Future<void> deleteTask(String id) async {
    await _deleteTask(id);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _updateTask(task);
    await loadTasks();
  }

  Future<void> updateTaskStatus(Task task) async {
    // state = [
    //   for (final t in state)
    //     if (t.id == task.id) task else t,
    // ];

    await _updateTaskStatus(task);
    await loadTasks();
  }
}
