import 'package:taskmanager/domain/entities/task.dart';

abstract class TaskRepository {
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
  Future<List<Task>> getTasks();
}
