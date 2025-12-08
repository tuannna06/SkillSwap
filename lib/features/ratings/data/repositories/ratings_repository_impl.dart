import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/rating_entity.dart';
import '../../domain/repositories/ratings_repository.dart';
import '../models/rating_model.dart';

class RatingsRepositoryImpl implements RatingsRepository {
  final CollectionReference _ratingsCollection =
      FirebaseFirestore.instance.collection('ratings');
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  Future<void> submitRating(RatingEntity rating) async {
    final ratingModel = RatingModel.fromEntity(rating);
    
    // 1. Save/update the rating document
    await _ratingsCollection.doc(rating.id).set(ratingModel.toMap());

    // 2. Recalculate user's average rating
    final allRatings = await _ratingsCollection
        .where('ratedUserId', isEqualTo: rating.ratedUserId)
        .get();

    final total = allRatings.docs.fold<int>(
      0,
      (acc, doc) => acc + (doc['rating'] as int),
    );
    final average = allRatings.docs.isEmpty ? 0.0 : total / allRatings.docs.length;

    // 3. Update user document with new average
    await _usersCollection.doc(rating.ratedUserId).update({
      'averageRating': average,
      'totalRatingsCount': allRatings.docs.length,
    });
  }

  @override
  Future<RatingEntity?> getUserRatingForUser(String raterId, String ratedUserId) async {
    final docId = '${raterId}_$ratedUserId';
    final doc = await _ratingsCollection.doc(docId).get();
    
    if (!doc.exists) {
      return null;
    }
    
    return RatingModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  @override
  Stream<List<RatingEntity>> getRatingsForUser(String userId) {
    return _ratingsCollection
        .where('ratedUserId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RatingModel.fromMap(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }
}
