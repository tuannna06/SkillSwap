import 'package:cs222_final/features/posts/domain/entities/post_category.dart';
import 'package:flutter/material.dart';
import 'package:cs222_final/features/posts/domain/entities/post_entity.dart';
import 'package:cs222_final/features/posts/presentation/bloc/posts_bloc.dart';
import 'package:cs222_final/features/posts/presentation/bloc/posts_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  bool isRequest = true;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final skillsController = TextEditingController();
  PostCategory? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var lastPressed = DateTime.now();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: Colors.black),
        ),
        title: Text('New Post', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Title
                Text(
                  'Title',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                TextFormField(
                  controller: titleController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a title for your post!'
                      : null,
                  decoration: InputDecoration(
                    hintText: 'What do you need/offer?',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
                //Type
                SizedBox(height: 20),
                Text(
                  'Type',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                  textAlign: TextAlign.right,
                ),
                Row(
                  children: [
                    Expanded(child: _buildToggleButton('Request', isRequest)),
                    SizedBox(width: 12),
                    Expanded(child: _buildToggleButton('Offer', !isRequest)),
                  ],
                ),
                //Category
                SizedBox(height: 20),
                Text(
                  'Category',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),

                //drop out selection
                SizedBox(
                  child: DropdownMenu<PostCategory>(
                    width: double.infinity,
                    label: Text('Select a category'),
                    dropdownMenuEntries: PostCategory.values
                        .map(
                          (category) => DropdownMenuEntry(
                            value: category,
                            label: category.label,
                          ),
                        )
                        .toList(),
                    onSelected: (PostCategory? value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                ),

                //Description
                SizedBox(height: 20),
                Text(
                  'Description',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                //text box
                TextFormField(
                  maxLines: null,
                  minLines: 4,
                  controller: descriptionController,
                  validator: (value) => value == null || value.length <= 10
                      ? 'Please use at least 10 characters to describe your post!'
                      : null,
                  decoration: InputDecoration(
                    hintText: isRequest
                        ? 'Describe your request in detail...'
                        : 'Describe your offer in detail...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
                //Needed Skills
                SizedBox(height: 20),
                Text(
                  isRequest ? 'Needed Skills' : 'Offer Skills',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                //text box
                TextFormField(
                  maxLines: null,
                  minLines: 4,
                  controller: skillsController,
                  decoration: InputDecoration(
                    hintText: isRequest
                        ? 'List skills you need'
                        : 'List skills you offer',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
                //Location
                SizedBox(height: 20),
                Text(
                  'Location',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                TextFormField(
                  controller: locationController,
                  decoration: InputDecoration(
                    hintText: "e.g., 'Chandler, AZ'",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),

                //Exchange Requirement
                SizedBox(height: 20),
                Text(
                  'Exchange Requirements',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),

                TextFormField(
                  maxLines: null,
                  minLines: 4,
                  decoration: InputDecoration(
                    hintText: isRequest
                        ? 'Describe what you can offer in return...'
                        : 'Describe what you want to get in return',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 3, 127, 229),
            minimumSize: Size(double.infinity, 50),
          ),
          onPressed: () {
            final now = DateTime.now();
            if (now.difference(lastPressed) < const Duration(seconds: 2)) {
              return; // ignore spam tap
            }
            lastPressed = now;

            if (!formKey.currentState!.validate()) {
              // Show popup or snackbar if invalid
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please fix the errors before posting.'),
                ),
              );
              return;
            }

            final newPost = PostEntity(
              category: selectedCategory ?? PostCategory.other,
              title: titleController.text,
              description: descriptionController.text,
              authorId: "temp-user-id",
              authorName: "authorName",
              location: locationController.text,
              timestamp: DateTime.now(),
              isRequest: isRequest,
              neededSkills: skillsController.text.split(','),
            );

            context.read<PostsBloc>().add(CreateNewPostRequested(newPost));
            Navigator.pop(context);
          },
          child: Text(
            'Post',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isRequest = (text == 'Request');
        });
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 5, 130, 232)
              : Colors.blue[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: isSelected ? Colors.white : Colors.blue,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
