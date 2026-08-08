import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/program.dart';
import '../services/firestore_service.dart';
import '../constants/app_constants.dart';
import 'program_details_screen.dart';

class ProgramListScreen extends StatefulWidget {
  const ProgramListScreen({super.key});
  @override
  State<ProgramListScreen> createState() => _ProgramListScreenState();
}

class _ProgramListScreenState extends State<ProgramListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'newest';
  static const int _maxEnrollments = 3;

  bool get _isAdmin =>
      adminEmails.contains(FirebaseAuth.instance.currentUser?.email);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Program> _filterAndSort(List<Program> programs) {
    var filtered = programs.where((p) {
      if (_searchQuery.isEmpty) return true;
      return p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    switch (_sortBy) {
      case 'newest':
        break; // Firestore returns newest last, reverse below
      case 'alphabetical':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'most_enrolled':
        filtered.sort((a, b) => b.registeredCount.compareTo(a.registeredCount));
        break;
    }
    return filtered;
  }

  void _showAddProgramDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final startDateController = TextEditingController();
    int durationWeeks = 8;
    String selectedStatus = 'ACTIVE';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add New Program'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Program Title *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description *',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      'Duration (weeks):',
                      style: TextStyle(fontSize: 14),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => setDialogState(() {
                        if (durationWeeks > 1) durationWeeks--;
                      }),
                    ),
                    Text(
                      '$durationWeeks',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => setDialogState(() => durationWeeks++),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: startDateController,
                  decoration: const InputDecoration(
                    labelText: 'Start Date (e.g. August 2026)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'ACTIVE', child: Text('ACTIVE')),
                    DropdownMenuItem(value: 'DRAFT', child: Text('DRAFT')),
                  ],
                  onChanged: (val) =>
                      setDialogState(() => selectedStatus = val!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.trim().isEmpty ||
                    descriptionController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(
                      content: Text('Title and description are required'),
                    ),
                  );
                  return;
                }
                await FirestoreService.addProgram(
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  durationWeeks: durationWeeks,
                  startDate: startDateController.text.trim().isEmpty
                      ? 'TBD'
                      : startDateController.text.trim(),
                  status: selectedStatus,
                );
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Add Program'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Program program) {
    if (program.enrolledUsers.isNotEmpty) {
      // Guard: can't delete program with enrolled users
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.orange),
              SizedBox(width: 8),
              Text('Cannot Delete'),
            ],
          ),
          content: Text(
            '"${program.title}" has ${program.enrolledUsers.length} enrolled user${program.enrolledUsers.length == 1 ? '' : 's'}.\n\nAsk users to unenroll before deleting this program.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Program'),
        content: Text('Are you sure you want to delete "${program.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirestoreService.deleteProgram(program.id);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _handleEnroll(Program program, List<Program> allPrograms) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final isEnrolled = program.enrolledUsers.contains(uid);

    if (!isEnrolled) {
      // Check enrollment limit
      final enrolledCount = allPrograms
          .where((p) => p.enrolledUsers.contains(uid))
          .length;
      if (enrolledCount >= _maxEnrollments) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You can only enroll in $_maxEnrollments programs at a time.',
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProgramDetailsScreen(program: program)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Programs'), centerTitle: true),
      body: StreamBuilder<List<Program>>(
        stream: FirestoreService.programsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final allPrograms = snapshot.data ?? [];
          final programs = _filterAndSort(allPrograms);
          final activeCount = allPrograms
              .where((p) => p.status == 'ACTIVE')
              .length;
          final draftCount = allPrograms
              .where((p) => p.status == 'DRAFT')
              .length;
          final uid = FirebaseAuth.instance.currentUser?.uid;
          final myEnrollmentCount = uid == null
              ? 0
              : allPrograms.where((p) => p.enrolledUsers.contains(uid)).length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Metrics
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMetricCard(
                      context,
                      'Total',
                      '${allPrograms.length}',
                      Colors.blue,
                      isDark,
                    ),
                    _buildMetricCard(
                      context,
                      'Active',
                      '$activeCount',
                      Colors.green,
                      isDark,
                    ),
                    _buildMetricCard(
                      context,
                      'Draft',
                      '$draftCount',
                      Colors.orange,
                      isDark,
                    ),
                  ],
                ),

                // Enrollment limit indicator for users
                if (!_isAdmin && uid != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: myEnrollmentCount >= _maxEnrollments
                          ? Colors.orange.withValues(alpha: 0.12)
                          : Colors.blue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: myEnrollmentCount >= _maxEnrollments
                            ? Colors.orange.withValues(alpha: 0.4)
                            : Colors.blue.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          myEnrollmentCount >= _maxEnrollments
                              ? Icons.warning_amber
                              : Icons.info_outline,
                          size: 16,
                          color: myEnrollmentCount >= _maxEnrollments
                              ? Colors.orange
                              : Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Enrolled: $myEnrollmentCount / $_maxEnrollments programs',
                          style: TextStyle(
                            fontSize: 13,
                            color: myEnrollmentCount >= _maxEnrollments
                                ? Colors.orange
                                : Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Search bar
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search programs...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Sort + Admin button row
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _sortBy,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.sort, size: 18),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'newest',
                            child: Text('Newest'),
                          ),
                          DropdownMenuItem(
                            value: 'alphabetical',
                            child: Text('A-Z'),
                          ),
                          DropdownMenuItem(
                            value: 'most_enrolled',
                            child: Text('Most Enrolled'),
                          ),
                        ],
                        onChanged: (val) => setState(() => _sortBy = val!),
                      ),
                    ),
                    if (_isAdmin) ...[
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: _showAddProgramDialog,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 13,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                if (programs.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 56,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'No programs match "$_searchQuery"'
                                : 'No programs yet',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: programs.length,
                    itemBuilder: (context, index) {
                      final program = programs[index];
                      final isActive = program.status == 'ACTIVE';
                      final isEnrolled =
                          uid != null && program.enrolledUsers.contains(uid);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  program.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${program.registeredCount} registered • ${program.durationWeeks} weeks',
                                    ),
                                    if (program.description.isNotEmpty)
                                      Text(
                                        program.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Chip(
                                      label: Text(
                                        program.status,
                                        style: TextStyle(
                                          color: isActive
                                              ? Colors.green.shade700
                                              : Colors.grey.shade600,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
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
                                    if (_isAdmin) ...[
                                      const SizedBox(width: 4),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                        onPressed: () =>
                                            _confirmDelete(program),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: program.progress,
                                  minHeight: 6,
                                  backgroundColor: Colors.blue.withValues(
                                    alpha: 0.15,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (isEnrolled && !_isAdmin)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withValues(
                                          alpha: 0.12,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            size: 14,
                                            color: Colors.green,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Enrolled',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    const SizedBox(),
                                  OutlinedButton(
                                    onPressed: () => _isAdmin
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  ProgramDetailsScreen(
                                                    program: program,
                                                  ),
                                            ),
                                          )
                                        : _handleEnroll(program, allPrograms),
                                    child: const Text('View Details'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}
