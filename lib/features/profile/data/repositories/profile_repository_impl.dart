import 'package:cs222_final/features/profile/data/models/user_model.dart';

import '../../domain/entities/user_entity.dart';
import '../datasources/profile_remote_datasource.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;

  ProfileRepositoryImpl(this.remoteDatasource);

  @override
  Future<UserEntity?> getUserProfile(String userId) async {
    try {
      final userDoc = await remoteDatasource.getUserData(userId);
      return UserModel.fromMap(userDoc.data() as Map<String, dynamic>, userDoc.id);
    } catch (e) {
      // print('Error fetching user profile: $e');
      return null;
    }
  }

  @override
  Future<void> reloadUserProfile(String userId) async {
    try {
      //TODO: implement reload user profile
      //final userData = await remoteDatasource.getUserData(userId);
    } catch (e) {
      // print('Error reloading user profile: $e');
    }
  }

  @override
  Stream<UserEntity?> getUserProfileStream(String userId) {
    return remoteDatasource
        .getUserProfileStream(userId)
        .map((userDoc) {
          return UserModel.fromMap(userDoc.data() as Map<String, dynamic>, userDoc.id);
        })
        .handleError((error) {
          // print('Error streaming user profile: $error');
        });
  }
}
