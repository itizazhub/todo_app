import 'package:flutter/material.dart';
import 'package:todo_app/features/todos/domain/entities/task.dart';
import 'package:uuid/uuid.dart';

class TaskModel {
  String id;
  String title;
  String description;
  bool status;

  // Constructor
  TaskModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.status});

  // Named constructor for creating an instance from JSON
  TaskModel.fromJson(String key, Map<String, dynamic> json)
      : id = key,
        title = json["title"],
        description = json["description"],
        status = json["status"];

  // Named constructor to create a TaskModel from a Task entity
  TaskModel.fromEntity(Task task)
      : id = task.id,
        title = task.title,
        description = task.description,
        status = task.status;

  // Method to convert the TaskModel instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "status": status,
    };
  }

  // Method to convert the TaskModel instance to a Task entity
  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      status: status,
    );
  }
}
