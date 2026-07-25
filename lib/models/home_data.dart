library;

/// Represents a single success stat (e.g., My Scholarships, My Skills).
class SuccessItem {
  final String value;
  final String title;

  const SuccessItem({required this.value, required this.title});

  factory SuccessItem.fromJson(Map<String, dynamic> json) {
    return SuccessItem(
      value: json['value'] as String? ?? '',
      title: json['title'] as String? ?? '',
    );
  }
}

/// Represents the internship card data.
class InternshipData {
  final String title;
  final String description;

  const InternshipData({required this.title, required this.description});

  factory InternshipData.fromJson(Map<String, dynamic> json) {
    return InternshipData(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

/// Represents a single announcement item.
class AnnouncementData {
  final String title;
  final String subtitle;

  const AnnouncementData({required this.title, required this.subtitle});

  factory AnnouncementData.fromJson(Map<String, dynamic> json) {
    return AnnouncementData(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
    );
  }
}

/// Root model that holds all home screen data parsed from JSON.
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
      successItems: (json['success'] as List<dynamic>?)
              ?.map((item) => SuccessItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      internship: InternshipData.fromJson(
          json['internship'] as Map<String, dynamic>? ?? {}),
      announcement: AnnouncementData.fromJson(
          json['announcement'] as Map<String, dynamic>? ?? {}),
    );
  }
}