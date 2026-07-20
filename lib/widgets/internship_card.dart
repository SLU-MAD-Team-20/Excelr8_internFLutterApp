import 'package:flutter/material.dart';

class InternshipCard extends StatelessWidget {
  const InternshipCard({super.key});

  @override
  Widget build(BuildContext context) {
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

        title: const Text(
          "Flutter Development",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: const Text(
          "Description\n--------------------",
        ),

        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}