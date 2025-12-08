import '../entities/rating_entity.dart';

abstract class RatingsRepository {
  Future<void> submitRating(RatingEntity rating);
  Future<RatingEntity?> getUserRatingForUser(String raterId, String ratedUserId);
  Stream<List<RatingEntity>> getRatingsForUser(String userId);
}
