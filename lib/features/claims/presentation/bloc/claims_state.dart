import 'package:equatable/equatable.dart';
import 'package:cs222_final/features/claims/domain/entities/claim_entity.dart';

abstract class ClaimsState extends Equatable {
  const ClaimsState();

  @override
  List<Object?> get props => [];
}

class ClaimsInitial extends ClaimsState {}

class ClaimsLoading extends ClaimsState {}

class ClaimsLoaded extends ClaimsState {
  final List<ClaimEntity> claims;

  const ClaimsLoaded(this.claims);

  @override
  List<Object?> get props => [claims];
}

class ClaimCreated extends ClaimsState {}

class ClaimCreating extends ClaimsState {}

class ClaimStatusUpdated extends ClaimsState {}

class ClaimDeleted extends ClaimsState {}

class ClaimsError extends ClaimsState {
  final String message;

  const ClaimsError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserClaimStatus extends ClaimsState {
  final String postId;
  final bool hasClaimed;

  const UserClaimStatus({required this.postId, required this.hasClaimed});

  @override
  List<Object?> get props => [postId, hasClaimed];
}
