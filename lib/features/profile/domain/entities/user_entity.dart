import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final List<String> offeredSkills;
  final double averageRating;
  final int totalRatingsCount;

  const UserEntity({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.offeredSkills = const [],
    this.averageRating = 0.0,
    this.totalRatingsCount = 0,
  });

  @override
  List<Object?> get props => [id, name, email, phone, address, offeredSkills, averageRating, totalRatingsCount];
}
