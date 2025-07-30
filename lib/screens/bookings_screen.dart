import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../models/booking_model.dart';
import '../providers/auth_provider.dart';
import '../services/supabase_service.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_message.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Booking> _myBookings = [];
  List<Booking> _myTeachingBookings = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.currentUser != null) {
        final userId = authProvider.currentUser!.id;
        final bookingsAsStudent = await SupabaseService.getBookingsAsStudent(userId);
        final bookingsAsTeacher = await SupabaseService.getBookingsAsTeacher(userId);

        setState(() {
          _myBookings = bookingsAsStudent;
          _myTeachingBookings = bookingsAsTeacher;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load bookings: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please log in to view your bookings'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'As Student'),
            Tab(text: 'As Teacher'),
          ],
        ),
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : _errorMessage != null
              ? ErrorMessage(
                  message: _errorMessage!,
                  onRetry: _loadBookings,
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBookingsList(_myBookings, isStudentView: true),
                    _buildBookingsList(_myTeachingBookings, isStudentView: false),
                  ],
                ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings, {required bool isStudentView}) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isStudentView ? Icons.event_note_outlined : Icons.school_outlined,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              isStudentView ? 'No bookings as student yet' : 'No teaching bookings yet',
              style: const TextStyle(
                fontSize: 18,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isStudentView
                  ? 'Browse skills and book a session!'
                  : 'Your teaching sessions will appear here.',
              style: const TextStyle(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                // Navigate to booking detail screen
                // context.push('/booking/${booking.id}');
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.skillTitle ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 18, color: AppTheme.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          isStudentView ? 'Teacher: ${booking.teacherName}' : 'Student: ${booking.studentName}',
                          style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18, color: AppTheme.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          'Date: ${booking.bookingDate}',
                          style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 18, color: AppTheme.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          'Time: ${booking.bookingTime}',
                          style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Chip(
                        label: Text(booking.status.toUpperCase()),
                        backgroundColor: _getChipColor(booking.status),
                        labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getChipColor(String status) {
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
}

