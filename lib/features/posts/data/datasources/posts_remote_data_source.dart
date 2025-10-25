import 'package:cloud_firestore/cloud_firestore.dart';

class PostsRemoteDataSource {
  final postCollection = FirebaseFirestore.instance.collection('posts');

  Future<Map<String, dynamic>> getPost(String postId) async {
    final DocumentSnapshot doc = await postCollection.doc(postId).get();
    if (!doc.exists) {
      throw Exception('User not found');
    }
    return doc.data() as Map<String, dynamic>;
  }

  Stream<Map<String, dynamic>> getPostStream(String postId) {
    return postCollection.doc(postId).snapshots().map((doc) {
      if (!doc.exists) {
        throw Exception('Post not found');
      }
      return doc.data() as Map<String, dynamic>;
    });
  }

  Stream<List<Map<String, dynamic>>> getAllPostsData() {
    return postCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => {'postId': doc.id, ...doc.data()})
                  .toList(),
        );
  }

  Future<String> createPostData(Map<String, dynamic> postData) async {
    final docRef = await postCollection.add(postData);
    return docRef.id;
  }

  Future<void> updatePostData(
    String postId,
    Map<String, dynamic> updates,
  ) async {
    await postCollection.doc(postId).update(updates);
  }

  Future<void> deletePost(String postId) async {
    await postCollection.doc(postId).delete();
  }


  Stream<List<Map<String, dynamic>>> getPostsFilteredByTitle(
    List<String> categories,
    List<bool> types,
    String? title,
  ) {
    Query query = postCollection;

    query = query
        .where('category', whereIn: categories)
        .where('isRequest', whereIn: types);

    if (title != null && title.isNotEmpty) {
      query = query
          .orderBy('title')
          .where('title', isGreaterThanOrEqualTo: title)
          .where('title', isLessThanOrEqualTo: '$title\uf8ff');
    } 
    return query.orderBy('timestamp', descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => {'postId': doc.id, ...doc.data() as Map<String, dynamic>})
              .toList(),
        );
  }

  Future<void> deleteAllPosts() async {
    final batch = FirebaseFirestore.instance.batch();
    final snapshot = await postCollection.get();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
  
}
