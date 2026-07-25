library;

class Program {
  final String id;
  final String title;
  final String status;
  final int registeredCount;
  final String progress;

  const Program({
    required this.id,
    required this.title,
    required this.status,
    required this.registeredCount,
    required this.progress,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      status: json['status'] as String? ?? '',
      registeredCount: int.tryParse(json['registeredCount'].toString()) ?? 0,
      progress: json['progress'] as String? ?? '0',
    );
  }
}
