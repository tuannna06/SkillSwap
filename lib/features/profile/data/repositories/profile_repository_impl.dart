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
      final userData = await remoteDatasource.getUserData(userId);
      return UserModel.fromMap(userData);
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
        .map((userData) {
          return UserModel.fromMap(userData);
        })
        .handleError((error) {
          // print('Error streaming user profile: $error');
        });
  }

  @override
  Future<void> createUser(String userId, UserEntity user) async {
    final userModel = UserModel.fromMap((user as dynamic).toMap());
    final userData = userModel.toMap();

    await remoteDatasource.createUser(userId, userData);
  }

  @override
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    await remoteDatasource.updateUser(userId, updates);
  }

  @override
  Future<void> deleteUser(String userId) async {
    await remoteDatasource.deleteUser(userId);
  }
}
