import 'package:equatable/equatable.dart';


abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class SignInWithEmailRequested extends AuthEvent {
  final String email;
  final String password;

  SignInWithEmailRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignUpWithEmailRequested extends AuthEvent {
  final String email;
  final String password;

  SignUpWithEmailRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignInWithGoogleRequested extends AuthEvent {}
class SignOutRequested extends AuthEvent {}