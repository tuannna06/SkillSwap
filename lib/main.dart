import 'package:cs222_final/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:cs222_final/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:cs222_final/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cs222_final/features/auth/presentation/bloc/auth_event.dart';
import 'package:cs222_final/features/auth/presentation/bloc/auth_state.dart';
import 'package:cs222_final/features/auth/presentation/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cs222_final/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:cs222_final/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:cs222_final/features/posts/presentation/bloc/posts_bloc.dart';
import 'package:cs222_final/navigation/main_navigation_page.dart';

import 'features/profile/data/datasources/profile_remote_datasource.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'firebase_options.dart';

//Claim logic imports
import 'features/claims/data/repositories/claims_repository_impl.dart';
import 'features/claims/presentation/bloc/claims_bloc.dart';

//Ratings logic imports
import 'features/ratings/data/repositories/ratings_repository_impl.dart';
import 'features/ratings/presentation/bloc/ratings_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skill Sharing Profile',
      theme: ThemeData(fontFamily: 'Roboto', useMaterial3: true),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PostsBloc(
              repository: PostsRepositoryImpl(PostsRemoteDataSource()),
            ),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(
              repository: ProfileRepositoryImpl(ProfileRemoteDatasource()),
            ),
          ),
          BlocProvider(
            create: (context) => AuthBloc(
              repository: AuthRepositoryImpl(AuthRemoteDataSource()),
            ),
          ),
          BlocProvider(
            create: (context) => ClaimsBloc(
              claimsRepository: ClaimsRepositoryImpl(),
            ),
          ),
          BlocProvider(
            create: (context) => RatingsBloc(
              ratingsRepository: RatingsRepositoryImpl(),
              authBloc: context.read<AuthBloc>(),
            ),
          ),
        ],
        child: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        //Add logic to return different pages based on auth state
        if (state is AuthInitial) {
          context.read<AuthBloc>().add(AuthCheckRequested());
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state is AuthLoading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state is Authenticated) {
          return MainNavigationPage();
        }
        return LoginPage();
      },
    );
  }
}
