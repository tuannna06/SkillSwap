import 'package:cs222_final/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cs222_final/components/custom_app_bar.dart';
import 'package:cs222_final/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:cs222_final/features/auth/presentation/bloc/auth_event.dart';
import 'package:cs222_final/features/profile/domain/entities/user_entity.dart';
import 'package:cs222_final/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:cs222_final/features/profile/presentation/bloc/profile_event.dart';
import 'package:cs222_final/features/profile/presentation/bloc/profile_state.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  // CORRECT
  const ProfilePage({super.key, required this.userId}); 

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;

  // Controllers for editable fields
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final skillController = TextEditingController();
  final List<String> skills = [];

  @override
  void dispose() {
    phoneController.dispose();
    addressController.dispose();
    skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Profile'),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            phoneController.text = state.user.phone ?? '';
            addressController.text = state.user.address ?? '';
            skills
              ..clear()
              ..addAll(state.user.offeredSkills);
          }
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileInitial) {
            context.read<ProfileBloc>().add(ProfileLoadRequested(widget.userId));
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileLoaded) {
            return _buildProfileContent(context, state.user);
          }
          if (state is ProfileError) {
            return _buildErrorWidget(context, state.message);
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserEntity user) {
    // 1. GET CURRENT USER ID from AuthBloc
    final authState = context.read<AuthBloc>().state;
    String? currentUserId;
    if (authState is Authenticated) {
      currentUserId = authState.user.uid; // Assuming 'uid' is your ID field in AuthUser
    }
    
    // 2. CHECK IF THIS IS MY PROFILE
    final bool isOwnProfile = currentUserId == widget.userId;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProfileBloc>().add(ProfileReloadRequested(user.id));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.person_outline, size: 50, color: Colors.blue.shade700),
            ),
            const SizedBox(height: 16),

            // Name
            Text(
              user.name ?? "No name",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 3. ONLY SHOW EDIT BUTTON IF IS OWN PROFILE
            if (isOwnProfile) 
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: Icon(isEditing ? Icons.cancel : Icons.edit),
                  label: Text(isEditing ? "Cancel" : "Edit"),
                  onPressed: () {
                    setState(() => isEditing = !isEditing);
                  },
                ),
              ),

            const SizedBox(height: 8),

            // Pass isOwnProfile down if you want extra safety in the widget
            _buildEditableInfo(context, user), 
            
            const SizedBox(height: 24),

            // 4. ONLY SHOW SIGN OUT BUTTON IF IS OWN PROFILE
            if (isOwnProfile)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(SignOutRequested());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Sign Out', style: TextStyle(fontSize: 16)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableInfo(BuildContext context, UserEntity user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Contact Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          isEditing
              ? Column(
                  children: [
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(Icons.phone, user.phone ?? 'No phone'),
                    _buildInfoRow(Icons.location_on, user.address ?? 'No address'),
                  ],
                ),
          const SizedBox(height: 16),

          // Skills
          const Text('Skills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          isEditing ? _buildEditableSkillsSection() : _buildSkillChips(),

          if (isEditing) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final updates = {
                    'phone': phoneController.text,
                    'address': addressController.text,
                    'offeredSkills': skills,
                  };
                  context.read<ProfileBloc>().add(UpdateUserRequested(widget.userId, updates));
                  setState(() => isEditing = false);
                },
                icon: const Icon(Icons.save),
                label: const Text('Save Changes'),
              ),
            ),
          ],
        ]),
      ),
    );
  }

  Widget _buildSkillChips() {
    if (skills.isEmpty) {
      return const Text('No skills listed');
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map((s) => Chip(label: Text(s))).toList(),
    );
  }

  Widget _buildEditableSkillsSection() {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills
              .map((skill) => Chip(
                    label: Text(skill),
                    onDeleted: () {
                      setState(() => skills.remove(skill));
                    },
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: skillController,
                decoration: const InputDecoration(
                  labelText: 'Add a skill',
                  prefixIcon: Icon(Icons.add),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              onPressed: () {
                final newSkill = skillController.text.trim();
                if (newSkill.isNotEmpty) {
                  setState(() {
                    skills.add(newSkill);
                    skillController.clear();
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
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
          Text('Error: $message', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ProfileBloc>().add(ProfileRetryRequested(widget.userId));
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}