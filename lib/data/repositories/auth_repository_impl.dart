import 'package:taskmanager/data/datasources/firebase_auth_datasource.dart';
import 'package:taskmanager/domain/repositories/auth_repository.dart';

import '../../domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<User> login(String email, String password) async {
    return dataSource.login(email, password);
  }

  @override
  Future<User> register(String email, String password) async {
    return dataSource.register(email, password);
  }

  @override
  Future<void> logout() async {
    return dataSource.logout();
  }
}
