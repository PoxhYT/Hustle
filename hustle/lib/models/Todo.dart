class Todo {
  final String name;
  bool finished;

  Todo({required this.name, required this.finished});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      name: json['name'],
      finished: json['finished'],
    );
  }
}