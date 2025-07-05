import '../../tasks/models/task.dart';

class Request {
  final int id;
  final String description;
  final String requestStatus;
  final Task task;

  Request({
    required this.id,
    required this.description,
    required this.requestStatus,
    required this.task
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      description: json['description'],
      requestStatus: json['requestStatus'],
      task: Task.fromJson(json['task']),
    );
  }
}