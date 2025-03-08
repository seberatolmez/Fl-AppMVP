import 'package:takip_deneme/pages/todoscreen/model/tasktype.dart';

class Task {
  int? id;
  final String title;
  final String description;
  final TaskType type;
  bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.type,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      type: TaskType.values.firstWhere(
            (e) => e.toString() == map['type'],
      ),
      isCompleted: map['isCompleted'] == 1,
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    TaskType? type,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

}
