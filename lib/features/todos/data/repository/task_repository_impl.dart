import 'package:todo_app/features/todos/data/datasources/task_firebase_datasource.dart';
import 'package:todo_app/features/todos/data/models/task_model.dart';
import 'package:todo_app/features/todos/domain/entities/task.dart';
import 'package:todo_app/features/todos/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskFirebaseDatasource taskFirebaseDatasource;

  TaskRepositoryImpl({required this.taskFirebaseDatasource});

  @override
  Future<void> addTask(Task task) async {
    taskFirebaseDatasource.addTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> deleteTask(String id) async {
    taskFirebaseDatasource.deleteTask(id);
  }

  @override
  Future<List<Task>> getTasks() async {
    print("taska are getting...");
    final List<TaskModel> tasks = await taskFirebaseDatasource.getTasks();
    return tasks.map((task) {
      return task.toEntity();
    }).toList();
  }

  @override
  Future<void> updateTask(Task task) async {
    taskFirebaseDatasource.updateTask(TaskModel.fromEntity(task));
  }
}
