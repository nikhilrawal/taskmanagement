// auth_state.dart
import 'package:equatable/equatable.dart';
import 'package:taskmanager/domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthStatusChecked extends AuthState {
  final bool isLoggedIn;

  const AuthStatusChecked(this.isLoggedIn);

  @override
  List<Object?> get props => [isLoggedIn];
}
