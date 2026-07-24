import 'package:flutter/material.dart';

class ProgramDetailsScreen extends StatelessWidget {
  const ProgramDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Program Details"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.school, size: 100, color: Colors.blue),
            ),

            SizedBox(height: 20),

            Text(
              "Flutter Development Program",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            Text("Duration: 8 Weeks", style: TextStyle(fontSize: 18)),

            SizedBox(height: 10),

            Text("Start Date: August 2026", style: TextStyle(fontSize: 18)),

            SizedBox(height: 20),

            Text(
              "Description",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            Text(
              "Learn Flutter from basics to advanced by building real-world applications with modern UI design.",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Enroll Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
