import 'package:todo_app/features/todos/domain/entities/task.dart';
import 'package:todo_app/features/todos/domain/repositories/task_repository.dart';

class UpdateTaskStatus {
  UpdateTaskStatus({required this.repository});
  final TaskRepository repository;

  Future<void> call(Task task) {
    return repository.updateTaskStatus(task);
  }
}
