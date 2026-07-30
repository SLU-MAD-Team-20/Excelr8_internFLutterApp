class Program {
  final String id;
  final String title;
  final String status;
  final int registeredCount;
  final double progress;

  Program({
    required this.id,
    required this.title,
    required this.status,
    required this.registeredCount,
    required this.progress,
  });

  // Factory constructor: Converts JSON map from the API into a Program object
  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Untitled Program',
      // The Mock API provides 'id' and 'title'. We assign status, count,
      // and progress dynamically based on the ID so every program looks unique.
      status: (json['id'] % 2 == 0) ? 'ACTIVE' : 'DRAFT',
      registeredCount: (json['id'] * 7) as int,
      progress: ((json['id'] * 15) % 100) / 100.0,
    );
  }
}
