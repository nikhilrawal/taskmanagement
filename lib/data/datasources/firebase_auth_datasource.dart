import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskmanager/domain/entities/user.dart' as UserClass;

class FirebaseAuthDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserClass.User> login(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserClass.User(
      id: userCredential.user!.uid,
      email: userCredential.user!.email!,
    );
  }

  Future<UserClass.User> register(String email, String password) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return UserClass.User(
      id: userCredential.user!.uid,
      email: userCredential.user!.email!,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
