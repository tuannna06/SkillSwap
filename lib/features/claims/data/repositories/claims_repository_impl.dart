import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs222_final/features/claims/data/models/claim_model.dart';
import 'package:cs222_final/features/claims/domain/entities/claim_entity.dart';
import 'package:cs222_final/features/claims/domain/repositories/claims_repository.dart';

class ClaimsRepositoryImpl implements ClaimsRepository {
  final FirebaseFirestore _firestore;

  ClaimsRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _claimsCollection =>
      _firestore.collection('claims');

  @override
  Future<void> createClaim(ClaimEntity claim) async {
    final claimModel = ClaimModel.fromEntity(claim);
    await _claimsCollection.doc(claim.id).set(claimModel.toMap());
  }

  @override
  Future<bool> hasUserClaimedPost(String userId, String postId) async {
    final query = await _claimsCollection
        .where('claimerId', isEqualTo: userId)
        .where('postId', isEqualTo: postId)
        .limit(1)
        .get();
    return query.docs.isNotEmpty;
  }

  @override
  Stream<List<ClaimEntity>> getClaimsForPost(String postId) {
    return _claimsCollection
        .where('postId', isEqualTo: postId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ClaimModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Stream<List<ClaimEntity>> getClaimsByUser(String userId) {
    return _claimsCollection
        .where('claimerId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ClaimModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Stream<List<ClaimEntity>> getClaimsForAuthor(String authorId) {
    return _claimsCollection
        .where('postAuthorId', isEqualTo: authorId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ClaimModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Future<void> updateClaimStatus(String claimId, ClaimStatus status) async {
    await _claimsCollection.doc(claimId).update({'status': status.name});
  }

  @override
  Future<void> deleteClaim(String claimId) async {
    await _claimsCollection.doc(claimId).delete();
  }
}
