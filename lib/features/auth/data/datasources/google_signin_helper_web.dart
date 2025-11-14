import 'package:firebase_auth/firebase_auth.dart';

Future<User?> signInWithGooglePlatform(FirebaseAuth auth) async {
  final provider = GoogleAuthProvider()
    ..setCustomParameters({'prompt': 'select_account'});
  final userCredential = await auth.signInWithPopup(provider);
  return userCredential.user;
}

Future<void> signOutGooglePlatform() async {
  // No additional provider sign-out required on web for Firebase Auth popup flow
}
