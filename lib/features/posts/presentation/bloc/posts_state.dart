import 'package:equatable/equatable.dart';
import 'package:cs222_final/features/posts/domain/entities/post_entity.dart';

abstract class PostsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<PostEntity> posts;
  PostsLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class PostsError extends PostsState {
  final String message;
  PostsError(this.message);

  @override
  List<Object?> get props => [message];
}
