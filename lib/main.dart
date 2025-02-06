import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/core/services/service_locator.dart';
import 'package:taskmanager/core/services/shared_preferences_service.dart';
import 'package:taskmanager/firebase_options.dart';
import 'package:taskmanager/presentation/bloc/auth/auth_bloc.dart';
import 'package:taskmanager/presentation/bloc/auth/auth_event.dart';
import 'package:taskmanager/presentation/bloc/task/task_bloc.dart';
import 'package:taskmanager/presentation/bloc/task/task_event.dart';
import 'package:taskmanager/presentation/pages/home_page.dart';
import 'package:taskmanager/presentation/pages/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await init(); // Initialize Service Locator

  final sharedPreferencesService = GetIt.instance<SharedPreferencesService>();
  bool isLoggedIn = await sharedPreferencesService.isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AuthCheckStatusEvent()),
        ),
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc()..add(FetchTasksEvent()),
        ),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        title: 'Task Management App',
        theme: ThemeData(
          fontFamily: 'Satoshi', // Set globally for all text
          textTheme: TextTheme(
            headlineLarge: TextStyle(
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            bodyLarge: TextStyle(
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
            labelLarge: TextStyle(
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        home: isLoggedIn ? HomePage() : OnboardingPage(),
      ),
    );
  }
}
