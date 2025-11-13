import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs222_final/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:cs222_final/features/posts/data/models/post_model.dart';
import 'package:cs222_final/features/posts/domain/entities/post_entity.dart';
import 'package:cs222_final/features/posts/domain/repositories/posts_repository.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource postsRemoteDataSource;

  PostsRepositoryImpl(this.postsRemoteDataSource);

  @override
  Stream<List<PostEntity>> getAllPosts() {
    final Stream<List<QueryDocumentSnapshot>> allPostsData =
        postsRemoteDataSource.getAllPostsData();

    //convert to list<entity>
    return allPostsData.map((docs) {
      final entities = docs
          .map(
            (doc) =>
                PostModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList();
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
  Future<void> deleteAllPosts() async {
    await postsRemoteDataSource.deleteAllPosts();
  }

  @override
  Stream<List<PostEntity>> getPostsFilteredByTitle(
    List<String> categories,
    List<bool> types,
    String? title,
  ) {
    final Stream<List<QueryDocumentSnapshot>> filteredPostsData =
        postsRemoteDataSource.getPostsFilteredByTitle(categories, types, title);

    return filteredPostsData.map((docs) {
      final entities = docs
          .map(
            (doc) =>
                PostModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList();

      return entities;
    });
  }
}
