class Skill {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String category;
  final String? subcategory;
  final String experienceLevel;
  final String skillType;
  final String availability;
  final int? durationPerSession;
  final int maxParticipants;
  final String priceType;
  final double? priceAmount;
  final String priceCurrency;
  final String location;
  final String? locationType;
  final String? address;
  final double? latitude;
  final double? longitude;
  final List<String>? tags;
  final String? requirements;
  final String? whatYouLearn;
  final String? materialsProvided;
  final String? materialsNeeded;
  final List<String>? images;
  final String? videoUrl;
  final bool isActive;
  final bool isFeatured;
  final int viewsCount;
  final int favoritesCount;
  final int bookingsCount;
  final double rating;
  final int totalReviews;
  final DateTime createdAt;
  final DateTime updatedAt;

  Skill({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    this.subcategory,
    required this.experienceLevel,
    required this.skillType,
    required this.availability,
    this.durationPerSession,
    this.maxParticipants = 1,
    required this.priceType,
    this.priceAmount,
    this.priceCurrency = 'USD',
    required this.location,
    this.locationType,
    this.address,
    this.latitude,
    this.longitude,
    this.tags,
    this.requirements,
    this.whatYouLearn,
    this.materialsProvided,
    this.materialsNeeded,
    this.images,
    this.videoUrl,
    this.isActive = true,
    this.isFeatured = false,
    this.viewsCount = 0,
    this.favoritesCount = 0,
    this.bookingsCount = 0,
    this.rating = 0.0,
    this.totalReviews = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  String get formattedPrice {
    if (priceType == 'free') return 'Free';
    if (priceType == 'exchange') return 'Skill Exchange';
    if (priceAmount == null) return 'Contact for price';
    return '\$${priceAmount!.toStringAsFixed(0)}';
  }

  String get experienceLevelDisplay {
    switch (experienceLevel.toLowerCase()) {
      case 'beginner':
        return 'Beginner';
      case 'intermediate':
        return 'Intermediate';
      case 'advanced':
        return 'Advanced';
      case 'expert':
        return 'Expert';
      default:
        return experienceLevel;
    }
  }

  String get skillTypeDisplay {
    switch (skillType.toLowerCase()) {
      case 'teach':
        return 'Teaching';
      case 'learn':
        return 'Learning';
      case 'exchange':
        return 'Exchange';
      default:
        return skillType;
    }
  }

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String?,
      experienceLevel: json['experience_level'] as String,
      skillType: json['skill_type'] as String,
      availability: json['availability'] as String,
      durationPerSession: json['duration_per_session'] as int?,
      maxParticipants: json['max_participants'] as int? ?? 1,
      priceType: json['price_type'] as String,
      priceAmount: (json['price_amount'] as num?)?.toDouble(),
      priceCurrency: json['price_currency'] as String? ?? 'USD',
      location: json['location'] as String,
      locationType: json['location_type'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      tags: json['tags'] != null
          ? List<String>.from(json['tags'] as List)
          : null,
      requirements: json['requirements'] as String?,
      whatYouLearn: json['what_you_learn'] as String?,
      materialsProvided: json['materials_provided'] as String?,
      materialsNeeded: json['materials_needed'] as String?,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : null,
      videoUrl: json['video_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      viewsCount: json['views_count'] as int? ?? 0,
      favoritesCount: json['favorites_count'] as int? ?? 0,
      bookingsCount: json['bookings_count'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['total_reviews'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'category': category,
      'subcategory': subcategory,
      'experience_level': experienceLevel,
      'skill_type': skillType,
      'availability': availability,
      'duration_per_session': durationPerSession,
      'max_participants': maxParticipants,
      'price_type': priceType,
      'price_amount': priceAmount,
      'price_currency': priceCurrency,
      'location': location,
      'location_type': locationType,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'tags': tags,
      'requirements': requirements,
      'what_you_learn': whatYouLearn,
      'materials_provided': materialsProvided,
      'materials_needed': materialsNeeded,
      'images': images,
      'video_url': videoUrl,
      'is_active': isActive,
      'is_featured': isFeatured,
      'views_count': viewsCount,
      'favorites_count': favoritesCount,
      'bookings_count': bookingsCount,
      'rating': rating,
      'total_reviews': totalReviews,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Skill copyWith({
    String? title,
    String? description,
    String? category,
    String? subcategory,
    String? experienceLevel,
    String? skillType,
    String? availability,
    int? durationPerSession,
    int? maxParticipants,
    String? priceType,
    double? priceAmount,
    String? priceCurrency,
    String? location,
    String? locationType,
    String? address,
    double? latitude,
    double? longitude,
    List<String>? tags,
    String? requirements,
    String? whatYouLearn,
    String? materialsProvided,
    String? materialsNeeded,
    List<String>? images,
    String? videoUrl,
    bool? isActive,
    bool? isFeatured,
    int? viewsCount,
    int? favoritesCount,
    int? bookingsCount,
    double? rating,
    int? totalReviews,
    DateTime? updatedAt,
  }) {
    return Skill(
      id: id,
      userId: userId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      skillType: skillType ?? this.skillType,
      availability: availability ?? this.availability,
      durationPerSession: durationPerSession ?? this.durationPerSession,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      priceType: priceType ?? this.priceType,
      priceAmount: priceAmount ?? this.priceAmount,
      priceCurrency: priceCurrency ?? this.priceCurrency,
      location: location ?? this.location,
      locationType: locationType ?? this.locationType,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      tags: tags ?? this.tags,
      requirements: requirements ?? this.requirements,
      whatYouLearn: whatYouLearn ?? this.whatYouLearn,
      materialsProvided: materialsProvided ?? this.materialsProvided,
      materialsNeeded: materialsNeeded ?? this.materialsNeeded,
      images: images ?? this.images,
      videoUrl: videoUrl ?? this.videoUrl,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      viewsCount: viewsCount ?? this.viewsCount,
      favoritesCount: favoritesCount ?? this.favoritesCount,
      bookingsCount: bookingsCount ?? this.bookingsCount,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class SkillWithUser extends Skill {
  final String username;
  final String userFirstName;
  final String userLastName;
  final String? userAvatarUrl;
  final double userRating;
  final int userTotalReviews;
  final String categoryName;
  final String? subcategoryName;

  SkillWithUser({
    required super.id,
    required super.userId,
    required super.title,
    required super.description,
    required super.category,
    super.subcategory,
    required super.experienceLevel,
    required super.skillType,
    required super.availability,
    super.durationPerSession,
    super.maxParticipants = 1,
    required super.priceType,
    super.priceAmount,
    super.priceCurrency = 'USD',
    required super.location,
    super.locationType,
    super.address,
    super.latitude,
    super.longitude,
    super.tags,
    super.requirements,
    super.whatYouLearn,
    super.materialsProvided,
    super.materialsNeeded,
    super.images,
    super.videoUrl,
    super.isActive = true,
    super.isFeatured = false,
    super.viewsCount = 0,
    super.favoritesCount = 0,
    super.bookingsCount = 0,
    super.rating = 0.0,
    super.totalReviews = 0,
    required super.createdAt,
    required super.updatedAt,
    required this.username,
    required this.userFirstName,
    required this.userLastName,
    this.userAvatarUrl,
    required this.userRating,
    required this.userTotalReviews,
    required this.categoryName,
    this.subcategoryName,
  });

  String get userFullName => '$userFirstName $userLastName';

  // Additional getters for backwards compatibility
  String get teacherName => userFullName;
  String? get teacherAvatarUrl => userAvatarUrl;
  double get teacherRating => userRating;
  int get teacherReviewCount => userTotalReviews;
  String? get imageUrl => images?.isNotEmpty == true ? images!.first : null;
  String get priceDisplay => formattedPrice;
  int? get duration => durationPerSession;

  factory SkillWithUser.fromJson(Map<String, dynamic> json) {
    return SkillWithUser(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String?,
      experienceLevel: json['experience_level'] as String,
      skillType: json['skill_type'] as String,
      availability: json['availability'] as String,
      durationPerSession: json['duration_per_session'] as int?,
      maxParticipants: json['max_participants'] as int? ?? 1,
      priceType: json['price_type'] as String,
      priceAmount: (json['price_amount'] as num?)?.toDouble(),
      priceCurrency: json['price_currency'] as String? ?? 'USD',
      location: json['location'] as String,
      locationType: json['location_type'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      tags: json['tags'] != null
          ? List<String>.from(json['tags'] as List)
          : null,
      requirements: json['requirements'] as String?,
      whatYouLearn: json['what_you_learn'] as String?,
      materialsProvided: json['materials_provided'] as String?,
      materialsNeeded: json['materials_needed'] as String?,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List)
          : null,
      videoUrl: json['video_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      viewsCount: json['views_count'] as int? ?? 0,
      favoritesCount: json['favorites_count'] as int? ?? 0,
      bookingsCount: json['bookings_count'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['total_reviews'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      username: json['username'] as String,
      userFirstName: json['first_name'] as String,
      userLastName: json['last_name'] as String,
      userAvatarUrl: json['user_avatar_url'] as String?,
      userRating: (json['user_rating'] as num?)?.toDouble() ?? 0.0,
      userTotalReviews: json['user_total_reviews'] as int? ?? 0,
      categoryName: json['category_name'] as String,
      subcategoryName: json['subcategory_name'] as String?,
    );
  }
}

