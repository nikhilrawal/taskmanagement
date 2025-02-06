// login.dart
import 'package:taskmanager/domain/entities/user.dart';
import 'package:taskmanager/domain/repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<User> call(String email, String password) async {
    return repository.login(email, password);
  }
}
