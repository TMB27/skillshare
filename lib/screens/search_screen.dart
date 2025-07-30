import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/skill_model.dart';
import '../models/user_model.dart';
import '../services/supabase_service.dart';
import '../widgets/skill_card.dart';
import '../widgets/loading_indicator.dart';

class SearchScreen extends StatefulWidget {
  final String initialQuery;

  const SearchScreen({super.key, this.initialQuery = ''});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  List<SkillWithUser> _skillResults = [];
  List<UserProfile> _userResults = [];
  bool _isLoading = false;

  final List<String> _recentSearches = [];
  final List<String> _popularSearches = [
    'Cooking',
    'Guitar',
    'Programming',
    'Photography',
    'Language',
    'Fitness',
    'Art',
    'Music',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.text = widget.initialQuery;
    if (widget.initialQuery.isNotEmpty) {
      _performSearch(widget.initialQuery);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Search skills
      final skills = await SupabaseService.searchSkillsByText(query);
      
      // Search users
      final users = await SupabaseService.searchUsers(query);

      setState(() {
        _skillResults = skills;
        _userResults = users;
      });

      // Add to recent searches
      if (!_recentSearches.contains(query)) {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 10) {
          _recentSearches.removeLast();
        }
      }
    } catch (e) {
      debugPrint('Search failed: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchSubmitted(String query) {
    _performSearch(query);
  }

  void _onSearchTap(String query) {
    _searchController.text = query;
    _performSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    final hasResults = _skillResults.isNotEmpty || _userResults.isNotEmpty;
    final showSuggestions = _searchController.text.isEmpty && !hasResults;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search skills, users...',
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _skillResults.clear();
                        _userResults.clear();
                      });
                    },
                  )
                : null,
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: _onSearchSubmitted,
          onChanged: (value) {
            setState(() {}); // Rebuild to show/hide clear button
          },
          autofocus: true,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _onSearchSubmitted(_searchController.text),
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : showSuggestions
              ? _buildSuggestions()
              : hasResults
                  ? _buildResults()
                  : _buildNoResults(),
    );
  }

  Widget _buildSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          if (_recentSearches.isNotEmpty) ...[
            const Text(
              'Recent Searches',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches.map((search) {
                return ActionChip(
                  label: Text(search),
                  onPressed: () => _onSearchTap(search),
                  avatar: const Icon(Icons.history, size: 18),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Popular Searches
          const Text(
            'Popular Searches',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popularSearches.map((search) {
              return ActionChip(
                label: Text(search),
                onPressed: () => _onSearchTap(search),
                avatar: const Icon(Icons.trending_up, size: 18),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return Column(
      children: [
        // Tab Bar
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Skills (${_skillResults.length})'),
            Tab(text: 'Users (${_userResults.length})'),
          ],
        ),

        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildSkillResults(),
              _buildUserResults(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkillResults() {
    if (_skillResults.isEmpty) {
      return const Center(
        child: Text('No skills found'),
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
      itemCount: _skillResults.length,
      itemBuilder: (context, index) {
        final skill = _skillResults[index];
        return SkillCard(skill: skill);
      },
    );
  }

  Widget _buildUserResults() {
    if (_userResults.isEmpty) {
      return const Center(
        child: Text('No users found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _userResults.length,
      itemBuilder: (context, index) {
        final user = _userResults[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: user.avatarUrl != null
                  ? NetworkImage(user.avatarUrl!)
                  : null,
              child: user.avatarUrl == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text('${user.firstName} ${user.lastName}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('@${user.username}'),
                if (user.bio != null && user.bio!.isNotEmpty)
                  Text(
                    user.bio!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 16, color: AppTheme.warningYellow),
                const SizedBox(width: 4),
                Text(user.rating.toStringAsFixed(1)),
              ],
            ),
            onTap: () {
              // TODO: Navigate to user profile
            },
          ),
        );
      },
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 64,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: 16),
          const Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching for "${_searchController.text}" with different keywords',
            style: const TextStyle(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

