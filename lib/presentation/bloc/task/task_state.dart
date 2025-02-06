import 'package:taskmanager/domain/entities/task.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  TaskLoaded(this.tasks);
}

class TaskAdded extends TaskState {}

class TaskUpdated extends TaskState {}

class TaskDeleted extends TaskState {}

class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}
