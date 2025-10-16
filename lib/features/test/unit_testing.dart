import 'package:cs222_final/features/posts/domain/repositories/posts_repository.dart';
import 'package:cs222_final/features/posts/presentation/bloc/posts_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cs222_final/features/posts/domain/entities/post_entity.dart';
import 'package:cs222_final/features/posts/presentation/bloc/posts_state.dart';
import 'package:cs222_final/features/posts/presentation/bloc/posts_event.dart';

// Mock class for the repository
class MockPostsRepository extends Mock implements PostsRepository {}

void main() {
  //Setting fallback values for any parameters used in the tests
      setUpAll(() {
      registerFallbackValue(PostEntity(
        category: 'Test',
        postId: 'test-id',
        title: 'Test Post',
        description: 'Test description',
        authorId: 'test-author',
        authorName: 'Test Author',
        location: 'Test Location',
        timestamp: DateTime(2024, 1, 1),
        isResolved: false,
        isRequest: true,
        neededSkills: [],
      ));
    });
  //  Group tests for the PostsBloc
  group('PostsBloc', () {
    // 3. Declare variables for the bloc and its mock dependency
    late PostsRepository mockPostsRepository;
    late PostsBloc postsBloc;
    // Create mock post data for testing
      final mockPost1 = PostEntity(
        category: 'Technology',
        postId: '1',
        title: 'Need help with Flutter',
        description: 'Looking for Flutter developer',
        authorId: 'user1',
        authorName: 'John Doe',
        location: 'Urbana',
        timestamp: DateTime(2024, 1, 1),
        isResolved: false,
        isRequest: true,
        neededSkills: ['Flutter', 'Dart'],
      );

      final mockPost2 = PostEntity(
        category: 'Education',
        postId: '2',
        title: 'Tutoring available',
        description: 'Offering math tutoring',
        authorId: 'user2',
        authorName: 'Jane Smith',
        location: 'Champaign',
        timestamp: DateTime(2024, 1, 2),
        isResolved: false,
        isRequest: false,
        neededSkills: ['Math', 'Teaching'],
      );

    //initialize these variables before each test
    setUp(() {
      mockPostsRepository = MockPostsRepository();
      postsBloc = PostsBloc(repository: mockPostsRepository);
    });
      tearDown(() {
    postsBloc.close();
      });

    // A simple test to check the initial state
    test('initial state is PostsInitial', () {
      expect(postsBloc.state, PostsInitial());
    });

    
    blocTest<PostsBloc, PostsState>(
    'emits [PostsLoading, PostsLoaded] when PostLoadRequested succeeds',
    build: () {
      when(() => mockPostsRepository.getAllPosts())
          .thenAnswer((_) => Stream.value([mockPost1, mockPost2]));
      return postsBloc;
    },
    act: (bloc) => bloc.add(PostLoadRequested()),
    expect: () => [
      PostsLoading(),
      PostsLoaded([mockPost1, mockPost2]),
    ],
  );
  blocTest<PostsBloc, PostsState>(
    'emits [PostsLoading, PostsError] when PostLoadRequested fails',
    build: () {
      when(() => mockPostsRepository.getAllPosts())
          .thenAnswer((_) => Stream.error(Exception('Failed to load posts')));
      return postsBloc;
    },
    act: (bloc) => bloc.add(PostLoadRequested()),
    expect: () => [
      PostsLoading(),
      PostsError('Exception: Failed to load posts'),
    ],
  );
  blocTest<PostsBloc, PostsState>(
    'emits [PostsLoading, PostsLoaded] when CreateNewPostRequested succeeds',
    build: () {
      when(() => mockPostsRepository.createPost(any()))
          .thenAnswer((_) async => 'new-post-id');
      when(() => mockPostsRepository.getAllPosts())
          .thenAnswer((_) => Stream.value([mockPost1, mockPost2]));
      return postsBloc;
    },
    act: (bloc) => bloc.add(CreateNewPostRequested(mockPost1)),
    expect: () => [
      PostsLoading(),
      PostsLoaded([mockPost1, mockPost2]),
    ],
  );
  });
}



/*
TEST OUTPUT
-------------------
00:00 +0: (setUpAll)
00:00 +1: PostsBloc initial state is PostsInitial
00:00 +2: PostsBloc emits [PostsLoading, PostsLoaded] when PostLoadRequested succeeds
00:00 +3: PostsBloc emits [PostsLoading, PostsError] when PostLoadRequested fails
00:00 +4: PostsBloc emits [PostsLoading, PostsLoaded] when CreateNewPostRequested succeeds
00:00 +5: (tearDownAll)
00:00 +6: All tests passed!
*/