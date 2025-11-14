import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'google_signin_helper.dart' as google_helper;

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<User?> signInWithEmailPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<User?> signUpWithEmailPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<User?> signInWithGoogle() async {
    return google_helper.signInWithGooglePlatform(_firebaseAuth);
  }

  Future<void> signOut() async {
    // Try to sign out of both Firebase and GoogleSignIn gracefully
    await Future.wait([
      _firebaseAuth.signOut(),
      google_helper.signOutGooglePlatform(),
    ]);
  }

  User? getCurrentUser() => _firebaseAuth.currentUser;
}
