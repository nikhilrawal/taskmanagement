import 'package:taskmanager/domain/entities/task.dart';
import 'package:taskmanager/domain/repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Future<List<Task>> call() async {
    return repository.getTasks();
  }
}
