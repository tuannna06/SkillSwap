import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    super.name,
    super.email,
    super.phone,
    super.address,
    super.offeredSkills = const [],
    super.averageRating = 0.0,
    super.totalRatingsCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'offeredSkills': offeredSkills,
      'averageRating': averageRating,
      'totalRatingsCount': totalRatingsCount,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String docID) {
    return UserModel(
      id: docID,
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      offeredSkills: List<String>.from(map['offeredSkills'] ?? []),
      averageRating: (map['averageRating'] ?? 0.0).toDouble(),
      totalRatingsCount: map['totalRatingsCount'] ?? 0,
    );
  }
}
