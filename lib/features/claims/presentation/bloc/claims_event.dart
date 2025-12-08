import 'package:equatable/equatable.dart';
import 'package:cs222_final/features/claims/domain/entities/claim_entity.dart';

abstract class ClaimsEvent extends Equatable {
  const ClaimsEvent();

  @override
  List<Object?> get props => [];
}

class CreateClaim extends ClaimsEvent {
  final ClaimEntity claim;

  const CreateClaim(this.claim);

  @override
  List<Object?> get props => [claim];
}

class LoadClaimsForAuthor extends ClaimsEvent {
  final String authorId;

  const LoadClaimsForAuthor(this.authorId);

  @override
  List<Object?> get props => [authorId];
}

class LoadClaimsByUser extends ClaimsEvent {
  final String userId;

  const LoadClaimsByUser(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CheckIfUserClaimedPost extends ClaimsEvent {
  final String userId;
  final String postId;

  const CheckIfUserClaimedPost({required this.userId, required this.postId});

  @override
  List<Object?> get props => [userId, postId];
}

class UpdateClaimStatus extends ClaimsEvent {
  final String claimId;
  final ClaimStatus status;

  const UpdateClaimStatus({required this.claimId, required this.status});

  @override
  List<Object?> get props => [claimId, status];
}

class DeleteClaim extends ClaimsEvent {
  final String claimId;

  const DeleteClaim(this.claimId);

  @override
  List<Object?> get props => [claimId];
}

class LoadClaimsForPost extends ClaimsEvent {
  final String postId;

  const LoadClaimsForPost(this.postId);

  @override
  List<Object?> get props => [postId];
}