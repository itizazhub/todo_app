import 'package:todo_app/features/todos/domain/entities/task.dart';
import 'package:todo_app/features/todos/domain/repositories/task_repository.dart';

class UpdateTask {
  UpdateTask({required this.repository});
  final TaskRepository repository;

  Future<void> call(Task task) {
    return repository.updateTask(task);
  }
}
