import 'package:cs222_final/features/posts/domain/entities/post_category.dart';
import 'package:flutter/material.dart';
import 'package:cs222_final/features/posts/domain/entities/post_entity.dart';
//Import claims bloc for checking if user has claimed post
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cs222_final/features/claims/presentation/bloc/claims_bloc.dart';
import 'package:cs222_final/features/claims/presentation/bloc/claims_event.dart';
import 'package:cs222_final/features/claims/presentation/bloc/claims_state.dart';
import 'package:cs222_final/features/claims/domain/entities/claim_entity.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback? onTap; // Tapping the whole card
  final VoidCallback? onProfileTap; // 1. ADD THIS VARIABLE
  final String username;
  final String currentUserId;

  // Removed "final isRequested = false" because StatelessWidgets cannot hold state like that.
  // You handled this correctly in the RequestButton class below anyway.

  const PostCard({
    super.key,
    required this.post,
    required this.username,
    required this.currentUserId,
    this.onTap,
    this.onProfileTap, // 2. FIX CONSTRUCTOR
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with author and post type
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: _buildAuthorInfo()),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(child: _buildPostCategoryBadge()),
                          const SizedBox(width: 4),
                          Flexible(child: _buildPostTypeBadge()),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Title
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 8),

                // Description
                if (post.description != null && post.description!.isNotEmpty)
                  Text(
                    post.description!,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                const SizedBox(height: 16),
                Text(
                  '${post.isRequest ? 'Skills Needed: ' : 'Skill Offered: '}${post.neededSkills.isEmpty ? 'None' : post.neededSkills.join(', ')}',
                ),

                const SizedBox(height: 16),
                Text(
                  'Location: ${post.location?.isNotEmpty ?? false ? post.location : 'N/A'}',
                ),

                if (this.username != post.authorName) ...[
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RequestButton(
                      postId: post.postId,
                      postTitle: post.title,
                      postAuthorId: post.authorId,
                      currentUserId: currentUserId,
                      currentUserName: username,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthorInfo() {
    // 3. WRAP THIS ROW IN GESTURE DETECTOR
    return GestureDetector(
      onTap: onProfileTap,
      behavior: HitTestBehavior
          .opaque, // Ensures the empty space between text/avatar is also clickable
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey.shade300,
            child: Text(
              post.authorName.isNotEmpty
                  ? post.authorName[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.authorName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _formatTimestamp(post.timestamp),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: post.isRequest ? Colors.blue.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: post.isRequest ? Colors.blue.shade200 : Colors.green.shade200,
          width: 1,
        ),
      ),
      child: Text(
        post.isRequest ? 'Request' : 'Offer',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: post.isRequest ? Colors.blue.shade700 : Colors.green.shade700,
        ),
      ),
    );
  }

  Widget _buildPostCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: post.category.color.withAlpha(70),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: post.category.color, width: 1),
      ),
      child: Text(
        post.category.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: post.category.color,
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class RequestButton extends StatefulWidget {
  const RequestButton({
    super.key,
    required this.postId,
    required this.postTitle,
    required this.postAuthorId,
    required this.currentUserId,
    required this.currentUserName,
  });

  final String postId;
  final String postTitle;
  final String postAuthorId;
  final String currentUserId;
  final String currentUserName;

  @override
  State<RequestButton> createState() => _RequestButtonState();
}

class _RequestButtonState extends State<RequestButton> {
  bool _isRequested = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkClaimStatus();
  }

  void _checkClaimStatus() {
    // Access the BLoC through context after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ClaimsBloc>().hasUserClaimedPost(
        widget.currentUserId,
        widget.postId,
      ).then((hasClaimed) {
        if (mounted) {
          setState(() {
            _isRequested = hasClaimed;
            _isLoading = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        width: 100,
        height: 36,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return BlocListener<ClaimsBloc, ClaimsState>(
      listener: (context, state) {
        if (state is ClaimCreated) {
          // Claim was successfully created
        }
      },
      child: ElevatedButton(
        onPressed: _isRequested
            ? null
            : () {
                final claim = ClaimEntity(
                  id: '${widget.currentUserId}_${widget.postId}',
                  postId: widget.postId,
                  postTitle: widget.postTitle,
                  claimerId: widget.currentUserId,
                  claimerName: widget.currentUserName,
                  postAuthorId: widget.postAuthorId,
                  timestamp: DateTime.now(),
                );
                context.read<ClaimsBloc>().add(CreateClaim(claim));
                setState(() => _isRequested = true);
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: _isRequested ? Colors.grey : Colors.red,
          foregroundColor: Colors.white,
        ),
        child: Text(_isRequested ? "REQUESTED" : "CLAIM"),
      ),
    );
  }
}
