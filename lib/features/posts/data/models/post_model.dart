import 'package:cs222_final/features/posts/domain/entities/post_entity.dart';
import 'package:cs222_final/features/posts/domain/entities/post_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel extends PostEntity {
  const PostModel({
  required super.category,
    required super.postId,
    required super.title,
    super.description,
    required super.authorId,
    required super.authorName,
    super.location,
    required super.timestamp,
    super.isResolved = false,
    required super.isRequest,
    super.neededSkills = const [],
  });

  // Add toMap() and fromMap() methods here
  Map<String, dynamic> toMap() {
    return {
      'category' : category.name,
      'title': title,
      'description': description,
      'authorId': authorId,
      'authorName': authorName,
      'location': location,
      'timestamp': Timestamp.fromDate(timestamp),
      'isResolved': isResolved,
      'isRequest': isRequest,
      'neededSkills': neededSkills,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map, String docID) {
    return PostModel(
      category: PostCategory.values.byName(map['category'] ?? PostCategory.other.name),
      postId: docID,
      title: map['title'] ?? '',
      description: map['description'],
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      location: map['location'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      isResolved: map['isResolved'] ?? false,
      isRequest: map['isRequest'] ?? true,
      neededSkills: (map['neededSkills'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  // Convert PostEntity to PostModel
  factory PostModel.fromEntity(PostEntity entity) {
    return PostModel(
      category: entity.category,
      postId: entity.postId,
      title: entity.title,
      description: entity.description,
      authorId: entity.authorId,
      authorName: entity.authorName,
      location: entity.location,
      timestamp: entity.timestamp,
      isResolved: entity.isResolved,
      isRequest: entity.isRequest,
      neededSkills: entity.neededSkills,
    );
  }
}
