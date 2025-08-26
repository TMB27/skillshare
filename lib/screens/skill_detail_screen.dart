import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/app_theme.dart';
import '../models/skill_model.dart';
import '../providers/skills_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_message.dart';

class SkillDetailScreen extends StatefulWidget {
  final String skillId;

  const SkillDetailScreen({
    super.key,
    required this.skillId,
  });

  @override
  State<SkillDetailScreen> createState() => _SkillDetailScreenState();
}

class _SkillDetailScreenState extends State<SkillDetailScreen> {
  SkillWithUser? _skill;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _loadSkillDetails();
  }

  Future<void> _loadSkillDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final skillsProvider = context.read<SkillsProvider>();
      final skill = await skillsProvider.getSkillById(widget.skillId);

      if (skill != null) {
        setState(() {
          _skill = skill;
        });

        // Check if skill is favorited
        final authProvider = context.read<AuthProvider>();
        if (authProvider.currentUser != null) {
          final isFavorited = await skillsProvider.isSkillFavorited(
            authProvider.currentUser!.id,
            widget.skillId,
          );
          setState(() {
            _isFavorited = isFavorited;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Skill not found';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load skill details: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.currentUser == null) return;

    final skillsProvider = context.read<SkillsProvider>();
    final success = await skillsProvider.toggleFavorite(
      authProvider.currentUser!.id,
      widget.skillId,
    );

    if (success) {
      setState(() {
        _isFavorited = !_isFavorited;
      });
    }
  }

  void _bookSkill() {
    if (_skill == null) return;

    // TODO: Navigate to booking screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking functionality coming soon!'),
      ),
    );
  }

  void _contactTeacher() {
    if (_skill == null) return;

    // TODO: Navigate to chat screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Messaging functionality coming soon!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: LoadingIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(),
        body: ErrorMessage(
          message: _errorMessage!,
          onRetry: _loadSkillDetails,
        ),
      );
    }

    if (_skill == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const ErrorMessage(message: 'Skill not found'),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _skill!.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: _skill!.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppTheme.surfaceGray,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppTheme.surfaceGray,
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 60,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    )
                  : Container(
                      color: AppTheme.surfaceGray,
                      child: const Icon(
                        Icons.school,
                        size: 60,
                        color: AppTheme.textSecondary,
                      ),
                    ),
            ),
            actions: [
              IconButton(
                onPressed: _toggleFavorite,
                icon: Icon(
                  _isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorited ? AppTheme.errorRed : Colors.white,
                ),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          _skill!.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        _skill!.priceDisplay,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryTeal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Teacher Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: _skill!.teacherAvatarUrl != null
                            ? CachedNetworkImageProvider(
                                _skill!.teacherAvatarUrl!)
                            : null,
                        child: _skill!.teacherAvatarUrl == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _skill!.teacherName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: AppTheme.warningYellow,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${_skill!.teacherRating.toStringAsFixed(1)} (${_skill!.teacherReviewCount} reviews)',
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Skill Details
                  _buildDetailRow('Category', _skill!.category),
                  _buildDetailRow('Experience Level', _skill!.experienceLevel),
                  _buildDetailRow('Skill Type', _skill!.skillType),
                  _buildDetailRow('Duration', '${_skill!.duration} minutes'),
                  _buildDetailRow('Location', _skill!.location),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _skill!.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Requirements
                  if (_skill!.requirements != null &&
                      _skill!.requirements!.isNotEmpty) ...[
                    Text(
                      'Requirements',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _skill!.requirements!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Tags
                  if (_skill!.tags != null && _skill!.tags!.isNotEmpty) ...[
                    Text(
                      'Tags',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _skill!.tags!
                          .map((tag) => Chip(
                                label: Text(tag),
                                backgroundColor:
                                    AppTheme.primaryTeal.withOpacity(0.1),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 100), // Space for bottom buttons
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _contactTeacher,
                icon: const Icon(Icons.message),
                label: const Text('Message'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _bookSkill,
                icon: const Icon(Icons.calendar_today),
                label: const Text('Book Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
