import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/skills_provider.dart';
import '../widgets/skill_card.dart';
import '../widgets/loading_indicator.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.currentUser != null) {
        context
            .read<SkillsProvider>()
            .loadFavoriteSkills(authProvider.currentUser!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final skillsProvider = context.watch<SkillsProvider>();

    if (authProvider.currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please log in to view your favorites'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search within favorites
            },
          ),
        ],
      ),
      body: skillsProvider.isLoading
          ? const LoadingIndicator()
          : skillsProvider.favoriteSkills.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () => skillsProvider.loadFavoriteSkills(
                    authProvider.currentUser!.id,
                  ),
                  child: _buildFavoritesList(),
                ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: AppTheme.textSecondary,
          ),
          SizedBox(height: 24),
          Text(
            'No favorites yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Browse skills and tap the heart icon\nto add them to your favorites!',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          // Browse Skills Button
          // ElevatedButton.icon(
          //   onPressed: () {
          //     // Navigate to browse skills
          //   },
          //   icon: Icon(Icons.explore),
          //   label: Text('Browse Skills'),
          // ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    final skillsProvider = context.watch<SkillsProvider>();

    return CustomScrollView(
      slivers: [
        // Header with count
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  '${skillsProvider.favoriteSkills.length} favorite${skillsProvider.favoriteSkills.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.sort),
                  onSelected: (value) {
                    // TODO: Implement sorting
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'recent',
                      child: Text('Recently Added'),
                    ),
                    const PopupMenuItem(
                      value: 'alphabetical',
                      child: Text('Alphabetical'),
                    ),
                    const PopupMenuItem(
                      value: 'price_low',
                      child: Text('Price: Low to High'),
                    ),
                    const PopupMenuItem(
                      value: 'price_high',
                      child: Text('Price: High to Low'),
                    ),
                    const PopupMenuItem(
                      value: 'rating',
                      child: Text('Highest Rated'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Favorites Grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final skill = skillsProvider.favoriteSkills[index];
                return SkillCard(
                  skill: skill,
                  showFavoriteButton: true,
                );
              },
              childCount: skillsProvider.favoriteSkills.length,
            ),
          ),
        ),

        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 16),
        ),
      ],
    );
  }
}
