import 'package:hive/hive.dart';
import 'package:taskmanager/data/datasources/firestore_task_datasource.dart';
import 'package:taskmanager/domain/entities/task.dart';
import 'package:taskmanager/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FirestoreTaskDataSource firestoreDataSource;
  final Box<Task> taskBox;

  TaskRepositoryImpl(this.firestoreDataSource, this.taskBox);

  @override
  Future<void> addTask(Task task) async {
    // Save to Hive
    await taskBox.put(task.id, task);

    // Optionally sync with Firestore
    await firestoreDataSource.addTask(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    // Update in Hive
    await taskBox.put(task.id, task);

    // Optionally sync with Firestore
    await firestoreDataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    // Remove from Hive
    await taskBox.delete(taskId);

    // Optionally sync with Firestore
    await firestoreDataSource.deleteTask(taskId);
  }

  @override
  Future<List<Task>> getTasks() async {
    // Fetch tasks from Hive
    List<Task> tasks = taskBox.values.cast<Task>().toList();

    // If Hive is empty, fetch from Firestore and save to Hive
    if (tasks.isEmpty) {
      tasks = await firestoreDataSource.getTasks();
      for (var task in tasks) {
        taskBox.put(task.id, task);
      }
    }
    return tasks;
  }
}
