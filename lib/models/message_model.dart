class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String receiverId;
  final String content;
  final String messageType;
  final String? attachmentUrl;
  final String? attachmentType;
  final bool isRead;
  final DateTime? readAt;
  final bool isDelivered;
  final DateTime? deliveredAt;
  final String? replyToMessageId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.messageType = 'text',
    this.attachmentUrl,
    this.attachmentType,
    this.isRead = false,
    this.readAt,
    this.isDelivered = false,
    this.deliveredAt,
    this.replyToMessageId,
    required this.createdAt,
    required this.updatedAt,
  });

  String get messageTypeDisplay {
    switch (messageType.toLowerCase()) {
      case 'text':
        return 'Text';
      case 'image':
        return 'Image';
      case 'file':
        return 'File';
      case 'audio':
        return 'Audio';
      case 'video':
        return 'Video';
      case 'location':
        return 'Location';
      default:
        return messageType;
    }
  }

  bool get hasAttachment {
    return attachmentUrl != null && attachmentUrl!.isNotEmpty;
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      content: json['content'] as String,
      messageType: json['message_type'] as String? ?? 'text',
      attachmentUrl: json['attachment_url'] as String?,
      attachmentType: json['attachment_type'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
      isDelivered: json['is_delivered'] as bool? ?? false,
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'] as String)
          : null,
      replyToMessageId: json['reply_to_message_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'message_type': messageType,
      'attachment_url': attachmentUrl,
      'attachment_type': attachmentType,
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
      'is_delivered': isDelivered,
      'delivered_at': deliveredAt?.toIso8601String(),
      'reply_to_message_id': replyToMessageId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Message copyWith({
    String? content,
    String? messageType,
    String? attachmentUrl,
    String? attachmentType,
    bool? isRead,
    DateTime? readAt,
    bool? isDelivered,
    DateTime? deliveredAt,
    String? replyToMessageId,
    DateTime? updatedAt,
  }) {
    return Message(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      receiverId: receiverId,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      attachmentType: attachmentType ?? this.attachmentType,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      isDelivered: isDelivered ?? this.isDelivered,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class Conversation {
  final String id;
  final String participant1Id;
  final String participant2Id;
  final String? lastMessageId;
  final String? lastMessageContent;
  final DateTime? lastMessageAt;
  final String? lastMessageSenderId;
  final int unreadCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.participant1Id,
    required this.participant2Id,
    this.lastMessageId,
    this.lastMessageContent,
    this.lastMessageAt,
    this.lastMessageSenderId,
    this.unreadCount = 0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  String getOtherParticipantId(String currentUserId) {
    return participant1Id == currentUserId ? participant2Id : participant1Id;
  }

  bool hasUnreadMessages(String currentUserId) {
    return unreadCount > 0 && lastMessageSenderId != currentUserId;
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      participant1Id: json['participant1_id'] as String,
      participant2Id: json['participant2_id'] as String,
      lastMessageId: json['last_message_id'] as String?,
      lastMessageContent: json['last_message_content'] as String?,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      lastMessageSenderId: json['last_message_sender_id'] as String?,
      unreadCount: json['unread_count'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participant1_id': participant1Id,
      'participant2_id': participant2Id,
      'last_message_id': lastMessageId,
      'last_message_content': lastMessageContent,
      'last_message_at': lastMessageAt?.toIso8601String(),
      'last_message_sender_id': lastMessageSenderId,
      'unread_count': unreadCount,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Conversation copyWith({
    String? lastMessageId,
    String? lastMessageContent,
    DateTime? lastMessageAt,
    String? lastMessageSenderId,
    int? unreadCount,
    bool? isActive,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id,
      participant1Id: participant1Id,
      participant2Id: participant2Id,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessageContent: lastMessageContent ?? this.lastMessageContent,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      unreadCount: unreadCount ?? this.unreadCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class ConversationWithUser extends Conversation {
  final String otherUserName;
  final String? otherUserAvatarUrl;
  final bool otherUserIsOnline;
  final DateTime? otherUserLastSeen;

  ConversationWithUser({
    required super.id,
    required super.participant1Id,
    required super.participant2Id,
    super.lastMessageId,
    super.lastMessageContent,
    super.lastMessageAt,
    super.lastMessageSenderId,
    super.unreadCount = 0,
    super.isActive = true,
    required super.createdAt,
    required super.updatedAt,
    required this.otherUserName,
    this.otherUserAvatarUrl,
    this.otherUserIsOnline = false,
    this.otherUserLastSeen,
  });

  String get onlineStatus {
    if (otherUserIsOnline) return 'Online';
    if (otherUserLastSeen == null) return 'Offline';
    
    final now = DateTime.now();
    final difference = now.difference(otherUserLastSeen!);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return 'Last seen ${difference.inDays}d ago';
  }

  factory ConversationWithUser.fromJson(Map<String, dynamic> json) {
    return ConversationWithUser(
      id: json['id'] as String,
      participant1Id: json['participant1_id'] as String,
      participant2Id: json['participant2_id'] as String,
      lastMessageId: json['last_message_id'] as String?,
      lastMessageContent: json['last_message_content'] as String?,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      lastMessageSenderId: json['last_message_sender_id'] as String?,
      unreadCount: json['unread_count'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      otherUserName: json['other_user_name'] as String,
      otherUserAvatarUrl: json['other_user_avatar_url'] as String?,
      otherUserIsOnline: json['other_user_is_online'] as bool? ?? false,
      otherUserLastSeen: json['other_user_last_seen'] != null
          ? DateTime.parse(json['other_user_last_seen'] as String)
          : null,
    );
  }
}

