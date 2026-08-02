class Program {
  final String id;
  final String title;
  final String status;
  final int registeredCount;
  final double progress;
  final String description;
  final int durationWeeks;
  final String startDate;
  final List<String> enrolledUsers;

  Program({
    required this.id,
    required this.title,
    required this.status,
    required this.registeredCount,
    required this.progress,
    this.description = '',
    this.durationWeeks = 8,
    this.startDate = 'TBD',
    this.enrolledUsers = const [],
  });
}
