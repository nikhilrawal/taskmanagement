import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskmanager/domain/entities/task.dart';

class FirestoreTaskDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTask(Task task) async {
    await _firestore.collection('tasks').doc(task.id).set({
      'title': task.title,
      'description': task.description,
      'dueDate': task.dueDate.toIso8601String(),
      'priority': task.priority,
      'isCompleted': task.isCompleted,
    });
  }

  Future<void> updateTask(Task task) async {
    await _firestore.collection('tasks').doc(task.id).update({
      'title': task.title,
      'description': task.description,
      'dueDate': task.dueDate.toIso8601String(),
      'priority': task.priority,
      'isCompleted': task.isCompleted,
    });
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }

  Future<List<Task>> getTasks() async {
    final querySnapshot = await _firestore.collection('tasks').get();
    return querySnapshot.docs.map((doc) {
      return Task(
        id: doc.id,
        title: doc['title'],
        description: doc['description'],
        dueDate: DateTime.parse(doc['dueDate']),
        priority: doc['priority'],
        isCompleted: doc['isCompleted'],
      );
    }).toList();
  }
}
