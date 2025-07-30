import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/skills_provider.dart';
import '../widgets/skill_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_message.dart';

class BrowseSkillsScreen extends StatefulWidget {
  const BrowseSkillsScreen({super.key});

  @override
  State<BrowseSkillsScreen> createState() => _BrowseSkillsScreenState();
}

class _BrowseSkillsScreenState extends State<BrowseSkillsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  String? _selectedExperienceLevel;
  String? _selectedSkillType;
  RangeValues _priceRange = const RangeValues(0, 1000);

  final List<String> _categories = [
    'Technology',
    'Creative Arts',
    'Music',
    'Cooking',
    'Sports & Fitness',
    'Language',
    'Business',
    'Crafts',
    'Academic',
    'Other',
  ];

  final List<String> _experienceLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
  ];

  final List<String> _skillTypes = [
    'In-Person',
    'Online',
    'Hybrid',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SkillsProvider>().loadSkills();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setModalState(() {
                        _selectedCategory = null;
                        _selectedExperienceLevel = null;
                        _selectedSkillType = null;
                        _priceRange = const RangeValues(0, 1000);
                      });
                    },
                    child: const Text('Clear All'),
                  ),
                ],
              ),
              const Divider(),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Filter
                      const Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _categories.map((category) {
                          return FilterChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (selected) {
                              setModalState(() {
                                _selectedCategory = selected ? category : null;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // Experience Level Filter
                      const Text(
                        'Experience Level',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _experienceLevels.map((level) {
                          return FilterChip(
                            label: Text(level),
                            selected: _selectedExperienceLevel == level,
                            onSelected: (selected) {
                              setModalState(() {
                                _selectedExperienceLevel = selected ? level : null;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // Skill Type Filter
                      const Text(
                        'Skill Type',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _skillTypes.map((type) {
                          return FilterChip(
                            label: Text(type),
                            selected: _selectedSkillType == type,
                            onSelected: (selected) {
                              setModalState(() {
                                _selectedSkillType = selected ? type : null;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // Price Range Filter
                      const Text(
                        'Price Range',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 1000,
                        divisions: 20,
                        labels: RangeLabels(
                          '\$${_priceRange.start.round()}',
                          '\$${_priceRange.end.round()}',
                        ),
                        onChanged: (values) {
                          setModalState(() {
                            _priceRange = values;
                          });
                        },
                      ),
                      Text(
                        'Price: \$${_priceRange.start.round()} - \$${_priceRange.end.round()}',
                        style: const TextStyle(color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),

              // Apply Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _applyFilters();
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyFilters() {
    final skillsProvider = context.read<SkillsProvider>();
    skillsProvider.setCategory(_selectedCategory);
    skillsProvider.setExperienceLevel(_selectedExperienceLevel);
    skillsProvider.setSkillType(_selectedSkillType);
    skillsProvider.setPriceRange(_priceRange.start, _priceRange.end);
  }

  @override
  Widget build(BuildContext context) {
    final skillsProvider = context.watch<SkillsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Skills'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search skills...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: (query) {
                      skillsProvider.setSearchQuery(query.isEmpty ? null : query);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _showFilterBottomSheet,
                  icon: Icon(
                    Icons.filter_list,
                    color: skillsProvider.hasActiveFilters
                        ? AppTheme.primaryTeal
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: skillsProvider.isLoading && skillsProvider.skills.isEmpty
          ? const LoadingIndicator()
          : skillsProvider.errorMessage != null
              ? ErrorMessage(
                  message: skillsProvider.errorMessage!,
                  onRetry: () => skillsProvider.loadSkills(refresh: true),
                )
              : RefreshIndicator(
                  onRefresh: () => skillsProvider.loadSkills(refresh: true),
                  child: skillsProvider.skills.isEmpty
                      ? const Center(
                          child: Text('No skills found. Try adjusting your filters.'),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: skillsProvider.skills.length,
                          itemBuilder: (context, index) {
                            final skill = skillsProvider.skills[index];
                            return SkillCard(skill: skill);
                          },
                        ),
                ),
    );
  }
}

