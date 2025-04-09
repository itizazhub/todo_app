import 'dart:convert';

import 'package:todo_app/features/todos/data/models/task_model.dart';
import 'package:http/http.dart' as http;

class TaskFirebaseDatasource {
  // Fetching tasks from Firebase
  Future<List<TaskModel>> getTasks() async {
    final url =
        Uri.https("todo-app-ec71c-default-rtdb.firebaseio.com", "task.json");

    try {
      final response =
          await http.get(url, headers: {"Content-Type": "application/json"});

      // Correcting the status code check
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("Tasks fetched successfully ${response.statusCode}");

        // Decode the response body and map it to TaskModel
        Map<String, dynamic> result = jsonDecode(response.body);
        return result.entries.map((jsonTask) {
          return TaskModel.fromJson(jsonTask.value);
        }).toList();
      } else {
        print("Error happened ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Something bad happened $e");
      return [];
    }
  }

  // Adding a new task to Firebase
  Future<void> addTask(TaskModel task) async {
    final url =
        Uri.https("todo-app-ec71c-default-rtdb.firebaseio.com", "task.json");

    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "id": task.id,
            "title": task.title,
            "description": task.description,
            "status": task.status,
          }));

      // Correcting the status code check
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("Task added successfully ${response.statusCode}");
      } else {
        print("Error happened ${response.statusCode}");
      }
    } catch (e) {
      print("Something bad happened $e");
    }
  }

  // Deleting a task from Firebase
  Future<void> deleteTask(String id) async {
    // final url = Uri.https(
    //     "todo-app-ec71c-default-rtdb.firebaseio.com", "task/$id.json");

    // try {
    //   final response =
    //       await http.delete(url, headers: {"Content-Type": "application/json"});

    //   // Correcting the status code check
    //   if (response.statusCode >= 200 && response.statusCode < 300) {
    //     print("Task deleted successfully ${response.statusCode}");
    //   } else {
    //     print("Error happened ${response.statusCode}");
    //   }
    // } catch (e) {
    //   print("Something bad happened $e");
    // }
  }

  // Updating a task on Firebase
  Future<void> updateTask(String id, TaskModel task) async {
    //   final url = Uri.https(
    //       "todo-app-ec71c-default-rtdb.firebaseio.com", "task/$id.json");

    //   try {
    //     final response = await http.patch(url,
    //         headers: {"Content-Type": "application/json"},
    //         body: json.encode({
    //           "id": task.id,
    //           "title": task.title,
    //           "description": task.description,
    //           "status": task.status,
    //         }));

    //     // Correcting the status code check
    //     if (response.statusCode >= 200 && response.statusCode < 300) {
    //       print("Task updated successfully ${response.statusCode}");
    //     } else {
    //       print("Error happened ${response.statusCode}");
    //     }
    //   } catch (e) {
    //     print("Something bad happened $e");
    //   }
  }
}
