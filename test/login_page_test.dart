import 'package:bloc_test/bloc_test.dart';
import 'package:cs222_final/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cs222_final/features/auth/presentation/bloc/auth_event.dart';
import 'package:cs222_final/features/auth/presentation/bloc/auth_state.dart';
import 'package:cs222_final/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

//mock auth block
class MockAuthBloc extends Mock implements AuthBloc {}

class FakeAuthEvent extends Fake implements AuthEvent {}

class FakeAuthState extends Fake implements AuthState {}

void main() {
  late AuthBloc authBloc;

  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
    registerFallbackValue(FakeAuthState());
  });

  setUp(() {
    authBloc = MockAuthBloc();

    when(() => authBloc.state).thenReturn(AuthInitial());
    when(() => authBloc.stream).thenAnswer((_) => const Stream<AuthState>.empty());

    // mock for event verification
    when(() => authBloc.add(any())).thenReturn(null);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: LoginPage(),
      ),
    );
  }

  testWidgets('displays title, tagline, and Google Sign-In button',
      (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Skill Share'), findsOneWidget);
    expect(find.text('Connect and exchange skills'), findsOneWidget);
    expect(find.text('Sign in with Google'), findsOneWidget);
    expect(find.byIcon(Icons.g_mobiledata), findsOneWidget);
  });

  testWidgets('tapping Google Sign-In button adds SignInWithGoogleRequested event',
      (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final button = find.text('Sign in with Google');
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pump();

    verify(() => authBloc.add(SignInWithGoogleRequested())).called(1);
  });

  testWidgets('shows SnackBar when AuthError state is emitted', (tester) async {
    // emit autherror
    whenListen(
      authBloc,
      Stream<AuthState>.fromIterable([AuthError('Login failed')]),
      initialState: AuthInitial(),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Login failed'), findsOneWidget);
  });
}
