import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../services/supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  UserProfile? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;

  UserProfile? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isInitialized => _isInitialized;

  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    _setLoading(true);
    try {
      // Listen to auth state changes
      SupabaseService.client.auth.onAuthStateChange.listen((data) {
        _handleAuthStateChange(data.event, data.session);
      });

      // Check if user is already logged in
      final session = SupabaseService.client.auth.currentSession;
      if (session != null) {
        await _loadUserProfile(session.user.id);
      }
      
      _isInitialized = true;
    } catch (e) {
      _setError('Failed to initialize authentication: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  void _handleAuthStateChange(AuthChangeEvent event, Session? session) {
    switch (event) {
      case AuthChangeEvent.signedIn:
        if (session?.user != null) {
          _loadUserProfile(session!.user.id);
        }
        break;
      case AuthChangeEvent.signedOut:
        _currentUser = null;
        notifyListeners();
        break;
      case AuthChangeEvent.userUpdated:
        if (session?.user != null) {
          _loadUserProfile(session!.user.id);
        }
        break;
      default:
        break;
    }
  }

  Future<void> _loadUserProfile(String userId) async {
    try {
      final profile = await SupabaseService.getUserProfile(userId);
      _currentUser = profile;
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load user profile: ${e.toString()}');
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,
    String? location,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await SupabaseService.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        username: username,
        location: location,
      );

      if (response.user != null) {
        // User profile will be created automatically via database trigger
        // and loaded via auth state change listener
        return true;
      } else {
        _setError('Failed to create account');
        return false;
      }
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await SupabaseService.signIn(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // User profile will be loaded via auth state change listener
        return true;
      } else {
        _setError('Failed to sign in');
        return false;
      }
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await SupabaseService.signOut();
      _currentUser = null;
      _clearError();
    } catch (e) {
      _setError('Failed to sign out: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await SupabaseService.resetPassword(email);
      return true;
    } on AuthException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile(UserProfile updatedProfile) async {
    _setLoading(true);
    _clearError();

    try {
      final profile = await SupabaseService.updateUserProfile(updatedProfile);
      _currentUser = profile;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update profile: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> uploadAvatar(String filePath) async {
    if (_currentUser == null) return false;

    _setLoading(true);
    _clearError();

    try {
      final avatarUrl = await SupabaseService.uploadAvatar(_currentUser!.id, filePath);
      if (avatarUrl != null) {
        final updatedProfile = _currentUser!.copyWith(avatarUrl: avatarUrl);
        return await updateProfile(updatedProfile);
      }
      return false;
    } catch (e) {
      _setError('Failed to upload avatar: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshProfile() async {
    if (_currentUser != null) {
      await _loadUserProfile(_currentUser!.id);
    }
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

