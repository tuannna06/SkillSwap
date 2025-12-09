import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/rating_entity.dart';

class RatingModel extends RatingEntity {
  const RatingModel({
    required super.id,
    required super.raterId,
    required super.ratedUserId,
    required super.rating,
    required super.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'raterId': raterId,
      'ratedUserId': ratedUserId,
      'rating': rating,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map, String docId) {
    return RatingModel(
      id: docId,
      raterId: map['raterId'] as String,
      ratedUserId: map['ratedUserId'] as String,
      rating: map['rating'] as int,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  factory RatingModel.fromEntity(RatingEntity entity) {
    return RatingModel(
      id: entity.id,
      raterId: entity.raterId,
      ratedUserId: entity.ratedUserId,
      rating: entity.rating,
      timestamp: entity.timestamp,
    );
  }
}
