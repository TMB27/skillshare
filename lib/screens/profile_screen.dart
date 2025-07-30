import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/skills_provider.dart';
import '../widgets/skill_card.dart';
import '../widgets/loading_indicator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.currentUser != null) {
        context.read<SkillsProvider>().loadUserSkills(authProvider.currentUser!.id);
        context.read<SkillsProvider>().loadFavoriteSkills(authProvider.currentUser!.id);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final skillsProvider = context.watch<SkillsProvider>();
    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please log in to view your profile'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Avatar
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: user.avatarUrl != null
                          ? CachedNetworkImageProvider(user.avatarUrl!)
                          : null,
                      child: user.avatarUrl == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryTeal,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                          onPressed: () {
                            context.push('/profile/edit');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Name and Username
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '@${user.username}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),

                // Bio
                if (user.bio != null && user.bio!.isNotEmpty)
                  Text(
                    user.bio!,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 16),

                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn('Skills', skillsProvider.userSkills.length.toString()),
                    _buildStatColumn('Rating', user.rating.toStringAsFixed(1)),
                    _buildStatColumn('Reviews', user.reviewCount.toString()),
                  ],
                ),
              ],
            ),
          ),

          // Tab Bar
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'My Skills'),
              Tab(text: 'Favorites'),
              Tab(text: 'Reviews'),
            ],
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMySkillsTab(),
                _buildFavoritesTab(),
                _buildReviewsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/skill/add');
        },
        label: const Text('Add Skill'),
        icon: const Icon(Icons.add),
        backgroundColor: AppTheme.primaryTeal,
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryTeal,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMySkillsTab() {
    final skillsProvider = context.watch<SkillsProvider>();

    if (skillsProvider.isLoading) {
      return const LoadingIndicator();
    }

    if (skillsProvider.userSkills.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'No skills yet',
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Share your expertise with the community!',
              style: TextStyle(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: skillsProvider.userSkills.length,
      itemBuilder: (context, index) {
        final skill = skillsProvider.userSkills[index];
        return SkillCard(skill: skill);
      },
    );
  }

  Widget _buildFavoritesTab() {
    final skillsProvider = context.watch<SkillsProvider>();

    if (skillsProvider.isLoading) {
      return const LoadingIndicator();
    }

    if (skillsProvider.favoriteSkills.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Browse skills and add them to your favorites!',
              style: TextStyle(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: skillsProvider.favoriteSkills.length,
      itemBuilder: (context, index) {
        final skill = skillsProvider.favoriteSkills[index];
        return SkillCard(skill: skill);
      },
    );
  }

  Widget _buildReviewsTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_border,
            size: 64,
            color: AppTheme.textSecondary,
          ),
          SizedBox(height: 16),
          Text(
            'Reviews coming soon',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'View and manage your reviews here',
            style: TextStyle(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

