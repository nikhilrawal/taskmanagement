import 'package:taskmanager/domain/entities/user.dart';
import 'package:taskmanager/domain/repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<User> call(String email, String password) async {
    return repository.register(email, password);
  }
}
