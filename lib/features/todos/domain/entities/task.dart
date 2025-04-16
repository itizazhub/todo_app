class Task {
  Task(
      {required this.id,
      required this.title,
      required this.description,
      required this.status});
  String id;
  String title;
  String description;
  bool status;

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }
}
