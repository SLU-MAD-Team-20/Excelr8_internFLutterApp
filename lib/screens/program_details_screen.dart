import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/program.dart';
import '../services/firestore_service.dart';
import '../constants/app_constants.dart';

class ProgramDetailsScreen extends StatefulWidget {
  final Program program;
  const ProgramDetailsScreen({super.key, required this.program});

  @override
  State<ProgramDetailsScreen> createState() => _ProgramDetailsScreenState();
}

class _ProgramDetailsScreenState extends State<ProgramDetailsScreen> {
  bool _isLoading = false;

  bool get _isAdmin =>
      adminEmails.contains(FirebaseAuth.instance.currentUser?.email);

  bool get _isEnrolled {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return uid != null && widget.program.enrolledUsers.contains(uid);
  }

  Future<void> _toggleEnroll() async {
    setState(() => _isLoading = true);
    try {
      if (_isEnrolled) {
        await FirestoreService.unenrollFromProgram(widget.program.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully unenrolled'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        await FirestoreService.enrollInProgram(widget.program.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully enrolled!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActive = widget.program.status == 'ACTIVE';

    return Scaffold(
      appBar: AppBar(title: const Text('Program Details'), centerTitle: true),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1565C0), const Color(0xFF0D47A1)]
                      : [Colors.blue.shade300, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school, size: 70, color: Colors.white),
                  const SizedBox(height: 8),
                  if (_isEnrolled && !_isAdmin)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Enrolled',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              widget.program.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Chip(
                  label: Text(
                    widget.program.status,
                    style: TextStyle(
                      color: isActive
                          ? Colors.green.shade700
                          : Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: isActive
                      ? Colors.green.withValues(alpha: 0.15)
                      : Colors.grey.withValues(alpha: 0.15),
                  side: BorderSide(
                    color: isActive
                        ? Colors.green.shade400
                        : Colors.grey.shade400,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.people_outline,
                  size: 16,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 4),
                Text(
                  '${widget.program.registeredCount} registered',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progress',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${(widget.program.progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: widget.program.progress,
                minHeight: 10,
                backgroundColor: Colors.blue.withValues(alpha: 0.15),
              ),
            ),
            const SizedBox(height: 24),

            _buildInfoRow(
              context,
              icon: Icons.timer_outlined,
              label: 'Duration',
              value: '${widget.program.durationWeeks} weeks',
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.play_circle_outline,
              label: 'Start Date',
              value: widget.program.startDate,
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              icon: Icons.info_outline,
              label: 'Description',
              value: widget.program.description.isNotEmpty
                  ? widget.program.description
                  : 'No description provided.',
              isDark: isDark,
            ),
            const SizedBox(height: 32),

            // Hide enroll button for admin
            if (!_isAdmin)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: widget.program.status == 'DRAFT' || _isLoading
                      ? null
                      : _toggleEnroll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isEnrolled ? Colors.orange : Colors.blue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.program.status == 'DRAFT'
                              ? 'Not Available Yet'
                              : _isEnrolled
                              ? 'Unenroll'
                              : 'Enroll Now',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
