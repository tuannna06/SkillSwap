import '../entities/user_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity?> getUserProfile(String userId);
  Future<void> reloadUserProfile(String userId);
  Stream<UserEntity?> getUserProfileStream(String userId);
}
