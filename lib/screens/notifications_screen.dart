import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../models/notification_model.dart';
import '../providers/auth_provider.dart';
import '../services/supabase_service.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_message.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<AppNotification> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _subscribeToNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.currentUser != null) {
        final notifications = await SupabaseService.getNotifications(
          authProvider.currentUser!.id,
        );
        setState(() {
          _notifications = notifications;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load notifications: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _subscribeToNotifications() {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.currentUser != null) {
      SupabaseService.subscribeToNotifications(authProvider.currentUser!.id)
          .listen((notifications) {
        setState(() {
          _notifications = notifications;
        });
      });
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      await SupabaseService.markNotificationAsRead(notificationId);
      setState(() {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(isRead: true);
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to mark as read: ${e.toString()}'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.currentUser != null) {
        await SupabaseService.markAllNotificationsAsRead(
          authProvider.currentUser!.id,
        );
        setState(() {
          _notifications = _notifications
              .map((n) => n.copyWith(isRead: true))
              .toList();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to mark all as read: ${e.toString()}'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  Future<void> _deleteNotification(String notificationId) async {
    try {
      await SupabaseService.deleteNotification(notificationId);
      setState(() {
        _notifications.removeWhere((n) => n.id == notificationId);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete notification: ${e.toString()}'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  String _formatNotificationTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'message':
        return Icons.message;
      case 'booking':
        return Icons.calendar_today;
      case 'review':
        return Icons.star;
      case 'skill_update':
        return Icons.school;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'message':
        return AppTheme.primaryTeal;
      case 'booking':
        return AppTheme.warningYellow;
      case 'review':
        return AppTheme.warningYellow;
      case 'skill_update':
        return AppTheme.primaryTeal;
      case 'system':
        return AppTheme.textSecondary;
      default:
        return AppTheme.primaryTeal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please log in to view notifications'),
        ),
      );
    }

    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('Mark all read'),
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'settings') {
                // TODO: Navigate to notification settings
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: Text('Notification Settings'),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : _errorMessage != null
              ? ErrorMessage(
                  message: _errorMessage!,
                  onRetry: _loadNotifications,
                )
              : _notifications.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _loadNotifications,
                      child: _buildNotificationsList(),
                    ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: AppTheme.textSecondary,
          ),
          SizedBox(height: 24),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'You\'re all caught up!\nWe\'ll notify you when something happens.',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _buildNotificationTile(notification);
      },
    );
  }

  Widget _buildNotificationTile(AppNotification notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppTheme.errorRed,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        _deleteNotification(notification.id);
      },
      child: Container(
        color: notification.isRead ? null : AppTheme.primaryTeal.withOpacity(0.05),
        child: ListTile(
          leading: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification.type).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: _getNotificationColor(notification.type),
                  size: 20,
                ),
              ),
              if (!notification.isRead)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryTeal,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.message,
                style: TextStyle(
                  color: notification.isRead ? AppTheme.textSecondary : AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatNotificationTime(notification.createdAt),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          trailing: notification.isRead
              ? null
              : IconButton(
                  icon: const Icon(Icons.mark_email_read, size: 20),
                  onPressed: () => _markAsRead(notification.id),
                ),
          onTap: () {
            if (!notification.isRead) {
              _markAsRead(notification.id);
            }
            
            // Handle notification tap based on type
            if (notification.data != null) {
              final data = notification.data!;
              switch (notification.type) {
                case 'message':
                  if (data['conversationId'] != null) {
                    // Navigate to chat
                  }
                  break;
                case 'booking':
                  if (data['bookingId'] != null) {
                    // Navigate to booking details
                  }
                  break;
                case 'skill_update':
                  if (data['skillId'] != null) {
                    // Navigate to skill details
                  }
                  break;
              }
            }
          },
        ),
      ),
    );
  }
}

