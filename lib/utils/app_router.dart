import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/home_screen.dart';
import '../screens/browse_skills_screen.dart';
import '../screens/skill_detail_screen.dart';
import '../screens/add_edit_skill_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/messages_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/search_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/bookings_screen.dart';
import '../screens/booking_detail_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/splash',
      redirect: (context, state) {
        final authProvider = context.read<AuthProvider>();
        final isAuthenticated = authProvider.isAuthenticated;
        final isInitialized = authProvider.isInitialized;

        // Show splash screen while initializing
        if (!isInitialized) {
          return '/splash';
        }

        // Redirect to auth if not authenticated and trying to access protected routes
        if (!isAuthenticated && !_isPublicRoute(state.matchedLocation)) {
          return '/auth';
        }

        // Redirect to home if authenticated and trying to access auth routes
        if (isAuthenticated && _isAuthRoute(state.matchedLocation)) {
          return '/home';
        }

        return null; // No redirect needed
      },
      routes: [
        // Splash Screen
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),

        // Onboarding Screen
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),

        // Authentication Screen
        GoRoute(
          path: '/auth',
          name: 'auth',
          builder: (context, state) => const AuthScreen(),
        ),

        // Main App Shell with Bottom Navigation
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return MainShell(child: child);
          },
          routes: [
            // Home Tab
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const HomeScreen(),
            ),

            // Browse Tab
            GoRoute(
              path: '/browse',
              name: 'browse',
              builder: (context, state) => const BrowseSkillsScreen(),
            ),

            // Messages Tab
            GoRoute(
              path: '/messages',
              name: 'messages',
              builder: (context, state) => const MessagesScreen(),
            ),

            // Bookings Tab
            GoRoute(
              path: '/bookings',
              name: 'bookings',
              builder: (context, state) => const BookingsScreen(),
            ),

            // Profile Tab
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),

        // Skill Detail Screen
        GoRoute(
          path: '/skill/:skillId',
          name: 'skillDetail',
          builder: (context, state) {
            final skillId = state.pathParameters['skillId']!;
            return SkillDetailScreen(skillId: skillId);
          },
        ),

        // Add/Edit Skill Screen
        GoRoute(
          path: '/skill/add',
          name: 'addSkill',
          builder: (context, state) => const AddEditSkillScreen(),
        ),
        GoRoute(
          path: '/skill/edit/:skillId',
          name: 'editSkill',
          builder: (context, state) {
            final skillId = state.pathParameters['skillId']!;
            return AddEditSkillScreen(skillId: skillId);
          },
        ),

        // Edit Profile Screen
        GoRoute(
          path: '/profile/edit',
          name: 'editProfile',
          builder: (context, state) => const EditProfileScreen(),
        ),

        // Chat Screen
        GoRoute(
          path: '/chat/:conversationId',
          name: 'chat',
          builder: (context, state) {
            final conversationId = state.pathParameters['conversationId']!;
            final userName = state.uri.queryParameters['userName'] ?? 'User';
            return ChatScreen(
              conversationId: conversationId,
              userName: userName,
            );
          },
        ),

        // Booking Detail Screen
        GoRoute(
          path: '/booking/:bookingId',
          name: 'bookingDetail',
          builder: (context, state) {
            final bookingId = state.pathParameters['bookingId']!;
            return BookingDetailScreen(bookingId: bookingId);
          },
        ),

        // Notifications Screen
        GoRoute(
          path: '/notifications',
          name: 'notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),

        // Settings Screen
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),

        // Search Screen
        GoRoute(
          path: '/search',
          name: 'search',
          builder: (context, state) {
            final query = state.uri.queryParameters['q'] ?? '';
            return SearchScreen(initialQuery: query);
          },
        ),

        // Favorites Screen
        GoRoute(
          path: '/favorites',
          name: 'favorites',
          builder: (context, state) => const FavoritesScreen(),
        ),
      ],
    );
  }

  static bool _isPublicRoute(String location) {
    const publicRoutes = ['/splash', '/onboarding', '/auth'];
    return publicRoutes.contains(location);
  }

  static bool _isAuthRoute(String location) {
    const authRoutes = ['/splash', '/onboarding', '/auth'];
    return authRoutes.contains(location);
  }
}

class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/browse');
        break;
      case 2:
        context.go('/messages');
        break;
      case 3:
        context.go('/bookings'); // Added bookings tab
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update current index based on current route
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) {
      _currentIndex = 0;
    } else if (location.startsWith('/browse')) {
      _currentIndex = 1;
    } else if (location.startsWith('/messages')) {
      _currentIndex = 2;
    } else if (location.startsWith('/bookings')) { // Added bookings tab
      _currentIndex = 3;
    } else if (location.startsWith('/profile')) {
      _currentIndex = 4;
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined), // Added bookings icon
            activeIcon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

