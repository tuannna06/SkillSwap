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
            create:
                (context) => PostsBloc(
                  repository: PostsRepositoryImpl(PostsRemoteDataSource()),
                ),
          ),
          BlocProvider(
            create:
                (context) => ProfileBloc(
                  repository: ProfileRepositoryImpl(ProfileRemoteDatasource()),
                ),
          ),
        ],
        child: MainNavigationPage(),
      ),
    );
  }
}
