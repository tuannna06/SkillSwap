import 'package:equatable/equatable.dart';

abstract class RatingsEvent extends Equatable {
  const RatingsEvent();

  @override
  List<Object?> get props => [];
}

class SubmitRating extends RatingsEvent {
  final String ratedUserId;
  final int rating;

  const SubmitRating({
    required this.ratedUserId,
    required this.rating,
  });

  @override
  List<Object?> get props => [ratedUserId, rating];
}

class LoadUserRating extends RatingsEvent {
  final String ratedUserId;

  const LoadUserRating(this.ratedUserId);

  @override
  List<Object?> get props => [ratedUserId];
}
