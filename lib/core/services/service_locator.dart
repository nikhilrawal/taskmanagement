import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskmanager/core/services/shared_preferences_service.dart';
import 'package:taskmanager/data/datasources/firebase_auth_datasource.dart';
import 'package:taskmanager/data/datasources/firestore_task_datasource.dart';
import 'package:taskmanager/data/repositories/auth_repository_impl.dart';
import 'package:taskmanager/data/repositories/task_repository_impl.dart';
import 'package:taskmanager/domain/entities/task.dart';
import 'package:taskmanager/domain/repositories/auth_repository.dart';
import 'package:taskmanager/domain/repositories/task_repository.dart';
import 'package:taskmanager/domain/usecases/auth/login.dart';
import 'package:taskmanager/domain/usecases/auth/logout.dart';
import 'package:taskmanager/domain/usecases/auth/register.dart';
import 'package:taskmanager/domain/usecases/task/add_task.dart';
import 'package:taskmanager/domain/usecases/task/delete_task.dart';
import 'package:taskmanager/domain/usecases/task/get_tasks.dart';
import 'package:taskmanager/domain/usecases/task/update_task.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await Hive.initFlutter();

  Hive.registerAdapter(TaskAdapter());

  Box<Task> taskBox = await Hive.openBox<Task>('tasks');

  sl.registerLazySingleton<Box<Task>>(() => taskBox);
  // Data Sources

  sl.registerLazySingleton(() => FirebaseAuthDataSource());
  sl.registerLazySingleton(() => FirestoreTaskDataSource());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(sl(), sl()));

  // Use Cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => AddTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));
  sl.registerLazySingleton(() => GetTasks(sl()));

  // Services
  sl.registerLazySingleton(() => SharedPreferencesService());
}
