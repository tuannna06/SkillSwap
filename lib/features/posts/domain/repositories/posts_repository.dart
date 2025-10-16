import 'package:cs222_final/features/posts/domain/entities/post_entity.dart';

abstract class PostsRepository {
  Stream<List<PostEntity>> getAllPosts();
  Future<String> createPost(PostEntity post);
  Future<void> updatePost(String postId, Map<String, dynamic> updates);
  Future<void> deletePost(String postId);
  Stream<List<PostEntity>> getPostsByLocation(String location);
  Stream<List<PostEntity>> getPostsByCategory(String location);
  Future<void> deleteAllPosts();
}
