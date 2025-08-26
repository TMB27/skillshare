class UserProfile {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? location;
  final String? bio;
  final String? avatarUrl;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? occupation;
  final String? educationLevel;
  final List<String>? languagesSpoken;
  final Map<String, dynamic>? socialLinks;
  final String verificationStatus;
  final double rating;
  final int totalReviews;
  final int skillsTaught;
  final int skillsLearned;
  final bool isActive;
  final DateTime? lastSeen;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.location,
    this.bio,
    this.avatarUrl,
    this.dateOfBirth,
    this.gender,
    this.occupation,
    this.educationLevel,
    this.languagesSpoken,
    this.socialLinks,
    this.verificationStatus = 'unverified',
    this.rating = 0.0,
    this.totalReviews = 0,
    this.skillsTaught = 0,
    this.skillsLearned = 0,
    this.isActive = true,
    this.lastSeen,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  // Additional getter for compatibility
  int get reviewCount => totalReviews;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      location: json['location'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      gender: json['gender'] as String?,
      occupation: json['occupation'] as String?,
      educationLevel: json['education_level'] as String?,
      languagesSpoken: json['languages_spoken'] != null
          ? List<String>.from(json['languages_spoken'] as List)
          : null,
      socialLinks: json['social_links'] as Map<String, dynamic>?,
      verificationStatus:
          json['verification_status'] as String? ?? 'unverified',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['total_reviews'] as int? ?? 0,
      skillsTaught: json['skills_taught'] as int? ?? 0,
      skillsLearned: json['skills_learned'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      lastSeen: json['last_seen'] != null
          ? DateTime.parse(json['last_seen'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'location': location,
      'bio': bio,
      'avatar_url': avatarUrl,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'occupation': occupation,
      'education_level': educationLevel,
      'languages_spoken': languagesSpoken,
      'social_links': socialLinks,
      'verification_status': verificationStatus,
      'rating': rating,
      'total_reviews': totalReviews,
      'skills_taught': skillsTaught,
      'skills_learned': skillsLearned,
      'is_active': isActive,
      'last_seen': lastSeen?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? location,
    String? bio,
    String? avatarUrl,
    DateTime? dateOfBirth,
    String? gender,
    String? occupation,
    String? educationLevel,
    List<String>? languagesSpoken,
    Map<String, dynamic>? socialLinks,
    String? verificationStatus,
    double? rating,
    int? totalReviews,
    int? skillsTaught,
    int? skillsLearned,
    bool? isActive,
    DateTime? lastSeen,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      occupation: occupation ?? this.occupation,
      educationLevel: educationLevel ?? this.educationLevel,
      languagesSpoken: languagesSpoken ?? this.languagesSpoken,
      socialLinks: socialLinks ?? this.socialLinks,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      skillsTaught: skillsTaught ?? this.skillsTaught,
      skillsLearned: skillsLearned ?? this.skillsLearned,
      isActive: isActive ?? this.isActive,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
