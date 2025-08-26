import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/auth_provider.dart';
import '../widgets/loading_overlay.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isEmailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.resetPassword(
      _emailController.text.trim(),
    );

    if (success && mounted) {
      setState(() {
        _isEmailSent = true;
      });
      _showSuccessSnackBar(
          'Password reset email sent! Please check your inbox.');
    } else if (mounted) {
      _showErrorSnackBar(
          authProvider.errorMessage ?? 'Failed to send reset email');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorRed,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return LoadingOverlay(
          isLoading: authProvider.isLoading,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
                onPressed: () => context.pop(),
              ),
              title: const Text(
                'Reset Password',
                style: TextStyle(color: AppTheme.textPrimary),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: _isEmailSent ? _buildEmailSentView() : _buildResetForm(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResetForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),

          // Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.primaryTeal.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_reset_rounded,
              size: 50,
              color: AppTheme.primaryTeal,
            ),
          ),

          const SizedBox(height: 32),

          // Title
          const Text(
            'Forgot Your Password?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          const Text(
            'Don\'t worry! It happens. Please enter the email address associated with your account.',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          // Form
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: 'Enter your email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Send Reset Email Button
                ElevatedButton(
                  onPressed: _handleSendResetEmail,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Send Reset Email'),
                ),

                const SizedBox(height: 16),

                // Back to Login Button
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Back to Login'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailSentView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Success Icon
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppTheme.successGreen.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_rounded,
            size: 60,
            color: AppTheme.successGreen,
          ),
        ),

        const SizedBox(height: 32),

        // Success Title
        const Text(
          'Email Sent!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        // Success Description
        Text(
          'We\'ve sent a password reset link to\n${_emailController.text.trim()}',
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 24),

        // Instructions
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.infoBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.infoBlue.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.infoBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Next Steps:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '• Check your email inbox\n• Click the reset link in the email\n• Create a new password\n• Log in with your new password',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Resend Email Button
        OutlinedButton(
          onPressed: () {
            setState(() {
              _isEmailSent = false;
            });
          },
          child: const Text('Send Another Email'),
        ),

        const SizedBox(height: 16),

        // Back to Login Button
        ElevatedButton(
          onPressed: () => context.pop(),
          child: const Text('Back to Login'),
        ),

        const SizedBox(height: 24),

        // Didn't receive email section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.warningYellow.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.warningYellow.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              const Text(
                'Didn\'t receive the email?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Check your spam folder or try a different email address.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
