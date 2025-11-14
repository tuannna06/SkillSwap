import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<User?> signInWithGooglePlatform(FirebaseAuth auth) async {
  // Use the API style already present in the codebase for compatibility
  final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final credential = GoogleAuthProvider.credential(
    idToken: googleAuth.idToken,
  );

  final userCredential = await auth.signInWithCredential(credential);
  return userCredential.user;
}

Future<void> signOutGooglePlatform() async {
  try {
    await GoogleSignIn.instance.signOut();
  } catch (_) {
    // Ignore platform-specific sign-out issues
  }
}
