import 'package:taskmanager/domain/entities/task.dart';

// task_event.dart

abstract class TaskEvent {}

class FetchTasksEvent extends TaskEvent {}

class CreateTaskEvent extends TaskEvent {
  final Task task;
  CreateTaskEvent(this.task);
}
// In task_event.dart

class SearchTasksEvent extends TaskEvent {
  final String searchQuery;

  SearchTasksEvent(this.searchQuery);
}

class EditTaskEvent extends TaskEvent {
  final Task task;
  EditTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  DeleteTaskEvent(this.taskId);
}

class SortTasksEvent extends TaskEvent {} // New event for sorting

class FilterTasksEvent extends TaskEvent {
  final String priority;
  final String status;

  FilterTasksEvent({required this.priority, required this.status});
}
