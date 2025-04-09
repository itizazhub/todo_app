import 'package:todo_app/features/todos/domain/entities/task.dart';
import 'package:todo_app/features/todos/domain/repositories/task_repository.dart';

class UpdateTask {
  UpdateTask({required this.repository});
  final TaskRepository repository;

  void call(String id, Task task) {
    return repository.updateTask(id, task);
  }
}
