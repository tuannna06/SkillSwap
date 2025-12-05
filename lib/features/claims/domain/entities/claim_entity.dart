import 'package:equatable/equatable.dart';

enum ClaimStatus { pending, accepted, rejected }

class ClaimEntity extends Equatable {
  final String id;
  final String postId;
  final String postTitle;
  final String claimerId;
  final String claimerName;
  final String postAuthorId;
  final DateTime timestamp;
  final ClaimStatus status;

  const ClaimEntity({
    required this.id,
    required this.postId,
    required this.postTitle,
    required this.claimerId,
    required this.claimerName,
    required this.postAuthorId,
    required this.timestamp,
    this.status = ClaimStatus.pending,
  });

  @override
  List<Object?> get props => [
        id,
        postId,
        postTitle,
        claimerId,
        claimerName,
        postAuthorId,
        timestamp,
        status,
      ];
}
