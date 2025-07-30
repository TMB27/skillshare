import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/user_model.dart';
import '../models/skill_model.dart';
import '../models/booking_model.dart';
import '../models/message_model.dart';
import '../models/review_model.dart';
import '../models/notification_model.dart';

class SupabaseService {
  static SupabaseClient? _client;
  
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase not initialized. Call initialize() first.');
    }
    return _client!;
  }

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
    _client = Supabase.instance.client;
  }

  // Auth Methods
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,
    String? location,
  }) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'location': location,
      },
    );
    return response;
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }

  static User? get currentUser => client.auth.currentUser;
  static String? get currentUserId => client.auth.currentUser?.id;

  // User Profile Methods
  static Future<UserProfile?> getUserProfile(String userId) async {
    final response = await client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    
    return UserProfile.fromJson(response);
  }

  static Future<UserProfile> updateUserProfile(UserProfile profile) async {
    final response = await client
        .from('profiles')
        .update(profile.toJson())
        .eq('id', profile.id)
        .select()
        .single();
    
    return UserProfile.fromJson(response);
  }

  static Future<String?> uploadAvatar(String userId, String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      
      await client.storage
          .from('avatars')
          .uploadBinary('$userId/avatar.jpg', bytes);
      
      return client.storage.from('avatars').getPublicUrl('$userId/avatar.jpg');
    } catch (e) {
      return null;
    }
  }

  // Skills Methods
  static Future<List<SkillWithUser>> searchSkills({
    String? searchQuery,
    String? category,
    String? location,
    double? minPrice,
    double? maxPrice,
    String? experienceLevel,
    String? skillType,
    int limit = 20,
    int offset = 0,
  }) async {
    PostgrestFilterBuilder query = client
        .from('skills')
        .select('''
          *,
          profiles!skills_user_id_fkey(
            id,
            username,
            first_name,
            last_name,
            avatar_url,
            rating,
            total_reviews
          )
        ''')
        .eq('is_active', true);

    if (category != null) {
      query = query.eq('category', category);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.or('title.ilike.%$searchQuery%,description.ilike.%$searchQuery%');
    }

    if (location != null) {
      query = query.ilike('location', '%$location%');
    }

    if (minPrice != null) {
      query = query.gte('price_amount', minPrice);
    }

    if (maxPrice != null) {
      query = query.lte('price_amount', maxPrice);
    }

    if (experienceLevel != null) {
      query = query.eq('experience_level', experienceLevel);
    }

    if (skillType != null) {
      query = query.eq('skill_type', skillType);
    }

    final response = await query
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);
        
    return response.map<SkillWithUser>((json) => SkillWithUser.fromJson(json)).toList();
  }

  static Future<SkillWithUser?> getSkillById(String skillId) async {
    final response = await client
        .from('skills_with_users')
        .select()
        .eq('id', skillId)
        .single();
    
    return SkillWithUser.fromJson(response);
  }

  static Future<Skill> createSkill(Skill skill) async {
    final response = await client
        .from('skills')
        .insert(skill.toJson())
        .select()
        .single();
    
    return Skill.fromJson(response);
  }

  static Future<Skill> updateSkill(Skill skill) async {
    final response = await client
        .from('skills')
        .update(skill.toJson())
        .eq('id', skill.id)
        .select()
        .single();
    
    return Skill.fromJson(response);
  }

  static Future<void> deleteSkill(String skillId) async {
    await client
        .from('skills')
        .delete()
        .eq('id', skillId);
  }

  static Future<List<Skill>> getUserSkills(String userId) async {
    final response = await client
        .from('skills')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    
    return response.map<Skill>((json) => Skill.fromJson(json)).toList();
  }

  static Future<String?> uploadSkillImage(String skillId, String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      final fileName = '$skillId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      await client.storage
          .from('skill_images')
          .uploadBinary(fileName, bytes);
      
      return client.storage.from('skill_images').getPublicUrl(fileName);
    } catch (e) {
      return null;
    }
  }

  // Bookings Methods
  static Future<Booking> createBooking(Booking booking) async {
    final response = await client
        .from('bookings')
        .insert(booking.toJson())
        .select()
        .single();
    
    return Booking.fromJson(response);
  }

  static Future<List<BookingWithDetails>> getUserBookings(String userId) async {
    final response = await client
        .from('bookings_with_details')
        .select()
        .or('student_id.eq.$userId,teacher_id.eq.$userId')
        .order('scheduled_date', ascending: false);
    
    return response.map<BookingWithDetails>((json) => BookingWithDetails.fromJson(json)).toList();
  }

  static Future<Booking> updateBooking(Booking booking) async {
    final response = await client
        .from('bookings')
        .update(booking.toJson())
        .eq('id', booking.id)
        .select()
        .single();
    
    return Booking.fromJson(response);
  }

  static Future<void> cancelBooking(String bookingId, String reason) async {
    await client
        .from('bookings')
        .update({
          'status': 'cancelled',
          'cancellation_reason': reason,
          'cancelled_at': DateTime.now().toIso8601String(),
          'cancelled_by': currentUserId,
        })
        .eq('id', bookingId);
  }

  // Additional booking methods
  static Future<Booking?> getBookingById(String bookingId) async {
    try {
      final response = await client
          .from('bookings')
          .select()
          .eq('id', bookingId)
          .single();
      
      return Booking.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  static Future<void> updateBookingStatus(String bookingId, String status) async {
    await client
        .from('bookings')
        .update({
          'status': status,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', bookingId);
  }

  static Future<List<Booking>> getBookingsAsStudent(String studentId) async {
    final response = await client
        .from('bookings')
        .select()
        .eq('learner_id', studentId)
        .order('scheduled_date', ascending: false);
    
    return response.map<Booking>((json) => Booking.fromJson(json)).toList();
  }

  static Future<List<Booking>> getBookingsAsTeacher(String teacherId) async {
    final response = await client
        .from('bookings')
        .select()
        .eq('teacher_id', teacherId)
        .order('scheduled_date', ascending: false);
    
    return response.map<Booking>((json) => Booking.fromJson(json)).toList();
  }

  // Messages Methods
  static Future<List<ConversationWithUser>> getConversations(String userId) async {
    final response = await client
        .from('conversations_with_users')
        .select()
        .or('participant1_id.eq.$userId,participant2_id.eq.$userId')
        .eq('is_active', true)
        .order('last_message_at', ascending: false);
    
    return response.map<ConversationWithUser>((json) => ConversationWithUser.fromJson(json)).toList();
  }

  static Future<List<Message>> getMessages(String conversationId, {int limit = 50}) async {
    final response = await client
        .from('messages')
        .select()
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: false)
        .limit(limit);
    
    return response.map<Message>((json) => Message.fromJson(json)).toList();
  }

  static Future<Message> sendMessage(Message message) async {
    final response = await client
        .from('messages')
        .insert(message.toJson())
        .select()
        .single();
    
    return Message.fromJson(response);
  }

  static Future<void> markMessageAsRead(String messageId) async {
    await client
        .from('messages')
        .update({
          'is_read': true,
          'read_at': DateTime.now().toIso8601String(),
        })
        .eq('id', messageId);
  }

  static Stream<List<Message>> subscribeToMessages(String conversationId) {
    return client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at')
        .map((data) => data.map<Message>((json) => Message.fromJson(json)).toList());
  }

  // Reviews Methods
  static Future<List<ReviewWithUser>> getSkillReviews(String skillId) async {
    final response = await client
        .from('reviews_with_users')
        .select()
        .eq('skill_id', skillId)
        .eq('is_public', true)
        .order('created_at', ascending: false);
    
    return response.map<ReviewWithUser>((json) => ReviewWithUser.fromJson(json)).toList();
  }

  static Future<Review> createReview(Review review) async {
    final response = await client
        .from('reviews')
        .insert(review.toJson())
        .select()
        .single();
    
    return Review.fromJson(response);
  }

  static Future<ReviewSummary?> getReviewSummary(String skillId) async {
    final response = await client
        .rpc('get_review_summary', params: {'skill_id_param': skillId});
    
    if (response != null) {
      return ReviewSummary.fromJson(response);
    }
    return null;
  }

  // Notifications Methods
  static Future<List<AppNotification>> getNotifications(String userId) async {
    final response = await client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(50);
    
    return response.map<AppNotification>((json) => AppNotification.fromJson(json)).toList();
  }

  static Future<void> markNotificationAsRead(String notificationId) async {
    await client
        .from('notifications')
        .update({
          'is_read': true,
          'read_at': DateTime.now().toIso8601String(),
        })
        .eq('id', notificationId);
  }

  static Future<void> markAllNotificationsAsRead(String userId) async {
    await client
        .from('notifications')
        .update({
          'is_read': true,
          'read_at': DateTime.now().toIso8601String(),
        })
        .eq('user_id', userId)
        .eq('is_read', false);
  }

  static Future<void> deleteNotification(String notificationId) async {
    await client
        .from('notifications')
        .delete()
        .eq('id', notificationId);
  }

  static Future<int> getUnreadNotificationCount(String userId) async {
    final response = await client
        .from('notifications')
        .select('id')
        .eq('user_id', userId)
        .eq('is_read', false);
    
    return response.length;
  }

  // Favorites Methods
  static Future<void> addToFavorites(String userId, String skillId) async {
    await client
        .from('favorites')
        .insert({
          'user_id': userId,
          'skill_id': skillId,
        });
  }

  static Future<void> removeFromFavorites(String userId, String skillId) async {
    await client
        .from('favorites')
        .delete()
        .eq('user_id', userId)
        .eq('skill_id', skillId);
  }

  static Future<List<SkillWithUser>> getFavoriteSkills(String userId) async {
    final response = await client
        .from('favorites')
        .select('skills_with_users(*)')
        .eq('user_id', userId);
    
    return response.map<SkillWithUser>((json) => SkillWithUser.fromJson(json['skills_with_users'])).toList();
  }

  static Future<bool> isSkillFavorited(String userId, String skillId) async {
    final response = await client
        .from('favorites')
        .select('id')
        .eq('user_id', userId)
        .eq('skill_id', skillId)
        .maybeSingle();
    
    return response != null;
  }

  // Categories Methods
  static Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await client
        .from('categories')
        .select()
        .eq('is_active', true)
        .order('name');
    
    return response;
  }

  static Future<List<Map<String, dynamic>>> getSubcategories(String categoryId) async {
    final response = await client
        .from('subcategories')
        .select()
        .eq('category_id', categoryId)
        .eq('is_active', true)
        .order('name');
    
    return response;
  }

  // Search Methods - Simple text search
  static Future<List<SkillWithUser>> searchSkillsByText(String query) async {
    final response = await client
        .from('skills')
        .select('''
          *,
          profiles!skills_user_id_fkey(
            id,
            username,
            first_name,
            last_name,
            avatar_url,
            rating,
            total_reviews
          )
        ''')
        .or('title.ilike.%$query%,description.ilike.%$query%')
        .eq('is_active', true)
        .order('rating', ascending: false)
        .limit(20);
    
    return response.map<SkillWithUser>((json) => SkillWithUser.fromJson(json)).toList();
  }

  static Future<List<UserProfile>> searchUsers(String query) async {
    final response = await client
        .from('user_profiles')
        .select()
        .or('username.ilike.%$query%,first_name.ilike.%$query%,last_name.ilike.%$query%')
        .eq('is_active', true)
        .order('rating', ascending: false)
        .limit(20);
    
    return response.map<UserProfile>((json) => UserProfile.fromJson(json)).toList();
  }

  // Analytics Methods
  static Future<Map<String, dynamic>> getDashboardStats(String userId) async {
    final response = await client
        .rpc('get_user_dashboard_stats', params: {'user_id_param': userId});
    
    return response ?? {};
  }

  static Future<void> incrementSkillViews(String skillId) async {
    await client
        .rpc('increment_skill_views', params: {'skill_id_param': skillId});
  }

  // Real-time subscriptions
  static Stream<List<AppNotification>> subscribeToNotifications(String userId) {
    return client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data.map<AppNotification>((json) => AppNotification.fromJson(json)).toList());
  }

  static Stream<List<ConversationWithUser>> subscribeToConversations(String userId) {
    return client
        .from('conversations_with_users')
        .stream(primaryKey: ['id'])
        .eq('participant1_id', userId)
        .order('last_message_at', ascending: false)
        .map((data) => data.map<ConversationWithUser>((json) => ConversationWithUser.fromJson(json)).toList());
  }
}

