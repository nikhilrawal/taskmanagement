import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/domain/entities/task.dart';
import 'package:taskmanager/domain/usecases/task/add_task.dart';
import 'package:taskmanager/domain/usecases/task/delete_task.dart';
import 'package:taskmanager/domain/usecases/task/get_tasks.dart';
import 'package:taskmanager/domain/usecases/task/update_task.dart';
import 'package:taskmanager/presentation/bloc/task/task_event.dart';
import 'package:taskmanager/presentation/bloc/task/task_state.dart';
import 'package:get_it/get_it.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks = GetIt.instance<GetTasks>();
  final AddTask addTask = GetIt.instance<AddTask>();
  final UpdateTask updateTask = GetIt.instance<UpdateTask>();
  final DeleteTask deleteTask = GetIt.instance<DeleteTask>();

  TaskBloc() : super(TaskInitial()) {
    on<FetchTasksEvent>((event, emit) async {
      emit(TaskLoading());
      try {
        List<Task> tasks = await getTasks();
        tasks.sort(
            (a, b) => a.dueDate.compareTo(b.dueDate)); // Sort tasks by due date
        emit(TaskLoaded(tasks));
      } catch (_) {
        emit(TaskError("Failed to load tasks"));
      }
    });

    on<SearchTasksEvent>((event, emit) async {
      if (state is TaskLoaded) {
        List<Task> tasks = (state as TaskLoaded).tasks;
        if (event.searchQuery.isEmpty) {
          tasks.sort((a, b) =>
              a.dueDate.compareTo(b.dueDate)); // Sort tasks by due date
          emit(TaskLoaded(tasks));
        } else {
          final filteredTasks = tasks.where((task) {
            return task.title
                .toLowerCase()
                .contains(event.searchQuery.toLowerCase());
          }).toList();
          emit(TaskLoaded(filteredTasks));
        }
      }
    });

    on<CreateTaskEvent>((event, emit) async {
      try {
        await addTask(event.task);
        add(FetchTasksEvent()); // Fetch updated tasks after adding
      } catch (_) {
        emit(TaskError("Failed to add task"));
      }
    });

    on<EditTaskEvent>((event, emit) async {
      try {
        await updateTask(event.task);
        add(FetchTasksEvent()); // Fetch updated tasks after editing
      } catch (_) {
        emit(TaskError("Failed to update task"));
      }
    });

    on<DeleteTaskEvent>((event, emit) async {
      try {
        await deleteTask(event.taskId);
        add(FetchTasksEvent()); // Fetch updated tasks after deleting
      } catch (_) {
        emit(TaskError("Failed to delete task"));
      }
    });

    on<SortTasksEvent>((event, emit) async {
      if (state is TaskLoaded) {
        List<Task> tasks = List.from((state as TaskLoaded).tasks);
        tasks
            .sort((a, b) => a.dueDate.compareTo(b.dueDate)); // Sort by due date
        emit(TaskLoaded(tasks));
      }
    });
  }
}
