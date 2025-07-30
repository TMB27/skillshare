class Review {
  final String id;
  final String skillId;
  final String reviewerId;
  final String revieweeId;
  final String? bookingId;
  final double rating;
  final String? title;
  final String? comment;
  final List<String>? tags;
  final bool isPublic;
  final bool isVerified;
  final int helpfulCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.skillId,
    required this.reviewerId,
    required this.revieweeId,
    this.bookingId,
    required this.rating,
    this.title,
    this.comment,
    this.tags,
    this.isPublic = true,
    this.isVerified = false,
    this.helpfulCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  String get ratingDisplay {
    return rating.toStringAsFixed(1);
  }

  List<String> get ratingStars {
    List<String> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    
    for (int i = 0; i < fullStars; i++) {
      stars.add('★');
    }
    
    if (hasHalfStar) {
      stars.add('☆');
    }
    
    while (stars.length < 5) {
      stars.add('☆');
    }
    
    return stars;
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      skillId: json['skill_id'] as String,
      reviewerId: json['reviewer_id'] as String,
      revieweeId: json['reviewee_id'] as String,
      bookingId: json['booking_id'] as String?,
      rating: (json['rating'] as num).toDouble(),
      title: json['title'] as String?,
      comment: json['comment'] as String?,
      tags: json['tags'] != null
          ? List<String>.from(json['tags'] as List)
          : null,
      isPublic: json['is_public'] as bool? ?? true,
      isVerified: json['is_verified'] as bool? ?? false,
      helpfulCount: json['helpful_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'skill_id': skillId,
      'reviewer_id': reviewerId,
      'reviewee_id': revieweeId,
      'booking_id': bookingId,
      'rating': rating,
      'title': title,
      'comment': comment,
      'tags': tags,
      'is_public': isPublic,
      'is_verified': isVerified,
      'helpful_count': helpfulCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Review copyWith({
    double? rating,
    String? title,
    String? comment,
    List<String>? tags,
    bool? isPublic,
    bool? isVerified,
    int? helpfulCount,
    DateTime? updatedAt,
  }) {
    return Review(
      id: id,
      skillId: skillId,
      reviewerId: reviewerId,
      revieweeId: revieweeId,
      bookingId: bookingId,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      comment: comment ?? this.comment,
      tags: tags ?? this.tags,
      isPublic: isPublic ?? this.isPublic,
      isVerified: isVerified ?? this.isVerified,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class ReviewWithUser extends Review {
  final String reviewerName;
  final String? reviewerAvatarUrl;
  final String reviewerUsername;
  final bool reviewerIsVerified;
  final String skillTitle;
  final String? skillImageUrl;

  ReviewWithUser({
    required super.id,
    required super.skillId,
    required super.reviewerId,
    required super.revieweeId,
    super.bookingId,
    required super.rating,
    super.title,
    super.comment,
    super.tags,
    super.isPublic = true,
    super.isVerified = false,
    super.helpfulCount = 0,
    required super.createdAt,
    required super.updatedAt,
    required this.reviewerName,
    this.reviewerAvatarUrl,
    required this.reviewerUsername,
    this.reviewerIsVerified = false,
    required this.skillTitle,
    this.skillImageUrl,
  });

  factory ReviewWithUser.fromJson(Map<String, dynamic> json) {
    return ReviewWithUser(
      id: json['id'] as String,
      skillId: json['skill_id'] as String,
      reviewerId: json['reviewer_id'] as String,
      revieweeId: json['reviewee_id'] as String,
      bookingId: json['booking_id'] as String?,
      rating: (json['rating'] as num).toDouble(),
      title: json['title'] as String?,
      comment: json['comment'] as String?,
      tags: json['tags'] != null
          ? List<String>.from(json['tags'] as List)
          : null,
      isPublic: json['is_public'] as bool? ?? true,
      isVerified: json['is_verified'] as bool? ?? false,
      helpfulCount: json['helpful_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      reviewerName: json['reviewer_name'] as String,
      reviewerAvatarUrl: json['reviewer_avatar_url'] as String?,
      reviewerUsername: json['reviewer_username'] as String,
      reviewerIsVerified: json['reviewer_is_verified'] as bool? ?? false,
      skillTitle: json['skill_title'] as String,
      skillImageUrl: json['skill_image_url'] as String?,
    );
  }
}

class ReviewSummary {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution;
  final List<String> topTags;
  final double recommendationPercentage;

  ReviewSummary({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    required this.topTags,
    required this.recommendationPercentage,
  });

  String get averageRatingDisplay {
    return averageRating.toStringAsFixed(1);
  }

  int getRatingCount(int stars) {
    return ratingDistribution[stars] ?? 0;
  }

  double getRatingPercentage(int stars) {
    if (totalReviews == 0) return 0.0;
    return (getRatingCount(stars) / totalReviews) * 100;
  }

  factory ReviewSummary.fromJson(Map<String, dynamic> json) {
    return ReviewSummary(
      averageRating: (json['average_rating'] as num).toDouble(),
      totalReviews: json['total_reviews'] as int,
      ratingDistribution: Map<int, int>.from(json['rating_distribution'] as Map),
      topTags: List<String>.from(json['top_tags'] as List),
      recommendationPercentage: (json['recommendation_percentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'rating_distribution': ratingDistribution,
      'top_tags': topTags,
      'recommendation_percentage': recommendationPercentage,
    };
  }
}

