class ProgramModel {
  final String id;
  final String title;
  final String status;
  final int registeredCount;
  final String progress;
  final String? description;
  final String? duration;
  final String? startDate;

  ProgramModel({
    required this.id,
    required this.title,
    required this.status,
    required this.registeredCount,
    required this.progress,
    this.description,
    this.duration,
    this.startDate,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return ProgramModel(
      id: data['id']?.toString() ?? '',
      title: data['title']?.toString() ?? 'Untitled Program',
      status: data['status']?.toString() ?? 'Active',
      registeredCount: data['registeredCount'] is int
          ? data['registeredCount'] as int
          : int.tryParse(data['registeredCount']?.toString() ?? '0') ?? 0,
      progress: data['progress']?.toString() ?? '0%',
      description: data['description']?.toString(),
      duration: data['duration']?.toString(),
      startDate: data['startDate']?.toString(),
    );
  }
}