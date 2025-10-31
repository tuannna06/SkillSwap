import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    super.name,
    super.email,
    super.phone,
    super.address,
    super.offeredSkills = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'offeredSkills': offeredSkills,
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
    );
  }
}
