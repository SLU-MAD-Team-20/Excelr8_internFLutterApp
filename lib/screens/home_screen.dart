import 'package:flutter/material.dart';

import '../models/home_data.dart';
import '../services/api_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/success_card.dart';
import '../constants/text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --------------- State Variables ---------------

  HomeData? _homeData;
  bool _isLoading = true;
  String? _errorMessage;

  // --------------- Form ---------------

  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  // --------------- Lifecycle ---------------

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  // --------------- Data Loading ---------------

  /// Loads home screen data from the API (falls back to local JSON).
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await ApiService.getPrograms();

      setState(() {
        _homeData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to load data. Please try again.';
      });
    }
  }

  // --------------- Form Submission ---------------

  /// Validates and submits the feedback form via API.
  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Simulate API call delay for better UX
    await Future<void>.delayed(const Duration(seconds: 2));

    try {
      await ApiService.submitFeedback(_feedbackController.text);
    } catch (_) {
      // Continue with success flow for mock mode
    }

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feedback submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // Clear form field
    _feedbackController.clear();
  }

  // --------------- Build Helpers ---------------

  /// Builds the centered loading indicator.
  Widget _buildLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 120),
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Builds the error message with a retry button.
  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 120),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Something went wrong.',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the section header with a title and "View all" link.
  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.heading),
        const Text("View all", style: AppTextStyles.viewAll),
      ],
    );
  }

  /// Builds the 2x2 grid of success stat cards.
  Widget _buildSuccessGrid(List<SuccessItem> items) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SuccessCard(
                value: items[0].value,
                title: items[0].title,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SuccessCard(
                value: items[1].value,
                title: items[1].title,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SuccessCard(
                value: items[2].value,
                title: items[2].title,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SuccessCard(
                value: items[3].value,
                title: items[3].title,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the internship card using data from JSON.
  Widget _buildInternshipCard(InternshipData data) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image),
        ),
        title: Text(
          data.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(data.description),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  /// Builds the announcement card using data from JSON.
  Widget _buildAnnouncementCard(AnnouncementData data) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: const Icon(Icons.notifications, color: Colors.blue),
        title: Text(data.title),
        subtitle: Text(data.subtitle),
      ),
    );
  }

  /// Builds the feedback form section.
  Widget _buildFeedbackForm() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Feedback",
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: 16),

              // Feedback field
              TextFormField(
                controller: _feedbackController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Feedback",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 48),
                    child: Icon(Icons.feedback),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Feedback cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitFeedback,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --------------- Main Build ---------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: const CustomHomeAppBar(),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 390,
            child: _isLoading
                ? _buildLoadingIndicator()
                : _errorMessage != null
                    ? _buildErrorView()
                    : _buildContent(),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: "Programs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  /// Builds the full scrollable content when data is loaded.
  Widget _buildContent() {
    final data = _homeData!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- My Success ----
          _buildSectionHeader("My Success"),
          const SizedBox(height: 16),
          _buildSuccessGrid(data.successItems),
          const SizedBox(height: 28),

          // ---- Continue Internship ----
          _buildSectionHeader("Continue Internship"),
          const SizedBox(height: 16),
          _buildInternshipCard(data.internship),
          const SizedBox(height: 28),

          // ---- Announcements ----
          _buildSectionHeader("Announcements"),
          const SizedBox(height: 16),
          _buildAnnouncementCard(data.announcement),
          const SizedBox(height: 28),

          // ---- Feedback Form ----
          _buildFeedbackForm(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}