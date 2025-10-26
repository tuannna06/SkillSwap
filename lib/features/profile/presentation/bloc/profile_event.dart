import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {
  final String userId;

  ProfileLoadRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ProfileReloadRequested extends ProfileEvent {
  final String userId;

  ProfileReloadRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ProfileRetryRequested extends ProfileEvent {
  final String userId;

  ProfileRetryRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreateUserRequested extends ProfileEvent {
  final UserEntity user;

  CreateUserRequested(this.user);

  @override
  List<Object?> get props => [user];
}

class UpdateUserRequested extends ProfileEvent {
  final String userId;
  final Map<String, dynamic> updates;

  UpdateUserRequested(this.userId, this.updates);

  @override
  List<Object?> get props => [userId, updates];
}

class DeleteUserRequested extends ProfileEvent {
  final String userId;

  DeleteUserRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}
