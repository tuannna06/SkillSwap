//import 'package:cs222_final/features/profile/domain/entities/user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cs222_final/features/profile/domain/repositories/profile_repository.dart';
// import '../../domain/entities/user_entity.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<ProfileLoadRequested>(_onLoadRequested);
    on<ProfileReloadRequested>(_onReloadRequested);
    on<ProfileRetryRequested>(_onRetryRequested);
    // on<CreateUserRequested>(_onCreateUserRequested);
    on<UpdateUserRequested>(_onUpdateUserRequested);
    on<DeleteUserRequested>(_onDeleteUserRequested);
  }

  Future<void> _onLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final user = await repository.getUserProfile(event.userId);
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User Not Found"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onReloadRequested(
    ProfileReloadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final user = await repository.getUserProfile(event.userId);
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User Not Found"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onRetryRequested(
    ProfileRetryRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final user = await repository.getUserProfile(event.userId);
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User Not Found"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }


//   Future<void> _onCreateUserRequested(
//     CreateUserRequested event, Emitter<ProfileState> emit) async {
//   emit(ProfileLoading());
//   try {
//     await repository.createUser(event.user);

//     final newUser = await repository.getUserProfile(event.user.id);

//     emit(ProfileLoaded(newUser!));
//   } catch (e) {
//     emit(ProfileError('Failed to create user: $e'));
//   }
// }

  //update user handler
  Future<void> _onUpdateUserRequested(
      UpdateUserRequested event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await repository.updateUser(event.userId, event.updates);
      final updatedUser = await repository.getUserProfile(event.userId);
      emit(ProfileLoaded(updatedUser!));
    } catch (e) {
      emit(ProfileError('Failed to update user: $e'));
    }
  }

  //delete user handler
  Future<void> _onDeleteUserRequested(
      DeleteUserRequested event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      await repository.deleteUser(event.userId);
      emit(ProfileInitial());
    } catch (e) {
      emit(ProfileError('Failed to delete user: $e'));
    }
  }
}
