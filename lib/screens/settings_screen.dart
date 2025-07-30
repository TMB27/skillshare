import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/auth_provider.dart';
import '../widgets/loading_overlay.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _messageNotifications = true;
  bool _bookingNotifications = true;
  bool _reviewNotifications = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return LoadingOverlay(
      isLoading: authProvider.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          children: [
            // Account Section
            _buildSectionHeader('Account'),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Edit Profile'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push('/profile/edit');
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showChangePasswordDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Change Email'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showChangeEmailDialog();
              },
            ),

            const Divider(),

            // Notifications Section
            _buildSectionHeader('Notifications'),
            SwitchListTile(
              secondary: const Icon(Icons.notifications),
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive push notifications on your device'),
              value: _pushNotifications,
              onChanged: (value) {
                setState(() {
                  _pushNotifications = value;
                });
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.email),
              title: const Text('Email Notifications'),
              subtitle: const Text('Receive notifications via email'),
              value: _emailNotifications,
              onChanged: (value) {
                setState(() {
                  _emailNotifications = value;
                });
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.message),
              title: const Text('Message Notifications'),
              subtitle: const Text('Get notified about new messages'),
              value: _messageNotifications,
              onChanged: (value) {
                setState(() {
                  _messageNotifications = value;
                });
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.calendar_today),
              title: const Text('Booking Notifications'),
              subtitle: const Text('Get notified about booking updates'),
              value: _bookingNotifications,
              onChanged: (value) {
                setState(() {
                  _bookingNotifications = value;
                });
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.star),
              title: const Text('Review Notifications'),
              subtitle: const Text('Get notified about new reviews'),
              value: _reviewNotifications,
              onChanged: (value) {
                setState(() {
                  _reviewNotifications = value;
                });
              },
            ),

            const Divider(),

            // Appearance Section
            _buildSectionHeader('Appearance'),
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode),
              title: const Text('Dark Mode'),
              subtitle: const Text('Use dark theme'),
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                });
                // TODO: Implement theme switching
              },
            ),

            const Divider(),

            // Privacy & Security Section
            _buildSectionHeader('Privacy & Security'),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showPrivacyPolicy();
              },
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Terms of Service'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showTermsOfService();
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Blocked Users'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Navigate to blocked users screen
              },
            ),

            const Divider(),

            // Support Section
            _buildSectionHeader('Support'),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help Center'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showHelpCenter();
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Send Feedback'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showFeedbackDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.bug_report),
              title: const Text('Report a Bug'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showBugReportDialog();
              },
            ),

            const Divider(),

            // About Section
            _buildSectionHeader('About'),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About SkillShare'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showAboutDialog();
              },
            ),
            const ListTile(
              leading: Icon(Icons.verified),
              title: Text('Version'),
              trailing: Text('1.0.0'),
            ),

            const Divider(),

            // Danger Zone
            _buildSectionHeader('Danger Zone'),
            ListTile(
              leading: const Icon(Icons.logout, color: AppTheme.errorRed),
              title: const Text(
                'Sign Out',
                style: TextStyle(color: AppTheme.errorRed),
              ),
              onTap: () {
                _showSignOutDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: AppTheme.errorRed),
              title: const Text(
                'Delete Account',
                style: TextStyle(color: AppTheme.errorRed),
              ),
              onTap: () {
                _showDeleteAccountDialog();
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryTeal,
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: const Text('This feature will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showChangeEmailDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Email'),
        content: const Text('This feature will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Your privacy is important to us. This privacy policy explains how we collect, use, and protect your information when you use our SkillShare platform...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'By using SkillShare, you agree to these terms of service. Please read them carefully...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpCenter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help Center'),
        content: const Text('Need help? Contact us at support@skillshare.com'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Feedback'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Tell us what you think...',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showBugReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report a Bug'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Describe the bug you encountered...',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'SkillShare',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.school, size: 48),
      children: const [
        Text('SkillShare is a platform for sharing and learning skills within your community.'),
      ],
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final authProvider = context.read<AuthProvider>();
              await authProvider.signOut();
              if (mounted) {
                context.go('/auth');
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorRed,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

