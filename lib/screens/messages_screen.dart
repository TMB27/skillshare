import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/app_theme.dart';
import '../models/message_model.dart';
import '../providers/auth_provider.dart';
import '../services/supabase_service.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_message.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<ConversationWithUser> _conversations = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.currentUser != null) {
        final conversations = await SupabaseService.getConversations(
          authProvider.currentUser!.id,
        );
        setState(() {
          _conversations = conversations;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load conversations: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatLastMessageTime(DateTime? time) {
    if (time == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    if (difference.inDays < 7) return '${difference.inDays}d';
    return '${(difference.inDays / 7).floor()}w';
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please log in to view messages'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : _errorMessage != null
              ? ErrorMessage(
                  message: _errorMessage!,
                  onRetry: _loadConversations,
                )
              : _conversations.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: AppTheme.textSecondary,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No conversations yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Start a conversation by messaging a skill teacher!',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadConversations,
                      child: ListView.builder(
                        itemCount: _conversations.length,
                        itemBuilder: (context, index) {
                          final conversation = _conversations[index];
                          return _buildConversationTile(conversation);
                        },
                      ),
                    ),
    );
  }

  Widget _buildConversationTile(ConversationWithUser conversation) {
    final authProvider = context.read<AuthProvider>();
    final currentUserId = authProvider.currentUser!.id;
    final hasUnread = conversation.hasUnreadMessages(currentUserId);

    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: conversation.otherUserAvatarUrl != null
                ? CachedNetworkImageProvider(conversation.otherUserAvatarUrl!)
                : null,
            child: conversation.otherUserAvatarUrl == null
                ? const Icon(Icons.person)
                : null,
          ),
          if (conversation.otherUserIsOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppTheme.successGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              conversation.otherUserName,
              style: TextStyle(
                fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (conversation.lastMessageAt != null)
            Text(
              _formatLastMessageTime(conversation.lastMessageAt),
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
              ),
            ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              conversation.lastMessageContent ?? 'No messages yet',
              style: TextStyle(
                color: hasUnread ? AppTheme.textPrimary : AppTheme.textSecondary,
                fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (hasUnread)
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: const BoxDecoration(
                color: AppTheme.primaryTeal,
                shape: BoxShape.circle,
              ),
              child: Text(
                conversation.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        context.push(
          '/chat/${conversation.id}?userName=${Uri.encodeComponent(conversation.otherUserName)}',
        );
      },
    );
  }
}

