import 'package:cs222_final/features/claims/domain/entities/claim_entity.dart';

abstract class ClaimsRepository {
  /// Create a new claim for a post
  Future<void> createClaim(ClaimEntity claim);

  /// Check if a user has already claimed a specific post
  Future<bool> hasUserClaimedPost(String userId, String postId);

  /// Get all claims for a specific post (for post author to see)
  Stream<List<ClaimEntity>> getClaimsForPost(String postId);

  /// Get all claims made by a specific user
  Stream<List<ClaimEntity>> getClaimsByUser(String userId);

  /// Get all claims for posts authored by a specific user (notifications)
  Stream<List<ClaimEntity>> getClaimsForAuthor(String authorId);

  /// Update claim status (accept/reject)
  Future<void> updateClaimStatus(String claimId, ClaimStatus status);

  /// Delete a claim
  Future<void> deleteClaim(String claimId);
}
