import 'package:flutter/material.dart';
import '../models/skill_model.dart';
import '../services/supabase_service.dart';

class SkillsProvider extends ChangeNotifier {
  List<SkillWithUser> _skills = [];
  List<SkillWithUser> _featuredSkills = [];
  List<SkillWithUser> _userSkills = [];
  List<SkillWithUser> _favoriteSkills = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Filter properties
  String? _selectedCategory;
  String? _searchQuery;
  String? _selectedLocation;
  double? _minPrice;
  double? _maxPrice;
  String? _selectedExperienceLevel;
  String? _selectedSkillType;

  // Getters
  List<SkillWithUser> get skills => _skills;
  List<SkillWithUser> get featuredSkills => _featuredSkills;
  List<SkillWithUser> get userSkills => _userSkills;
  List<SkillWithUser> get favoriteSkills => _favoriteSkills;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Filter getters
  String? get selectedCategory => _selectedCategory;
  String? get searchQuery => _searchQuery;
  String? get selectedLocation => _selectedLocation;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;
  String? get selectedExperienceLevel => _selectedExperienceLevel;
  String? get selectedSkillType => _selectedSkillType;

  bool get hasActiveFilters => 
      _selectedCategory != null ||
      _searchQuery != null ||
      _selectedLocation != null ||
      _minPrice != null ||
      _maxPrice != null ||
      _selectedExperienceLevel != null ||
      _selectedSkillType != null;

  Future<void> loadSkills({bool refresh = false}) async {
    if (_isLoading && !refresh) return;
    
    _setLoading(true);
    _clearError();

    try {
      final skills = await SupabaseService.searchSkills(
        category: _selectedCategory,
        searchQuery: _searchQuery,
        location: _selectedLocation,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        experienceLevel: _selectedExperienceLevel,
        skillType: _selectedSkillType,
        limit: 50,
      );

      _skills = skills;
      _featuredSkills = skills.where((skill) => skill.isFeatured).toList();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load skills: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadUserSkills(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      await SupabaseService.getUserSkills(userId);
      // Convert to SkillWithUser (you might need to fetch user data separately)
      // For now, we'll use a simplified approach
      _userSkills = []; // This would need proper implementation
      notifyListeners();
    } catch (e) {
      _setError('Failed to load user skills: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadFavoriteSkills(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      final favorites = await SupabaseService.getFavoriteSkills(userId);
      _favoriteSkills = favorites;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load favorite skills: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<SkillWithUser?> getSkillById(String skillId) async {
    try {
      // First check if skill is already in our list
      final existingSkill = _skills.firstWhere(
        (skill) => skill.id == skillId,
        orElse: () => _featuredSkills.firstWhere(
          (skill) => skill.id == skillId,
          orElse: () => throw StateError('Skill not found'),
        ),
      );
      
      // Increment view count
      await SupabaseService.incrementSkillViews(skillId);
      
      return existingSkill;
    } catch (e) {
      // If not found in local lists, fetch from server
      try {
        final skill = await SupabaseService.getSkillById(skillId);
        if (skill != null) {
          await SupabaseService.incrementSkillViews(skillId);
        }
        return skill;
      } catch (e) {
        _setError('Failed to load skill: ${e.toString()}');
        return null;
      }
    }
  }

  Future<bool> createSkill(Skill skill) async {
    _setLoading(true);
    _clearError();

    try {
      await SupabaseService.createSkill(skill);
      // Reload skills to include the new one
      await loadSkills(refresh: true);
      return true;
    } catch (e) {
      _setError('Failed to create skill: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateSkill(Skill skill) async {
    _setLoading(true);
    _clearError();

    try {
      await SupabaseService.updateSkill(skill);
      // Reload skills to reflect changes
      await loadSkills(refresh: true);
      return true;
    } catch (e) {
      _setError('Failed to update skill: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteSkill(String skillId) async {
    _setLoading(true);
    _clearError();

    try {
      await SupabaseService.deleteSkill(skillId);
      // Remove from local lists
      _skills.removeWhere((skill) => skill.id == skillId);
      _featuredSkills.removeWhere((skill) => skill.id == skillId);
      _userSkills.removeWhere((skill) => skill.id == skillId);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete skill: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> toggleFavorite(String userId, String skillId) async {
    try {
      final isFavorited = await SupabaseService.isSkillFavorited(userId, skillId);
      
      if (isFavorited) {
        await SupabaseService.removeFromFavorites(userId, skillId);
        _favoriteSkills.removeWhere((skill) => skill.id == skillId);
      } else {
        await SupabaseService.addToFavorites(userId, skillId);
        // Optionally reload favorites to get the updated list
        await loadFavoriteSkills(userId);
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to toggle favorite: ${e.toString()}');
      return false;
    }
  }

  Future<bool> isSkillFavorited(String userId, String skillId) async {
    try {
      return await SupabaseService.isSkillFavorited(userId, skillId);
    } catch (e) {
      return false;
    }
  }

  Future<List<SkillWithUser>> searchSkills(String query) async {
    try {
      return await SupabaseService.searchSkillsByText(query);
    } catch (e) {
      _setError('Failed to search skills: ${e.toString()}');
      return [];
    }
  }

  // Filter methods
  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
    loadSkills(refresh: true);
  }

  void setSearchQuery(String? query) {
    _searchQuery = query;
    notifyListeners();
    loadSkills(refresh: true);
  }

  void setLocation(String? location) {
    _selectedLocation = location;
    notifyListeners();
    loadSkills(refresh: true);
  }

  void setPriceRange(double? minPrice, double? maxPrice) {
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    notifyListeners();
    loadSkills(refresh: true);
  }

  void setExperienceLevel(String? level) {
    _selectedExperienceLevel = level;
    notifyListeners();
    loadSkills(refresh: true);
  }

  void setSkillType(String? type) {
    _selectedSkillType = type;
    notifyListeners();
    loadSkills(refresh: true);
  }

  void clearFilters() {
    _selectedCategory = null;
    _searchQuery = null;
    _selectedLocation = null;
    _minPrice = null;
    _maxPrice = null;
    _selectedExperienceLevel = null;
    _selectedSkillType = null;
    notifyListeners();
    loadSkills(refresh: true);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}

