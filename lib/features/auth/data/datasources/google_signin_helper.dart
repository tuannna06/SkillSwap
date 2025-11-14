import 'package:firebase_auth/firebase_auth.dart';

// Conditional import: use web implementation on web, IO (mobile/desktop) otherwise
import 'google_signin_helper_io.dart'
    if (dart.library.html) 'google_signin_helper_web.dart' as impl;

Future<User?> signInWithGooglePlatform(FirebaseAuth auth) =>
    impl.signInWithGooglePlatform(auth);

Future<void> signOutGooglePlatform() => impl.signOutGooglePlatform();
