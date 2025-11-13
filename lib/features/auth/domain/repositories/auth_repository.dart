import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;

  Future<User?> signInWithEmailPassword(String email, String password);
  Future<User?> signUpWithEmailPassword(String email, String password);
  Future<User?> signInWithGoogle();
  Future<void> signOut();
  User? getCurrentUser();
}
