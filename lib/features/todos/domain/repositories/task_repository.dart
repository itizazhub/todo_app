import 'package:todo_app/features/todos/domain/entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<void> addTask(Task task);
  void deleteTask(String id);
  void updateTask(String id, Task task);
}
