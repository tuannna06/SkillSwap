import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cs222_final/features/posts/domain/entities/post_entity.dart';
import 'package:cs222_final/features/posts/domain/repositories/posts_repository.dart';
import 'package:cs222_final/features/posts/presentation/bloc/posts_event.dart';
import 'package:cs222_final/features/posts/presentation/bloc/posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository repository;

  PostsBloc({required this.repository}) : super(PostsInitial()) {
    on<PostLoadRequested>(_onLoadRequested);
    on<RefreshPostRequested>(_onRefreshRequested);
    on<CreateNewPostRequested>(_onCreateNewRequested);
    on<UpdatePostRequested>(_onUpdateRequested);
    on<DeletePostRequested>(_onDeleteRequested);
    on<FilterPostsByCategory>(_onFilterPostByCategory);
  }

  Future<void> _onLoadRequested(
    PostLoadRequested event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostsLoading());

    try {
      await emit.forEach(
        repository.getAllPosts(), //Stream
        onData: (List<PostEntity> posts) => PostsLoaded(posts),
        onError: (error, stackTrace) => PostsError(error.toString()),
      );
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  Future<void> _onRefreshRequested(
    RefreshPostRequested event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostsLoading());

    try {
      await emit.forEach(
        repository.getAllPosts(),
        onData: (List<PostEntity> posts) => PostsLoaded(posts),
        onError: (error, stackTrace) => PostsError(error.toString()),
      );
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  Future<void> _onCreateNewRequested(
    CreateNewPostRequested event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostsLoading());

    try {
      await repository.createPost(event.post);
      add(PostLoadRequested());
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  Future<void> _onUpdateRequested(
    UpdatePostRequested event,
    Emitter<PostsState> emit,
  ) async {
    try {
      await repository.updatePost(event.postId, event.updates);
      add(PostLoadRequested());
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  Future<void> _onDeleteRequested(
    DeletePostRequested event,
    Emitter<PostsState> emit,
  ) async {
    try {
      await repository.deletePost(event.postId);
      add(PostLoadRequested());
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }
  Future<void> _onFilterPostByCategory(
      FilterPostsByCategory event,
      Emitter<PostsState> emit,
      )async{
    emit(PostsLoading());
    try{
      await emit.forEach(repository.getPostsByCategory(event.category ?? 'Other'),
      onData: (List<PostEntity> posts) => PostsLoaded(posts),
      onError: (error, _) => PostsError(error.toString()));
    } catch(e){
      emit(PostsError(e.toString()));
    }
  }
}
