import 'package:bloc_test/bloc_test.dart';
import 'package:cs222_final/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs222_final/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cs222_final/features/auth/presentation/bloc/auth_event.dart';
import 'package:cs222_final/features/auth/presentation/bloc/auth_state.dart';

//Mock test for authentication cover all cases

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  late MockAuthRepository mockRepository;
  late MockUser mockUser;

  setUp(() {
    mockRepository = MockAuthRepository();
    mockUser = MockUser();

    when(() => mockUser.uid).thenReturn('test-uid-123');
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockUser.displayName).thenReturn('Test User');
  });

  group('AuthBloc', () {
    test('Initial State should be AuthInitial', () {
      final bloc = AuthBloc(repository: mockRepository);
      expect(bloc.state, AuthInitial());
    });

    //auth check requested state
    group('AuthCheckRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [Authenticated] when user is logged in',
        build: () {
          when(() => mockRepository.getCurrentUser()).thenReturn(mockUser);
          return AuthBloc(repository: mockRepository);
        },
        act: (bloc) => bloc.add(AuthCheckRequested()),
        wait: const Duration(milliseconds: 600),
        expect: () => [Authenticated(mockUser)],
        verify: (_) {
          verify(() => mockRepository.getCurrentUser()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [Unauthenticated] when no user is logged in',
        build: () {
          when(() => mockRepository.getCurrentUser()).thenReturn(null);
          return AuthBloc(repository: mockRepository);
        },
        act: (bloc) => bloc.add(AuthCheckRequested()),
        wait: const Duration(milliseconds: 600),
        expect: () => [Unauthenticated()],
        verify: (_) {
          verify(() => mockRepository.getCurrentUser()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthError] when an error occurs',
        build: () {
          when(
            () => mockRepository.getCurrentUser(),
          ).thenThrow(Exception('Auth check failed'));
          return AuthBloc(repository: mockRepository);
        },
        act: (bloc) => bloc.add(AuthCheckRequested()),
        expect: () => [
          isA<AuthError>().having(
            (e) => e.message,
            'message',
            contains('Auth check failed'),
          ),
        ],
      );
    });

    group('SignInWithGoogleRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Authenticated] when sign in is successful',
        build: () {
          when(
            () => mockRepository.signInWithGoogle(),
          ).thenAnswer((_) async => mockUser);
          return AuthBloc(repository: mockRepository);
        },
        act: (bloc) => bloc.add(SignInWithGoogleRequested()),
        wait: const Duration(milliseconds: 600),
        expect: () => [AuthLoading(), Authenticated(mockUser)],
        verify: (_) {
          verify(() => mockRepository.signInWithGoogle()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Unauthenticated] when user cancels sign in',
        build: () {
          when(
            () => mockRepository.signInWithGoogle(),
          ).thenAnswer((_) async => null);
          return AuthBloc(repository: mockRepository);
        },
        act: (bloc) => bloc.add(SignInWithGoogleRequested()),
        wait: const Duration(milliseconds: 600),
        expect: () => [AuthLoading(), Unauthenticated()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when sign in fails',
        build: () {
          when(
            () => mockRepository.signInWithGoogle(),
          ).thenThrow(Exception('Google sign in failed'));
          return AuthBloc(repository: mockRepository);
        },
        act: (bloc) => bloc.add(SignInWithGoogleRequested()),
        expect: () => [
          AuthLoading(),
          isA<AuthError>().having(
            (e) => e.message,
            'message',
            contains('Google sign in failed'),
          ),
        ],
      );
    });

    group('SignInWithEmailRequested', () {
      const testEmail = 'test@example.com';
      const testPassword = 'password123';

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Authenticated] when email sign in is successful',
        build: () {
          when(
            () =>
                mockRepository.signInWithEmailPassword(testEmail, testPassword),
          ).thenAnswer((_) async => mockUser);
          return AuthBloc(repository: mockRepository);
        },
        act: (bloc) =>
            bloc.add(SignInWithEmailRequested(testEmail, testPassword)),
        wait: const Duration(milliseconds: 600),
        expect: () => [AuthLoading(), Authenticated(mockUser)],
        verify: (_) {
          verify(
            () =>
                mockRepository.signInWithEmailPassword(testEmail, testPassword),
          ).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when email sign in fails',
        build: () {
          when(
            () => mockRepository.signInWithEmailPassword(any(), any()),
          ).thenThrow(Exception('Invalid credentials'));
          return AuthBloc(repository: mockRepository);
        },
        act: (bloc) =>
            bloc.add(SignInWithEmailRequested(testEmail, testPassword)),
        expect: () => [
          AuthLoading(),
          isA<AuthError>().having(
            (e) => e.message,
            'message',
            contains('Invalid credentials'),
          ),
        ],
      );
    });

    group('SignUpWithEmailRequested', () {
      const testEmail = 'newuser@example.com';
      const testPassword = 'password123';

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Authenticated] when sign up is successful',
        build: () {
          when(
            () =>
                mockRepository.signUpWithEmailPassword(testEmail, testPassword),
          ).thenAnswer((_) async => mockUser);
          return AuthBloc(repository: mockRepository);
        },
        act: (bloc) =>
            bloc.add(SignUpWithEmailRequested(testEmail, testPassword)),
        wait: const Duration(milliseconds: 600),
        expect: () => [AuthLoading(), Authenticated(mockUser)],
        verify: (_) {
          verify(
            () =>
                mockRepository.signUpWithEmailPassword(testEmail, testPassword),
          ).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when sign up fails',
        build: () {
          when(
            () => mockRepository.signUpWithEmailPassword(any(), any()),
          ).thenThrow(Exception('Email already in use'));
          return AuthBloc(repository: mockRepository);
        },
        act: (bloc) =>
            bloc.add(SignUpWithEmailRequested(testEmail, testPassword)),
        expect: () => [
          AuthLoading(),
          isA<AuthError>().having(
            (e) => e.message,
            'message',
            contains('Email already in use'),
          ),
        ],
      );
    });

    group('SignOutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Unauthenticated] when sign out is successful',
        build: () {
          when(() => mockRepository.signOut()).thenAnswer((_) async {});
          return AuthBloc(repository: mockRepository);
        },
        act: (bloc) => bloc.add(SignOutRequested()),
        expect: () => [AuthLoading(), Unauthenticated()],
        verify: (_) {
          verify(() => mockRepository.signOut()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when sign out fails',
        build: () {
          when(
            () => mockRepository.signOut(),
          ).thenThrow(Exception('Sign out failed'));
          return AuthBloc(repository: mockRepository);
        },
        act: (bloc) => bloc.add(SignOutRequested()),
        expect: () => [
          AuthLoading(),
          isA<AuthError>().having(
            (e) => e.message,
            'message',
            contains('Sign out failed'),
          ),
        ],
      );
    });
  });
}


