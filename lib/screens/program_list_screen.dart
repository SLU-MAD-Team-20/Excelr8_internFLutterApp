import 'package:flutter/material.dart';
import 'models/program.dart';
import 'program_details_screen.dart'; // existing details screen

class ProgramListScreen extends StatelessWidget {
  const ProgramListScreen({Super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Management'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TOP METRICS / ANALYTICS CARD
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMetricCard('Total Programs', '${dummyPrograms.length}'),
                _buildMetricCard('Active', '${dummyPrograms.where((p) => p.status == "ACTIVE").length}'),
                _buildMetricCard('Draft', '${dummyPrograms.where((p) => p.status == "DRAFT").length}'),
            ),
            const SizedBox(height: 16),

            // 2. CREATE PROGRAM BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Add program trigger
                },
                icon: const Icon(Icons.add),
                label: const Text('CREATE NEW PROGRAM'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. PROGRAM LIST
            ListView.builder(
              shrinkWrap: true, // Needed inside SingleChildScrollView
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dummyPrograms.length,
              itemBuilder: (context, index) {
                final program = dummyPrograms[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(program.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${program.registeredCount} registered'),
                          trailing: Chip(label: Text(program.status)),
                        ),
                        LinearProgressIndicator(value: program.progress),
                        const SizedBox(height: 12),
                        
                        // 4. NAVIGATION ACTION (TO PROGRAM DETAILS)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProgramDetailsScreen(),
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
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}