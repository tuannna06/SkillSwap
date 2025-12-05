import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs222_final/features/claims/domain/entities/claim_entity.dart';

class ClaimModel extends ClaimEntity {
  const ClaimModel({
    required super.id,
    required super.postId,
    required super.postTitle,
    required super.claimerId,
    required super.claimerName,
    required super.postAuthorId,
    required super.timestamp,
    super.status,
  });

  factory ClaimModel.fromEntity(ClaimEntity entity) {
    return ClaimModel(
      id: entity.id,
      postId: entity.postId,
      postTitle: entity.postTitle,
      claimerId: entity.claimerId,
      claimerName: entity.claimerName,
      postAuthorId: entity.postAuthorId,
      timestamp: entity.timestamp,
      status: entity.status,
    );
  }

  factory ClaimModel.fromMap(Map<String, dynamic> map, String id) {
    return ClaimModel(
      id: id,
      postId: map['postId'] as String,
      postTitle: map['postTitle'] as String,
      claimerId: map['claimerId'] as String,
      claimerName: map['claimerName'] as String,
      postAuthorId: map['postAuthorId'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      status: ClaimStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ClaimStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'postTitle': postTitle,
      'claimerId': claimerId,
      'claimerName': claimerName,
      'postAuthorId': postAuthorId,
      'timestamp': Timestamp.fromDate(timestamp),
      'status': status.name,
    };
  }
}
