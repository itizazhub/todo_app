import 'package:todo_app/features/todos/domain/entities/task.dart';
import 'package:todo_app/features/todos/domain/repositories/task_repository.dart';

class GetTasks {
  GetTasks({required this.repository});
  final TaskRepository repository;

  Future<List<Task>> call() {
    return repository.getTasks();
  }
}
