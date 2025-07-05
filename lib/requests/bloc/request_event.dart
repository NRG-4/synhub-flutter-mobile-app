abstract class RequestEvent {}

class LoadMemberRequestsEvent extends RequestEvent {}

class LoadRequestByTaskIdEvent extends RequestEvent {
  final int taskId;
  LoadRequestByTaskIdEvent(this.taskId);
}