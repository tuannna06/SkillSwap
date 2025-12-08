import 'package:equatable/equatable.dart';

class RatingEntity extends Equatable {
  final String id;
  final String raterId;
  final String ratedUserId;
  final int rating;
  final DateTime timestamp;

  const RatingEntity({
    required this.id,
    required this.raterId,
    required this.ratedUserId,
    required this.rating,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, raterId, ratedUserId, rating, timestamp];
}
