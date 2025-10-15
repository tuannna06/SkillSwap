import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cs222_final/components/custom_app_bar.dart';
import 'package:cs222_final/features/profile/domain/entities/user_entity.dart';
import 'package:cs222_final/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:cs222_final/features/profile/presentation/bloc/profile_event.dart';
import 'package:cs222_final/features/profile/presentation/bloc/profile_state.dart';

class ProfilePage extends StatelessWidget {
  final String userId;

  const ProfilePage(Set<String> set, {super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Profile'),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileInitial) {
            context.read<ProfileBloc>().add(ProfileLoadRequested(userId));
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
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProfileBloc>().add(ProfileReloadRequested(userId));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              child: Icon(
                Icons.person_outline,
                size: 50,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 16),

            //User Name
            Text(
              user.name ?? "No name",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            //contact info
            _buildInfoCard('Contact Information', [
              _buildInfoRow(Icons.email, user.email ?? 'No Email'),
              _buildInfoRow(Icons.phone, user.phone ?? 'No Phone'),
              _buildInfoRow(Icons.location_on, user.address ?? 'No Address'),
            ]),
            const SizedBox(height: 16),

            //Skilss
            _buildInfoCard('Skills', [
              if (user.offeredSkills.isEmpty)
                const Text('No skill listed')
              else
                ...user.offeredSkills.map((skill) => Chip(label: Text(skill))),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ...children,
          ],
        ),
      ),
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
          Text(
            'Error: $message',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ProfileBloc>().add(ProfileRetryRequested(userId));
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
