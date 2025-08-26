class Booking {
  final String id;
  final String skillId;
  final String studentId;
  final String teacherId;
  final DateTime scheduledDate;
  final String timeSlot;
  final int duration;
  final String location;
  final String locationType;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String status;
  final double? totalAmount;
  final String? currency;
  final String? paymentStatus;
  final String? paymentMethod;
  final String? specialRequests;
  final String? notes;
  final String? cancellationReason;
  final DateTime? cancelledAt;
  final String? cancelledBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Additional fields for UI display
  final String? skillTitle;
  final String? skillDescription;
  final String? skillImageUrl;
  final String? teacherName;
  final String? teacherAvatarUrl;
  final String? studentName;
  final String? studentAvatarUrl;

  Booking({
    required this.id,
    required this.skillId,
    required this.studentId,
    required this.teacherId,
    required this.scheduledDate,
    required this.timeSlot,
    required this.duration,
    required this.location,
    required this.locationType,
    this.address,
    this.latitude,
    this.longitude,
    required this.status,
    this.totalAmount,
    this.currency,
    this.paymentStatus,
    this.paymentMethod,
    this.specialRequests,
    this.notes,
    this.cancellationReason,
    this.cancelledAt,
    this.cancelledBy,
    required this.createdAt,
    required this.updatedAt,
    this.skillTitle,
    this.skillDescription,
    this.skillImageUrl,
    this.teacherName,
    this.teacherAvatarUrl,
    this.studentName,
    this.studentAvatarUrl,
  });

  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending Confirmation';
      case 'confirmed':
        return 'Confirmed';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'no_show':
        return 'No Show';
      default:
        return status;
    }
  }

  String get formattedAmount {
    if (totalAmount == null) return 'Free';
    return '\$${totalAmount!.toStringAsFixed(2)}';
  }

  bool get canBeCancelled {
    return ['pending', 'confirmed'].contains(status.toLowerCase()) &&
        scheduledDate.isAfter(DateTime.now().add(const Duration(hours: 24)));
  }

  bool get canBeRescheduled {
    return ['pending', 'confirmed'].contains(status.toLowerCase()) &&
        scheduledDate.isAfter(DateTime.now().add(const Duration(hours: 2)));
  }

  // Additional getters for UI compatibility
  String get bookingDate =>
      '${scheduledDate.day}/${scheduledDate.month}/${scheduledDate.year}';
  String get bookingTime => timeSlot;

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      skillId: json['skill_id'] as String,
      studentId: json['learner_id'] as String, // Updated field name
      teacherId: json['teacher_id'] as String,
      scheduledDate: DateTime.parse(json['scheduled_date'] as String),
      timeSlot: json['time_slot'] as String,
      duration: json['duration'] as int,
      location: json['location'] as String,
      locationType: json['location_type'] as String,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: json['status'] as String,
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      paymentStatus: json['payment_status'] as String?,
      paymentMethod: json['payment_method'] as String?,
      specialRequests: json['special_requests'] as String?,
      notes: json['notes'] as String?,
      cancellationReason: json['cancellation_reason'] as String?,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'] as String)
          : null,
      cancelledBy: json['cancelled_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'skill_id': skillId,
      'learner_id': studentId,
      'teacher_id': teacherId,
      'scheduled_date': scheduledDate.toIso8601String(),
      'time_slot': timeSlot,
      'duration': duration,
      'location': location,
      'location_type': locationType,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'total_amount': totalAmount,
      'currency': currency,
      'payment_status': paymentStatus,
      'payment_method': paymentMethod,
      'special_requests': specialRequests,
      'notes': notes,
      'cancellation_reason': cancellationReason,
      'cancelled_at': cancelledAt?.toIso8601String(),
      'cancelled_by': cancelledBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Booking copyWith({
    String? status,
    DateTime? scheduledDate,
    String? timeSlot,
    int? duration,
    String? location,
    String? locationType,
    String? address,
    double? latitude,
    double? longitude,
    double? totalAmount,
    String? currency,
    String? paymentStatus,
    String? paymentMethod,
    String? specialRequests,
    String? notes,
    String? cancellationReason,
    DateTime? cancelledAt,
    String? cancelledBy,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id,
      skillId: skillId,
      studentId: studentId,
      teacherId: teacherId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      timeSlot: timeSlot ?? this.timeSlot,
      duration: duration ?? this.duration,
      location: location ?? this.location,
      locationType: locationType ?? this.locationType,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      specialRequests: specialRequests ?? this.specialRequests,
      notes: notes ?? this.notes,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancelledBy: cancelledBy ?? this.cancelledBy,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class BookingWithDetails extends Booking {
  @override
  final String skillTitle;
  final String skillCategory;
  @override
  final String? skillImageUrl;
  @override
  final String teacherName;
  @override
  final String? teacherAvatarUrl;
  @override
  final String studentName;
  @override
  final String? studentAvatarUrl;

  BookingWithDetails({
    required super.id,
    required super.skillId,
    required super.studentId,
    required super.teacherId,
    required super.scheduledDate,
    required super.timeSlot,
    required super.duration,
    required super.location,
    required super.locationType,
    super.address,
    super.latitude,
    super.longitude,
    required super.status,
    super.totalAmount,
    super.currency,
    super.paymentStatus,
    super.paymentMethod,
    super.specialRequests,
    super.notes,
    super.cancellationReason,
    super.cancelledAt,
    super.cancelledBy,
    required super.createdAt,
    required super.updatedAt,
    required this.skillTitle,
    required this.skillCategory,
    this.skillImageUrl,
    required this.teacherName,
    this.teacherAvatarUrl,
    required this.studentName,
    this.studentAvatarUrl,
  });

  factory BookingWithDetails.fromJson(Map<String, dynamic> json) {
    return BookingWithDetails(
      id: json['id'] as String,
      skillId: json['skill_id'] as String,
      studentId: json['learner_id'] as String,
      teacherId: json['teacher_id'] as String,
      scheduledDate: DateTime.parse(json['scheduled_date'] as String),
      timeSlot: json['time_slot'] as String,
      duration: json['duration'] as int,
      location: json['location'] as String,
      locationType: json['location_type'] as String,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: json['status'] as String,
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      paymentStatus: json['payment_status'] as String?,
      paymentMethod: json['payment_method'] as String?,
      specialRequests: json['special_requests'] as String?,
      notes: json['notes'] as String?,
      cancellationReason: json['cancellation_reason'] as String?,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'] as String)
          : null,
      cancelledBy: json['cancelled_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      skillTitle: json['skill_title'] as String? ?? 'Unknown Skill',
      skillCategory: json['skill_category'] as String? ?? 'General',
      skillImageUrl: json['skill_image_url'] as String?,
      teacherName: json['teacher_name'] as String? ?? 'Unknown Teacher',
      teacherAvatarUrl: json['teacher_avatar_url'] as String?,
      studentName: json['student_name'] as String? ?? 'Unknown Student',
      studentAvatarUrl: json['student_avatar_url'] as String?,
    );
  }
}
