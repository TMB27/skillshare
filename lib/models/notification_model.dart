class AppNotification {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String message;
  final Map<String, dynamic>? data;
  final String? actionUrl;
  final String? imageUrl;
  final bool isRead;
  final DateTime? readAt;
  final String priority;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.data,
    this.actionUrl,
    this.imageUrl,
    this.isRead = false,
    this.readAt,
    this.priority = 'normal',
    required this.createdAt,
    required this.updatedAt,
  });

  String get typeDisplay {
    switch (type.toLowerCase()) {
      case 'booking_confirmed':
        return 'Booking Confirmed';
      case 'booking_cancelled':
        return 'Booking Cancelled';
      case 'booking_reminder':
        return 'Booking Reminder';
      case 'new_message':
        return 'New Message';
      case 'skill_review':
        return 'New Review';
      case 'skill_favorite':
        return 'Skill Favorited';
      case 'profile_view':
        return 'Profile View';
      case 'system_update':
        return 'System Update';
      case 'payment_received':
        return 'Payment Received';
      case 'payment_failed':
        return 'Payment Failed';
      default:
        return type;
    }
  }

  String get priorityDisplay {
    switch (priority.toLowerCase()) {
      case 'low':
        return 'Low';
      case 'normal':
        return 'Normal';
      case 'high':
        return 'High';
      case 'urgent':
        return 'Urgent';
      default:
        return priority;
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    if (difference.inDays < 30) return '${(difference.inDays / 7).floor()}w ago';
    if (difference.inDays < 365) return '${(difference.inDays / 30).floor()}mo ago';
    return '${(difference.inDays / 365).floor()}y ago';
  }

  bool get isHighPriority {
    return ['high', 'urgent'].contains(priority.toLowerCase());
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>?,
      actionUrl: json['action_url'] as String?,
      imageUrl: json['image_url'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
      priority: json['priority'] as String? ?? 'normal',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'title': title,
      'message': message,
      'data': data,
      'action_url': actionUrl,
      'image_url': imageUrl,
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
      'priority': priority,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  AppNotification copyWith({
    String? type,
    String? title,
    String? message,
    Map<String, dynamic>? data,
    String? actionUrl,
    String? imageUrl,
    bool? isRead,
    DateTime? readAt,
    String? priority,
    DateTime? updatedAt,
  }) {
    return AppNotification(
      id: id,
      userId: userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      data: data ?? this.data,
      actionUrl: actionUrl ?? this.actionUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      priority: priority ?? this.priority,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class NotificationSettings {
  final String userId;
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool bookingNotifications;
  final bool messageNotifications;
  final bool reviewNotifications;
  final bool marketingNotifications;
  final bool systemNotifications;
  final String quietHoursStart;
  final String quietHoursEnd;
  final List<String> mutedUsers;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationSettings({
    required this.userId,
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.smsNotifications = false,
    this.bookingNotifications = true,
    this.messageNotifications = true,
    this.reviewNotifications = true,
    this.marketingNotifications = false,
    this.systemNotifications = true,
    this.quietHoursStart = '22:00',
    this.quietHoursEnd = '08:00',
    this.mutedUsers = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  bool isInQuietHours() {
    final now = DateTime.now();
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    
    // Simple time comparison (doesn't handle overnight quiet hours properly)
    return currentTime.compareTo(quietHoursStart) >= 0 && 
           currentTime.compareTo(quietHoursEnd) <= 0;
  }

  bool isUserMuted(String userId) {
    return mutedUsers.contains(userId);
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      userId: json['user_id'] as String,
      pushNotifications: json['push_notifications'] as bool? ?? true,
      emailNotifications: json['email_notifications'] as bool? ?? true,
      smsNotifications: json['sms_notifications'] as bool? ?? false,
      bookingNotifications: json['booking_notifications'] as bool? ?? true,
      messageNotifications: json['message_notifications'] as bool? ?? true,
      reviewNotifications: json['review_notifications'] as bool? ?? true,
      marketingNotifications: json['marketing_notifications'] as bool? ?? false,
      systemNotifications: json['system_notifications'] as bool? ?? true,
      quietHoursStart: json['quiet_hours_start'] as String? ?? '22:00',
      quietHoursEnd: json['quiet_hours_end'] as String? ?? '08:00',
      mutedUsers: json['muted_users'] != null
          ? List<String>.from(json['muted_users'] as List)
          : [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'push_notifications': pushNotifications,
      'email_notifications': emailNotifications,
      'sms_notifications': smsNotifications,
      'booking_notifications': bookingNotifications,
      'message_notifications': messageNotifications,
      'review_notifications': reviewNotifications,
      'marketing_notifications': marketingNotifications,
      'system_notifications': systemNotifications,
      'quiet_hours_start': quietHoursStart,
      'quiet_hours_end': quietHoursEnd,
      'muted_users': mutedUsers,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  NotificationSettings copyWith({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? smsNotifications,
    bool? bookingNotifications,
    bool? messageNotifications,
    bool? reviewNotifications,
    bool? marketingNotifications,
    bool? systemNotifications,
    String? quietHoursStart,
    String? quietHoursEnd,
    List<String>? mutedUsers,
    DateTime? updatedAt,
  }) {
    return NotificationSettings(
      userId: userId,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      bookingNotifications: bookingNotifications ?? this.bookingNotifications,
      messageNotifications: messageNotifications ?? this.messageNotifications,
      reviewNotifications: reviewNotifications ?? this.reviewNotifications,
      marketingNotifications: marketingNotifications ?? this.marketingNotifications,
      systemNotifications: systemNotifications ?? this.systemNotifications,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      mutedUsers: mutedUsers ?? this.mutedUsers,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