/*
✓ AuthBloc Initial State should be AuthInitial
✓ AuthBloc AuthCheckRequested emits [Authenticated] when user is logged in
✓ AuthBloc AuthCheckRequested emits [Unauthenticated] when no user is logged in
✓ AuthBloc AuthCheckRequested emits [AuthError] when an error occurs
✓ AuthBloc SignInWithGoogleRequested emits [AuthLoading, Authenticated] when sign in is successful
✓ AuthBloc SignInWithGoogleRequested emits [AuthLoading, Unauthenticated] when user cancels sign in
✓ AuthBloc SignInWithGoogleRequested emits [AuthLoading, AuthError] when sign in fails
✓ AuthBloc SignInWithEmailRequested emits [AuthLoading, Authenticated] when email sign in is successful
✓ AuthBloc SignInWithEmailRequested emits [AuthLoading, AuthError] when email sign in fails
✓ AuthBloc SignUpWithEmailRequested emits [AuthLoading, Authenticated] when sign up is successful
✓ AuthBloc SignUpWithEmailRequested emits [AuthLoading, AuthError] when sign up fails
✓ AuthBloc SignOutRequested emits [AuthLoading, Unauthenticated] when sign out is successful
✓ AuthBloc SignOutRequested emits [AuthLoading, AuthError] when sign out fails
*/