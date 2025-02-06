import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/domain/usecases/auth/login.dart';
import 'package:taskmanager/domain/usecases/auth/register.dart';
import 'package:taskmanager/domain/usecases/auth/logout.dart';
import 'package:taskmanager/presentation/bloc/auth/auth_event.dart';
import 'package:taskmanager/presentation/bloc/auth/auth_state.dart';
import 'package:get_it/get_it.dart';
import 'package:taskmanager/core/services/shared_preferences_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login = GetIt.instance<Login>();
  final Register register = GetIt.instance<Register>();
  final Logout logout = GetIt.instance<Logout>();
  final SharedPreferencesService sharedPreferencesService =
      GetIt.instance<SharedPreferencesService>();

  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await login(event.email, event.password);

        // Save login status
        await sharedPreferencesService.setLoggedIn(true);
        await sharedPreferencesService.setUserId(user.id);

        emit(AuthAuthenticated(user: user));
      } catch (_) {
        emit(AuthError("Login failed"));
      }
    });

    on<AuthRegisterEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await register(event.email, event.password);

        // Save login status
        await sharedPreferencesService.setLoggedIn(true);
        await sharedPreferencesService.setUserId(user.id);

        emit(AuthAuthenticated(user: user));
      } catch (_) {
        emit(AuthError("Registration failed"));
      }
    });

    on<AuthLogoutEvent>((event, emit) async {
      try {
        await logout();

        // Clear login status
        await sharedPreferencesService.setLoggedIn(false);
        await sharedPreferencesService.clear();

        emit(AuthUnauthenticated());
      } catch (_) {
        emit(AuthError("Logout failed"));
      }
    });

    on<AuthCheckStatusEvent>((event, emit) async {
      bool isLoggedIn = await sharedPreferencesService.isLoggedIn();
      emit(AuthStatusChecked(isLoggedIn));
    });
  }
}
