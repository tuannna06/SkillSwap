import 'package:equatable/equatable.dart';
import '../../domain/entities/post_entity.dart';

abstract class PostsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PostLoadRequested extends PostsEvent {}

class RefreshPostRequested extends PostsEvent {}

class CreateNewPostRequested extends PostsEvent {
  final PostEntity post;
  CreateNewPostRequested(this.post);

  @override
  List<Object> get props => [post];
}

class UpdatePostRequested extends PostsEvent {
  final String postId;
  final Map<String, dynamic> updates;
  UpdatePostRequested(this.postId, this.updates);

  @override
  List<Object> get props => [postId, updates];
}

class DeletePostRequested extends PostsEvent {
  final String postId;

  DeletePostRequested(this.postId);

  @override
  List<Object> get props => [postId];
}

class FilterPostsByCategory extends PostsEvent {
  final String? category;

  FilterPostsByCategory(this.category);
}
