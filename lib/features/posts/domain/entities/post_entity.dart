import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String category;
  final String postId;
  final String title;
  final String? description;
  final String authorId;
  final String authorName;
  final String? location;
  final DateTime timestamp;
  final bool isResolved;
  final bool isRequest;
  final List<String> neededSkills;

  const PostEntity({
    required this.category,
    required this.postId,
    required this.title,
    this.description,
    required this.authorId,
    required this.authorName,
    this.location,
    required this.timestamp,
    this.isResolved = false,
    required this.isRequest,
    this.neededSkills = const [],
  });

  @override
  List<Object?> get props => [
    category,
    postId,
    title,
    description,
    authorId,
    authorName,
    location,
    timestamp,
    isResolved,
    isRequest,
    neededSkills,
  ];
}
