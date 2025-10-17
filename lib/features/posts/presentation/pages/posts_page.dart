//import 'package:cs222_final/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cs222_final/components/custom_app_bar.dart';
import 'package:cs222_final/features/posts/domain/entities/post_entity.dart';
import 'package:cs222_final/features/posts/presentation/bloc/posts_bloc.dart';
import 'package:cs222_final/features/posts/presentation/bloc/posts_event.dart';
import 'package:cs222_final/features/posts/presentation/bloc/posts_state.dart';
import 'package:cs222_final/features/posts/presentation/pages/create_post_page.dart';
import 'package:cs222_final/features/posts/presentation/widgets/post_card.dart';

const List<String> categories = <String>['Programming', 'Design', 'Academic', 'Manual Labour', 'Sports', 'Other'];

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.blueGrey[100],
      appBar: CustomAppBar(title: 'Community Help'),
      body: Column(children: [
       Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: Colors.white,
        child: Row(
          children: [
            // Search Field
              Expanded(
                child: 
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (query) {
                    // Add filtering logic here, e.g.:
                    if (query.isEmpty) {
                      context.read<PostsBloc>().add(PostLoadRequested());
                    } else {
                      context.read<PostsBloc>().add(PostSearchRequested(query));
                    }
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
      
      Expanded(child:
       BlocBuilder<PostsBloc, PostsState>(
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
}

//Temp Base code provided by ChatGPT
void _showFilterDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String selectedCategory = categories.first;
      return AlertDialog(
        title: const Text('Filter by Category'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                  // Dispatch event to filter
                  context.read<PostsBloc>().add(FilterPostsByCategory(value));
                }
              },
              items: categories
                  .map((value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
