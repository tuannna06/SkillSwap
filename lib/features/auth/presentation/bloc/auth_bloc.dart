
import 'package:cs222_final/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_event.dart';
import 'auth_state.dart';
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<SignInWithEmailRequested>(_onSignInWithEmailRequested);
    on<SignUpWithEmailRequested>(_onSignUpWithEmailRequested);
    on<SignInWithGoogleRequested>(_onSignInWithGoogleRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  Future<void> _createUserProfileIfNotExists(User user) async {
    try{
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      //create user profile if it does not exist
      if(!userDoc.exists){
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'phone' : null,
          'address' : null,
          'offeredSkills' : [],
        });
      }
    } catch (e) {
      // Handle errors
      print('Error creating user profile: $e');
    }
  }


  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit
  ) async {
    try{
      final user = repository.getCurrentUser();
      if (user != null){
        await _createUserProfileIfNotExists(user);
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    }catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  Future<void> _onSignInWithEmailRequested(
    SignInWithEmailRequested event,
    Emitter<AuthState> emit
  ) async {
    emit(AuthLoading());
    try{
      final user = await repository.signInWithEmailPassword(event.email, event.password);
      if (user != null){
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  Future<void> _onSignUpWithEmailRequested(
    SignUpWithEmailRequested event,
    Emitter<AuthState> emit
  ) async {
    emit(AuthLoading());
    try{
      final user = await repository.signUpWithEmailPassword(event.email, event.password);
      if (user != null){
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  Future<void> _onSignInWithGoogleRequested(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit
  ) async {
    emit(AuthLoading());
    try{
      final user = await repository.signInWithGoogle();
      if (user != null){
        await _createUserProfileIfNotExists(user);
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit
  ) async {
    emit(AuthLoading());
    try{
      await repository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
  