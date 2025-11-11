import 'package:cs222_final/features/profile/domain/repositories/profile_repository.dart';
import 'package:cs222_final/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:cs222_final/features/profile/domain/entities/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cs222_final/features/profile/presentation/bloc/profile_state.dart';
import 'package:cs222_final/features/profile/presentation/bloc/profile_event.dart';

// Mock class for the repository
class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  // Setting fallback values for any parameters used in the tests
  setUpAll(() {
    registerFallbackValue(
      UserEntity(
        id: "test-id",
        name: "Test User",
        email: "test@example.com",
        phone: "1234567890",
        address: "123 Test St",
        offeredSkills: ["Testing", "Mocking"],
      ),
    );
  });

  // Group tests for the ProfileBloc
  group('ProfileBloc', () {
    late ProfileRepository mockProfileRepository;
    late ProfileBloc profileBloc;

    final mockUser1 = UserEntity(
      id: "uf-football-coach",
      name: "Steve Spurrier",
      email: "spurrier@uf.com",
      phone: "1234567899",
      address: "100 Stadium Rd, Gainesville, FL",
      offeredSkills: ["Hating", "Mocking"],
    );

    // final mockUser2 = UserEntity(
    //   id: "smart-guy",
    //   name: "Hau Pham",
    //   email: "ap100@illinois.edu",
    //   phone: "1234567898",
    //   address: "100 Stadium Rd, Gainesville, FL (he lives with Steve Spurrier)",
    //   offeredSkills: ["Coding", "Sleeping"],
    // );

    setUp(() {
      mockProfileRepository = MockProfileRepository();
      profileBloc = ProfileBloc(repository: mockProfileRepository);
    });

    tearDown(() {
      profileBloc.close();
    });

    test('initial state is ProfileInitial', () {
      expect(profileBloc.state, ProfileInitial());
    });

    // test loading user profile - success
    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] when ProfileLoadRequested succeeds',
      build: () {
        when(
          () => mockProfileRepository.getUserProfile(any()),
        ).thenAnswer((_) async => mockUser1);
        return profileBloc;
      },
      act: (bloc) => bloc.add(ProfileLoadRequested(mockUser1.id)),
      expect: () => [ProfileLoading(), ProfileLoaded(mockUser1)],
    );

    // test loading user profile - failure
    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileError] when ProfileLoadRequested fails',
      build: () {
        when(
          () => mockProfileRepository.getUserProfile(any()),
        ).thenThrow(Exception('Failed to load user'));
        return profileBloc;
      },
      act: (bloc) => bloc.add(ProfileLoadRequested(mockUser1.id)),
      expect: () => [
        ProfileLoading(),
        ProfileError('Exception: Failed to load user'),
      ],
    );

    //test creating a user - success
    // blocTest<ProfileBloc, ProfileState>(
    //   'emits [ProfileLoading, ProfileLoaded] when CreateUserRequested succeeds',
    //   build: () {
    //     when(
    //       () => mockProfileRepository.createUser(any()),
    //     ).thenAnswer((_) async => 'new-user-id');
    //     when(
    //       () => mockProfileRepository.getUserProfile(any()),
    //     ).thenAnswer((_) async => mockUser1);
    //     return profileBloc;
    //   },
    //   act: (bloc) => bloc.add(CreateUserRequested(mockUser1)),
    //   expect: () => [ProfileLoading(), ProfileLoaded(mockUser1)],
    // );

    // test creating a user - failure
    // blocTest<ProfileBloc, ProfileState>(
    //   'emits [ProfileError] when CreateUserRequested fails',
    //   build: () {
    //     when(
    //       () => mockProfileRepository.createUser(any()),
    //     ).thenThrow(Exception('Create failed'));
    //     return profileBloc;
    //   },
    //   act: (bloc) => bloc.add(CreateUserRequested(mockUser1)),
    //   expect: () => [
    //     ProfileLoading(),
    //     ProfileError('Failed to create user: Exception: Create failed'),
    //   ],
    // );

    // test deleting a user - success
    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileInitial] when DeleteUserRequested succeeds',
      build: () {
        when(
          () => mockProfileRepository.deleteUser(any()),
        ).thenAnswer((_) async {});
        return profileBloc;
      },
      act: (bloc) => bloc.add(DeleteUserRequested(mockUser1.id)),
      expect: () => [ProfileLoading(), ProfileInitial()],
    );

    // test deleting a user - failure
    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileError] when DeleteUserRequested fails',
      build: () {
        when(
          () => mockProfileRepository.deleteUser(any()),
        ).thenThrow(Exception('Delete failed'));
        return profileBloc;
      },
      act: (bloc) => bloc.add(DeleteUserRequested(mockUser1.id)),
      expect: () => [
        ProfileLoading(),
        ProfileError('Failed to delete user: Exception: Delete failed'),
      ],
    );

    // test updating a user - success
    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] when UpdateUserRequested succeeds',
      build: () {
        when(
          () => mockProfileRepository.updateUser(any(), any()),
        ).thenAnswer((_) async {});
        when(
          () => mockProfileRepository.getUserProfile(any()),
        ).thenAnswer((_) async => mockUser1);
        return profileBloc;
      },
      act: (bloc) =>
          bloc.add(UpdateUserRequested(mockUser1.id, {"name": "Updated Name"})),
      expect: () => [ProfileLoading(), ProfileLoaded(mockUser1)],
    );

    // test updating a user - failure
    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileError] when UpdateUserRequested fails',
      build: () {
        when(
          () => mockProfileRepository.updateUser(any(), any()),
        ).thenThrow(Exception('Update failed'));
        return profileBloc;
      },
      act: (bloc) =>
          bloc.add(UpdateUserRequested(mockUser1.id, {"name": "Updated Name"})),
      expect: () => [
        ProfileLoading(),
        ProfileError('Failed to update user: Exception: Update failed'),
      ],
    );
  });
}
