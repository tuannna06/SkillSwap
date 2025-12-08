import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cs222_final/features/claims/domain/entities/claim_entity.dart';
import 'package:cs222_final/features/claims/domain/repositories/claims_repository.dart';
import 'package:cs222_final/features/claims/presentation/bloc/claims_event.dart';
import 'package:cs222_final/features/claims/presentation/bloc/claims_state.dart';

class ClaimsBloc extends Bloc<ClaimsEvent, ClaimsState> {
  final ClaimsRepository _claimsRepository;
  StreamSubscription? _claimsSubscription;

  ClaimsBloc({required ClaimsRepository claimsRepository})
      : _claimsRepository = claimsRepository,
        super(ClaimsInitial()) {
    on<CreateClaim>(_onCreateClaim);
    on<LoadClaimsForAuthor>(_onLoadClaimsForAuthor);
    on<LoadClaimsByUser>(_onLoadClaimsByUser);
    on<CheckIfUserClaimedPost>(_onCheckIfUserClaimedPost);
    on<UpdateClaimStatus>(_onUpdateClaimStatus);
    on<DeleteClaim>(_onDeleteClaim);
    on<_ClaimsUpdated>(_onClaimsUpdated);
    on<_ClaimsErrorOccurred>(_onClaimsErrorOccurred);
    on<LoadClaimsForPost>(_onLoadClaimsForPost);
  }


  Future<bool> hasUserClaimedPost(String userId, String postId) {
    return _claimsRepository.hasUserClaimedPost(userId, postId);
  }

  void _onClaimsUpdated(_ClaimsUpdated event, Emitter<ClaimsState> emit) {
    emit(ClaimsLoaded(event.claims.cast<ClaimEntity>()));
  }

  void _onClaimsErrorOccurred(_ClaimsErrorOccurred event, Emitter<ClaimsState> emit) {
    emit(ClaimsError(event.message));
  }

  Future<void> _onCreateClaim(
    CreateClaim event,
    Emitter<ClaimsState> emit,
  ) async {
    emit(ClaimCreating());
    try {
      await _claimsRepository.createClaim(event.claim);
      emit(ClaimCreated());
    } catch (e) {
      emit(ClaimsError('Failed to create claim: $e'));
    }
  }

  Future<void> _onLoadClaimsForAuthor(
    LoadClaimsForAuthor event,
    Emitter<ClaimsState> emit,
  ) async {
    emit(ClaimsLoading());
    await _claimsSubscription?.cancel();
    _claimsSubscription = _claimsRepository
        .getClaimsForAuthor(event.authorId)
        .listen(
          (claims) => add(_ClaimsUpdated(claims)),
          onError: (e) => add(_ClaimsErrorOccurred('Failed to load claims: $e')),
        );
  }

  Future<void> _onLoadClaimsByUser(
    LoadClaimsByUser event,
    Emitter<ClaimsState> emit,
  ) async {
    emit(ClaimsLoading());
    await _claimsSubscription?.cancel();
    _claimsSubscription = _claimsRepository
        .getClaimsByUser(event.userId)
        .listen(
          (claims) => add(_ClaimsUpdated(claims)),
          onError: (e) => add(_ClaimsErrorOccurred('Failed to load claims: $e')),
        );
  }

  Future<void> _onCheckIfUserClaimedPost(
    CheckIfUserClaimedPost event,
    Emitter<ClaimsState> emit,
  ) async {
    try {
      final hasClaimed = await _claimsRepository.hasUserClaimedPost(
        event.userId,
        event.postId,
      );
      emit(UserClaimStatus(postId: event.postId, hasClaimed: hasClaimed));
    } catch (e) {
      emit(ClaimsError('Failed to check claim status: $e'));
    }
  }

  Future<void> _onUpdateClaimStatus(
    UpdateClaimStatus event,
    Emitter<ClaimsState> emit,
  ) async {
    try {
      await _claimsRepository.updateClaimStatus(event.claimId, event.status);
      emit(ClaimStatusUpdated());
    } catch (e) {
      emit(ClaimsError('Failed to update claim status: $e'));
    }
  }

  Future<void> _onDeleteClaim(
    DeleteClaim event,
    Emitter<ClaimsState> emit,
  ) async {
    try {
      await _claimsRepository.deleteClaim(event.claimId);
      emit(ClaimDeleted());
    } catch (e) {
      emit(ClaimsError('Failed to delete claim: $e'));
    }
  }

  @override
  Future<void> close() {
    _claimsSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadClaimsForPost(
    LoadClaimsForPost event,
    Emitter<ClaimsState> emit,
  ) async {
    emit(ClaimsLoading());
    await _claimsSubscription?.cancel();
    _claimsSubscription = _claimsRepository
        .getClaimsForPost(event.postId)
        .listen(
          (claims) => add(_ClaimsUpdated(claims)),
          onError: (e) => add(_ClaimsErrorOccurred('Failed to load claims: $e')),
        );
  }
}

// Internal events for stream handling
class _ClaimsUpdated extends ClaimsEvent {
  final List<dynamic> claims;
  const _ClaimsUpdated(this.claims);

  @override
  List<Object?> get props => [claims];
}

class _ClaimsErrorOccurred extends ClaimsEvent {
  final String message;
  const _ClaimsErrorOccurred(this.message);

  @override
  List<Object?> get props => [message];
}
