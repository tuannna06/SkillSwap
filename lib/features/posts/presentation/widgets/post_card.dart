import 'package:cs222_final/features/posts/domain/entities/post_category.dart';
import 'package:flutter/material.dart';
import 'package:cs222_final/features/posts/domain/entities/post_entity.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback? onTap; // Tapping the whole card
  final VoidCallback? onProfileTap; // 1. ADD THIS VARIABLE
  final String username;

  // Removed "final isRequested = false" because StatelessWidgets cannot hold state like that.
  // You handled this correctly in the RequestButton class below anyway.

  const PostCard({
    super.key,
    required this.post,
    required this.username,
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
                  const Align(
                    alignment: Alignment.centerRight,
                    child: RequestButton(),
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
  const RequestButton({super.key});

  @override
  State<RequestButton> createState() => _RequestButtonState();
}

class _RequestButtonState extends State<RequestButton> {
  bool isRequested = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isRequested = true;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isRequested ? Colors.grey : Colors.red,
        foregroundColor: Colors.white,
      ),
      child: Text(isRequested ? "REQUESTED" : "CLAIM"),
    );
  }
}
