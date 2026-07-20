import 'package:flutter/material.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: const ListTile(
        contentPadding: EdgeInsets.all(12),

        leading: Icon(
          Icons.notifications,
          color: Colors.blue,
        ),

        title: Text(
          "New Flutter module released",
        ),

        subtitle: Text(
          "Internship applications now open",
        ),
      ),
    );
  }
}