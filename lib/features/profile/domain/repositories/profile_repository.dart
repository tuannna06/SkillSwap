import '../entities/user_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity?> getUserProfile(String userId);
  Future<void> reloadUserProfile(String userId);
  Stream<UserEntity?> getUserProfileStream(String userId);
  Future<void> createUser(String userId, UserEntity user);
  Future<void> updateUser(String userId, Map<String, dynamic> updates);
  Future<void> deleteUser(String userId);
}
