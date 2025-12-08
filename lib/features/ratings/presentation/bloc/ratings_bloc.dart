import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cs222_final/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cs222_final/features/auth/presentation/bloc/auth_state.dart';
import 'package:cs222_final/features/ratings/domain/entities/rating_entity.dart';
import 'package:cs222_final/features/ratings/domain/repositories/ratings_repository.dart';
import 'package:cs222_final/features/ratings/presentation/bloc/ratings_event.dart';
import 'package:cs222_final/features/ratings/presentation/bloc/ratings_state.dart';

class RatingsBloc extends Bloc<RatingsEvent, RatingsState> {
  final RatingsRepository _ratingsRepository;
  final AuthBloc _authBloc;

  RatingsBloc({
    required RatingsRepository ratingsRepository,
    required AuthBloc authBloc,
  })  : _ratingsRepository = ratingsRepository,
        _authBloc = authBloc,
        super(RatingsInitial()) {
    on<SubmitRating>(_onSubmitRating);
    on<LoadUserRating>(_onLoadUserRating);
  }

  String? get _currentUserId {
    final authState = _authBloc.state;
    if (authState is Authenticated) {
      return authState.user.uid;
    }
    return null;
  }

  Future<void> _onSubmitRating(
    SubmitRating event,
    Emitter<RatingsState> emit,
  ) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) {
      emit(const RatingsError('User not authenticated'));
      return;
    }

    emit(RatingSubmitting());
    try {
      final rating = RatingEntity(
        id: '${currentUserId}_${event.ratedUserId}',
        raterId: currentUserId,
        ratedUserId: event.ratedUserId,
        rating: event.rating,
        timestamp: DateTime.now(),
      );
      await _ratingsRepository.submitRating(rating);
      emit(RatingSubmitted());
    } catch (e) {
      emit(RatingsError('Failed to submit rating: $e'));
    }
  }

  Future<void> _onLoadUserRating(
    LoadUserRating event,
    Emitter<RatingsState> emit,
  ) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) {
      emit(UserRatingLoaded(ratedUserId: event.ratedUserId, existingRating: null));
      return;
    }

    emit(RatingLoading());
    try {
      final existingRating = await _ratingsRepository.getUserRatingForUser(
        currentUserId,
        event.ratedUserId,
      );
      emit(UserRatingLoaded(ratedUserId: event.ratedUserId, existingRating: existingRating?.rating));
    } catch (e) {
      emit(RatingsError('Failed to load rating: $e'));
    }
  }

  /// Direct method to get user's existing rating for another user
  /// Useful for widgets that need immediate results on init
  Future<int?> getUserRatingForUser(String ratedUserId) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) return null;
    
    final rating = await _ratingsRepository.getUserRatingForUser(
      currentUserId,
      ratedUserId,
    );
    return rating?.rating;
  }
}
