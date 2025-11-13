import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs222_final/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:cs222_final/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockUser extends Mock implements User {}

void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockRemoteDataSource);
  });

  group('AuthRepositoryImpl', () {
    final mockUser = MockUser();

    test('should forward authStateChanges stream', () {
      final userStream = Stream<User?>.value(mockUser);
      when(() => mockRemoteDataSource.authStateChanges)
          .thenAnswer((_) => userStream);

      final result = repository.authStateChanges;

      expect(result, userStream);
      verify(() => mockRemoteDataSource.authStateChanges).called(1);
    });

    test('should call signInWithEmailPassword and return User', () async {
      when(() => mockRemoteDataSource.signInWithEmailPassword(any(), any()))
          .thenAnswer((_) async => mockUser);

      final result = await repository.signInWithEmailPassword('test@email.com', 'password');

      expect(result, mockUser);
      verify(() => mockRemoteDataSource.signInWithEmailPassword('test@email.com', 'password')).called(1);
    });

    test('should call signUpWithEmailPassword and return User', () async {
      when(() => mockRemoteDataSource.signUpWithEmailPassword(any(), any()))
          .thenAnswer((_) async => mockUser);

      final result = await repository.signUpWithEmailPassword('email', 'pass');

      expect(result, mockUser);
      verify(() => mockRemoteDataSource.signUpWithEmailPassword('email', 'pass')).called(1);
    });

    test('should call signInWithGoogle and return User', () async {
      when(() => mockRemoteDataSource.signInWithGoogle())
          .thenAnswer((_) async => mockUser);

      final result = await repository.signInWithGoogle();

      expect(result, mockUser);
      verify(() => mockRemoteDataSource.signInWithGoogle()).called(1);
    });

    test('should call signOut', () async {
      when(() => mockRemoteDataSource.signOut())
          .thenAnswer((_) async {});

      await repository.signOut();

      verify(() => mockRemoteDataSource.signOut()).called(1);
    });

    test('should call getCurrentUser and return User', () {
      when(() => mockRemoteDataSource.getCurrentUser())
          .thenReturn(mockUser);

      final result = repository.getCurrentUser();

      expect(result, mockUser);
      verify(() => mockRemoteDataSource.getCurrentUser()).called(1);
    });
  });
}
