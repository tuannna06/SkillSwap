import 'package:cs222_final/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:cs222_final/features/posts/data/models/post_model.dart';
import 'package:cs222_final/features/posts/domain/entities/post_entity.dart';
import 'package:cs222_final/features/posts/domain/repositories/posts_repository.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource postsRemoteDataSource;

  PostsRepositoryImpl(this.postsRemoteDataSource);

  @override
  Stream<List<PostEntity>> getAllPosts() {
    final Stream<List<Map<String, dynamic>>> allPostsData =
        postsRemoteDataSource.getAllPostsData();

    //convert to list<entity>
    return allPostsData.map((listOfMaps) {
      final entities =
          listOfMaps.map((mapData) => PostModel.fromMap(mapData)).toList();

      return entities;
    });
  }

  @override
  Future<String> createPost(PostEntity post) {
    final postModel = PostModel.fromEntity(post);
    final postData = postModel.toMap();

    return postsRemoteDataSource.createPostData(postData);
  }

  @override
  Future<void> updatePost(String postId, Map<String, dynamic> updates) async {
    await postsRemoteDataSource.updatePostData(postId, updates);
  }

  @override
  Future<void> deletePost(String postId) async {
    await postsRemoteDataSource.deletePost(postId);
  }

  @override
  Stream<List<PostEntity>> getPostsByLocation(String location) {
    throw UnimplementedError("Location filtering is not yet implemented");
  }

  @override
  Stream<List<PostEntity>> getPostsByCategory(String category) {
    return postsRemoteDataSource.getPostsByCategory(category).map((mapList) => mapList.map((map) => PostModel.fromMap(map)).toList());
  }
}
