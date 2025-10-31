import 'package:cs222_final/features/auth/domain/repositories/auth_repository.dart';
import 'package:cs222_final/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Stream<User?> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  Future<User?> signInWithEmailPassword(String email, String password){
    return _remoteDataSource.signInWithEmailPassword(email, password);
  }
  @override
  Future<User?> signUpWithEmailPassword(String email, String password){
    return _remoteDataSource.signUpWithEmailPassword(email, password);
  }
  @override
  Future<User?> signInWithGoogle(){
    return _remoteDataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut(){
    return _remoteDataSource.signOut();
  }
  @override
  User? getCurrentUser(){
    return _remoteDataSource.getCurrentUser();
  }
}