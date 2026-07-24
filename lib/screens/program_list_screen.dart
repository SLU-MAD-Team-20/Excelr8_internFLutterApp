import 'package:flutter/material.dart';
import '../models/program.dart';
import '../service/program_service.dart';
import 'program_details_screen.dart';

class ProgramListScreen extends StatefulWidget {
  const ProgramListScreen({super.key});

  @override
  State<ProgramListScreen> createState() => _ProgramListScreenState();
}

class _ProgramListScreenState extends State<ProgramListScreen> {
  // Store the future returned by our service
  late Future<List<Program>> _programsFuture;

  @override
  void initState() {
    super.initState();
    // 1. Fetch data from the Mock API when the screen initializes
    _programsFuture = ProgramService.fetchPrograms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Management'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      // 2. FutureBuilder listens to the network request state
      body: FutureBuilder<List<Program>>(
        future: _programsFuture,
        builder: (context, snapshot) {
          // STATE 1: Waiting for API response (Show loading spinner)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // STATE 2: API returned an error (Show error message)
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading programs: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          // STATE 3: Success! We have list data from the API
          final programs = snapshot.data ?? [];
          final activeCount = programs
              .where((p) => p.status == 'ACTIVE')
              .length;
          final draftCount = programs.where((p) => p.status == 'DRAFT').length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP METRICS / ANALYTICS (Calculated from dynamic API data)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMetricCard('Total Programs', '${programs.length}'),
                    _buildMetricCard('Active', '$activeCount'),
                    _buildMetricCard('Draft', '$draftCount'),
                  ],
                ),
                const SizedBox(height: 16),

                // CREATE PROGRAM BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Form trigger
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('CREATE NEW PROGRAM'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // DYNAMIC PROGRAM LIST
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: programs.length,
                  itemBuilder: (context, index) {
                    final program = programs[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
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
                              subtitle: Text(
                                '${program.registeredCount} registered',
                              ),
                              trailing: Chip(label: Text(program.status)),
                            ),
                            LinearProgressIndicator(value: program.progress),
                            const SizedBox(height: 12),

                            // NAVIGATION TO DETAILS SCREEN
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                           builder: (context) => ProgramDetailsScreen(program: program),
                                      ),
                                    );
                                  },
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

  Widget _buildMetricCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
