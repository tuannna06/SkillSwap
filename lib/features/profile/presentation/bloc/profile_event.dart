import 'package:equatable/equatable.dart';

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
