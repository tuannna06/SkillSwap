import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final List<String> offeredSkills;

  const UserEntity({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.offeredSkills = const [],
  });

  @override
  List<Object?> get props => [id, name, email, phone, address, offeredSkills];
}
