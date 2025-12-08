import 'package:equatable/equatable.dart';

abstract class RatingsState extends Equatable {
  const RatingsState();

  @override
  List<Object?> get props => [];
}

class RatingsInitial extends RatingsState {}

class RatingLoading extends RatingsState {}

class RatingSubmitting extends RatingsState {}

class RatingSubmitted extends RatingsState {}

class UserRatingLoaded extends RatingsState {
  final String ratedUserId;
  final int? existingRating;

  const UserRatingLoaded({required this.ratedUserId, this.existingRating});

  @override
  List<Object?> get props => [ratedUserId, existingRating];
}

class RatingsError extends RatingsState {
  final String message;

  const RatingsError(this.message);

  @override
  List<Object?> get props => [message];
}
