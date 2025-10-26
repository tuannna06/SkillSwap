import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cs222_final/components/custom_app_bar.dart';
import 'package:cs222_final/features/posts/domain/entities/post_entity.dart';
import 'package:cs222_final/features/posts/domain/entities/post_category.dart';
import 'package:cs222_final/features/posts/presentation/bloc/posts_bloc.dart';
import 'package:cs222_final/features/posts/presentation/bloc/posts_event.dart';
import 'package:cs222_final/features/posts/presentation/bloc/posts_state.dart';
import 'package:cs222_final/features/posts/presentation/pages/create_post_page.dart';
import 'package:cs222_final/features/posts/presentation/widgets/post_card.dart';

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
                // Search Field
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
                // Filter Button
                InkWell(
                  onTap: () {
                    // Open filter modal or show popup menu
                    _showFilterDialog(context);
                  },
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
                  return _buildPostContent(context, state.posts);
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
            child: Icon(Icons.add),
            onPressed: () {
              final postsBloc = context.read<PostsBloc>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: postsBloc,
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

  Widget _buildPostContent(BuildContext context, List<PostEntity> posts) {
    if (posts.isEmpty) {
      return Center(child: Text('No Posts Yet'));
    }
    return RefreshIndicator(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: posts.map((post) => PostCard(post: post)).toList(),
      ),
      onRefresh: () async {
        context.read<PostsBloc>().add(PostLoadRequested());
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red),
          SizedBox(height: 16),
          Text('Error: $message'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<PostsBloc>().add(PostLoadRequested()),
            child: Text('Try Again'),
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
                    const Text(
                      'Post Category',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildCategoryChipsGrid(),

                    const SizedBox(height: 24),

                    // Post Type Section
                    const Text(
                      'Post Type',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 0.5,
                      ),
                    ),
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
                                    if (types.length == 1) {
                                      return;
                                    }
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
                                    if (types.length == 1) {
                                      return;
                                    }
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
                outerContext.read<PostsBloc>().add(
                  FilterPosts(categories, types, title),
                );
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
      List<PostCategory> rowCategories = PostCategory.values
          .skip(i)
          .take(columns)
          .toList();
      rows.add(_buildCategoryChipsRow(rowCategories));
      if (i + columns < PostCategory.values.length) {
        rows.add(const SizedBox(height: 8));
      }
    }
    return Column(
      children: rows,
    );  
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
                        if (categories.length == 1) {
                          return;
                        }
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

  Widget _buildCategoryChip({
    required PostCategory category,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              size: 20,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              category.label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[800],
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostTypeCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[800],
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Temp Base code provided by ChatGPT
