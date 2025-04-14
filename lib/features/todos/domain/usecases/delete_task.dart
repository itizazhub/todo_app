import 'package:todo_app/features/todos/domain/repositories/task_repository.dart';

class DeleteTask {
  DeleteTask({required this.repository});
  final TaskRepository repository;
  Future<void> call(String id) {
    return repository.deleteTask(id);
  }
}
