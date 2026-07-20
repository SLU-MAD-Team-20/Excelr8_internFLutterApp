import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/success_card.dart';
import '../widgets/internship_card.dart';
import '../widgets/announcement_card.dart';
import '../constants/text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),

      appBar: const CustomHomeAppBar(),

      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 390,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  //---------------- My Success ----------------

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "My Success",
                        style: AppTextStyles.heading,
                      ),
                      Text(
                        "View all",
                        style: AppTextStyles.viewAll,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: const [
                      Expanded(
                        child: SuccessCard(
                          value: "\$0",
                          title: "My Scholarships",
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: SuccessCard(
                          value: "0",
                          title: "My Skills",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: const [
                      Expanded(
                        child: SuccessCard(
                          value: "0",
                          title: "My Badges",
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: SuccessCard(
                          value: "0",
                          title: "Experiences",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  //---------------- Continue Internship ----------------

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Continue Internship",
                        style: AppTextStyles.heading,
                      ),
                      Text(
                        "View all",
                        style: AppTextStyles.viewAll,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const InternshipCard(),

                  const SizedBox(height: 28),

                  //---------------- Announcements ----------------

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Announcements",
                        style: AppTextStyles.heading,
                      ),
                      Text(
                        "View all",
                        style: AppTextStyles.viewAll,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const AnnouncementCard(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
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
}