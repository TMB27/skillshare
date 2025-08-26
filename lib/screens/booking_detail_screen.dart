import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/app_theme.dart';
import '../models/booking_model.dart';
import '../providers/auth_provider.dart';
import '../services/supabase_service.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_message.dart';

class BookingDetailScreen extends StatefulWidget {
  final String bookingId;

  const BookingDetailScreen({
    super.key,
    required this.bookingId,
  });

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  Booking? _booking;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBookingDetails();
  }

  Future<void> _loadBookingDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final booking = await SupabaseService.getBookingById(widget.bookingId);
      setState(() {
        _booking = booking;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load booking details: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateBookingStatus(String newStatus) async {
    if (_booking == null) return;

    try {
      await SupabaseService.updateBookingStatus(widget.bookingId, newStatus);
      setState(() {
        _booking = _booking!.copyWith(status: newStatus);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking ${newStatus.toLowerCase()} successfully'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update booking: ${e.toString()}'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateBookingStatus('cancelled');
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorRed,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUserId = authProvider.currentUser?.id;

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
          onRetry: _loadBookingDetails,
        ),
      );
    }

    if (_booking == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const ErrorMessage(message: 'Booking not found'),
      );
    }

    final isTeacher = _booking!.teacherId == currentUserId;
    final canCancel =
        _booking!.status == 'pending' || _booking!.status == 'confirmed';
    final canConfirm = _booking!.status == 'pending' && isTeacher;
    final canComplete = _booking!.status == 'confirmed' && isTeacher;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        actions: [
          if (canCancel)
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: _showCancelDialog,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              color: _getStatusColor(_booking!.status).withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      _getStatusIcon(_booking!.status),
                      color: _getStatusColor(_booking!.status),
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status: ${_booking!.status.toUpperCase()}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(_booking!.status),
                            ),
                          ),
                          Text(
                            _getStatusDescription(_booking!.status),
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Skill Information
            Text(
              'Skill Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _booking!.skillTitle ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _booking!.skillDescription ?? 'No description available',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Participants
            Text(
              'Participants',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: _booking!.teacherAvatarUrl != null
                            ? CachedNetworkImageProvider(
                                _booking!.teacherAvatarUrl!)
                            : null,
                        child: _booking!.teacherAvatarUrl == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(_booking!.teacherName ?? 'Unknown Teacher'),
                      subtitle: const Text('Teacher'),
                      trailing: IconButton(
                        icon: const Icon(Icons.message),
                        onPressed: () {
                          // TODO: Navigate to chat with teacher
                        },
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: _booking!.studentAvatarUrl != null
                            ? CachedNetworkImageProvider(
                                _booking!.studentAvatarUrl!)
                            : null,
                        child: _booking!.studentAvatarUrl == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(_booking!.studentName ?? 'Unknown Student'),
                      subtitle: const Text('Student'),
                      trailing: IconButton(
                        icon: const Icon(Icons.message),
                        onPressed: () {
                          // TODO: Navigate to chat with student
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Booking Details
            Text(
              'Booking Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDetailRow('Date', _booking!.bookingDate),
                    _buildDetailRow('Time', _booking!.bookingTime),
                    _buildDetailRow(
                        'Duration', '${_booking!.duration} minutes'),
                    _buildDetailRow('Price',
                        '\$${_booking!.totalAmount?.toStringAsFixed(2) ?? '0.00'}'),
                    _buildDetailRow('Location', _booking!.location!),
                    if (_booking!.notes != null && _booking!.notes!.isNotEmpty)
                      _buildDetailRow('Notes', _booking!.notes!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100), // Space for bottom buttons
          ],
        ),
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
            if (canConfirm) ...[
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _updateBookingStatus('confirmed'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successGreen,
                  ),
                  child: const Text('Confirm Booking'),
                ),
              ),
              const SizedBox(width: 16),
            ],
            if (canComplete) ...[
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _updateBookingStatus('completed'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryTeal,
                  ),
                  child: const Text('Mark Complete'),
                ),
              ),
              const SizedBox(width: 16),
            ],
            if (canCancel)
              Expanded(
                child: OutlinedButton(
                  onPressed: _showCancelDialog,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.errorRed,
                    side: const BorderSide(color: AppTheme.errorRed),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return AppTheme.warningYellow;
      case 'confirmed':
        return AppTheme.successGreen;
      case 'cancelled':
        return AppTheme.errorRed;
      case 'completed':
        return AppTheme.primaryTeal;
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.schedule;
      case 'confirmed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      case 'completed':
        return Icons.done_all;
      default:
        return Icons.info;
    }
  }

  String _getStatusDescription(String status) {
    switch (status) {
      case 'pending':
        return 'Waiting for teacher confirmation';
      case 'confirmed':
        return 'Booking confirmed, ready to start';
      case 'cancelled':
        return 'This booking has been cancelled';
      case 'completed':
        return 'Session completed successfully';
      default:
        return 'Unknown status';
    }
  }
}
