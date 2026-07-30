library;

class SuccessItem {
  final String value;
  final String title;

  const SuccessItem({required this.value, required this.title});
}

class InternshipData {
  final String title;
  final String description;

  const InternshipData({required this.title, required this.description});
}

class AnnouncementData {
  final String title;
  final String subtitle;

  const AnnouncementData({required this.title, required this.subtitle});
}

class HomeData {
  final List<SuccessItem> successItems;
  final InternshipData internship;
  final AnnouncementData announcement;

  const HomeData({
    required this.successItems,
    required this.internship,
    required this.announcement,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      successItems: [
        SuccessItem(value: json['scholarships'] as String? ?? '0', title: 'My Scholarships'),
        SuccessItem(value: json['skills'] as String? ?? '0', title: 'My Skills'),
        SuccessItem(value: json['badges'] as String? ?? '0', title: 'My Badges'),
        SuccessItem(value: json['experiences'] as String? ?? '0', title: 'My Experiences'),
      ],
      internship: InternshipData(
        title: json['internshipTitle'] as String? ?? '',
        description: json['internshipDescription'] as String? ?? '',
      ),
      announcement: AnnouncementData(
        title: json['announcementTitle'] as String? ?? '',
        subtitle: json['announcementSubtitle'] as String? ?? '',
      ),
    );
  }
}
