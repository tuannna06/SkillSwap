import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- AUTH & COMMON IMPORTS ---
import 'package:cs222_final/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cs222_final/features/auth/presentation/bloc/auth_state.dart';
import 'package:cs222_final/components/custom_app_bar.dart';

// --- POSTS FEATURE IMPORTS ---
import 'package:cs222_final/features/posts/domain/entities/post_entity.dart';
import 'package:cs222_final/features/posts/domain/entities/post_category.dart';
import 'package:cs222_final/features/posts/presentation/bloc/posts_bloc.dart';
import 'package:cs222_final/features/posts/presentation/bloc/posts_event.dart';
import 'package:cs222_final/features/posts/presentation/bloc/posts_state.dart';
import 'package:cs222_final/features/posts/presentation/pages/create_post_page.dart';
import 'package:cs222_final/features/posts/presentation/widgets/post_card.dart';

// --- PROFILE FEATURE IMPORTS ---
import 'package:cs222_final/features/profile/presentation/pages/profile_page.dart';
import 'package:cs222_final/features/profile/presentation/bloc/profile_bloc.dart';

// --- DATA LAYER IMPORTS (THE FIX) ---
// 1. The Concrete Datasource Class
import 'package:cs222_final/features/profile/data/datasources/profile_remote_datasource.dart';
// 2. The Repository Implementation
import 'package:cs222_final/features/profile/data/repositories/profile_repository_impl.dart';
// 3. The Repository Interface (Vital for RepositoryProvider to work)
import 'package:cs222_final/features/profile/domain/repositories/profile_repository.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  List<String> categories = PostCategory.values.map((e) => e.name).toList();
  final List<bool> types = [true, false];
  String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: CustomAppBar(title: 'Community Help'),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search tasks...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (query) {
                      title = query;
                      context.read<PostsBloc>().add(
                        FilterPosts(categories, types, title),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _showFilterDialog(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.filter_list, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: BlocBuilder<PostsBloc, PostsState>(
              builder: (context, state) {
                if (state is PostsInitial) {
                  context.read<PostsBloc>().add(PostLoadRequested());
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is PostsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is PostsLoaded) {
                  return BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      if (authState is Authenticated) {
                        final String username = authState.user.displayName.toString();
                        return _buildPostContent(context, state.posts, username);
                      }
                      return const SizedBox();
                    },
                  );
                }
                if (state is PostsError) {
                  return _buildErrorWidget(context, state.message);
                }
                return const Center(child: Text('unknown state'));
              },
            ),
          ),
        ],
      ),

      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
            onPressed: () {
              final postsBloc = context.read<PostsBloc>();
              final authBloc = context.read<AuthBloc>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: postsBloc),
                      BlocProvider.value(value: authBloc),
                    ],
                    child: CreatePostPage(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPostContent(BuildContext context, List<PostEntity> posts, String username) {
    if (posts.isEmpty) {
      return const Center(child: Text('No Posts Yet'));
    }
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PostsBloc>().add(PostLoadRequested());
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: posts.map((post) {
          return PostCard(
            post: post,
            username: username,
            // --- FIXED NAVIGATION LOGIC ---
            onProfileTap: () {
              // 1. Capture the existing AuthBloc from the current context
              final authBloc = context.read<AuthBloc>();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    final datasource = ProfileRemoteDatasource();
                    final repository = ProfileRepositoryImpl(datasource);

                    // 2. Wrap everything in BlocProvider.value to pass the AuthBloc
                    return BlocProvider.value(
                      value: authBloc,
                      child: RepositoryProvider<ProfileRepository>(
                        create: (context) => repository,
                        child: BlocProvider(
                          create: (context) => ProfileBloc(
                            repository: repository,
                          ),
                          child: ProfilePage(
                            userId: post.authorId,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            currentUserId:
                (context.read<AuthBloc>().state as Authenticated).user.uid,
            // -----------------------------
          );
        }).toList(),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $message'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<PostsBloc>().add(PostLoadRequested()),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext outerContext) {
    showDialog(
      context: outerContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Posts'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const Text('Post Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 16),
                    _buildCategoryChipsGrid(),
                    const SizedBox(height: 24),
                    const Text('Post Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: _buildPostTypeCard(
                              title: 'Request',
                              icon: Icons.request_page_rounded,
                              isSelected: types.contains(true),
                              onTap: () {
                                setState(() {
                                  if (types.contains(true)) {
                                    if (types.length == 1) return;
                                    types.remove(true);
                                  } else {
                                    types.add(true);
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: _buildPostTypeCard(
                              title: 'Offer',
                              icon: Icons.volunteer_activism_rounded,
                              isSelected: types.contains(false),
                              onTap: () {
                                setState(() {
                                  if (types.contains(false)) {
                                    if (types.length == 1) return;
                                    types.remove(false);
                                  } else {
                                    types.add(false);
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                outerContext.read<PostsBloc>().add(FilterPosts(categories, types, title));
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryChipsGrid() {
    int columns = 3;
    List<Widget> rows = [];
    for (int i = 0; i < PostCategory.values.length; i += columns) {
      List<PostCategory> rowCategories = PostCategory.values.skip(i).take(columns).toList();
      rows.add(_buildCategoryChipsRow(rowCategories));
      if (i + columns < PostCategory.values.length) {
        rows.add(const SizedBox(height: 8));
      }
    }
    return Column(children: rows);
  }

  Widget _buildCategoryChipsRow(List<PostCategory> rowCategories) {
    return Row(
      children: rowCategories.map((category) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: StatefulBuilder(
              builder: (context, setLocalState) {
                return _buildCategoryChip(
                  category: category,
                  isSelected: categories.contains(category.name),
                  onTap: () {
                    setLocalState(() {
                      if (categories.contains(category.name)) {
                        if (categories.length == 1) return;
                        categories.remove(category.name);
                      } else {
                        categories.add(category.name);
                      }
                    });
                  },
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryChip({required PostCategory category, required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!, width: 2),
        ),
        child: Column(
          children: [
            Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, size: 20, color: isSelected ? Colors.white : Colors.grey[600]),
            const SizedBox(height: 8),
            Text(category.label, style: TextStyle(color: isSelected ? Colors.white : Colors.grey[800], fontWeight: FontWeight.w600, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildPostTypeCard({required String title, required IconData icon, required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!, width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: isSelected ? Colors.white : Colors.grey[700]),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.grey[800], fontWeight: FontWeight.w600, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}