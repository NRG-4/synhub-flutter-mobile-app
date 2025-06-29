abstract class TaskEvent {}

class LoadMemberTasksEvent extends TaskEvent {}

class LoadTaskByIdEvent extends TaskEvent {
  final int taskId;

  LoadTaskByIdEvent(this.taskId);
}