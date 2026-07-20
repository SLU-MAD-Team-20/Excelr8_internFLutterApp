class Program {
  final String id;
  final String title;
  final String status; // e.g. 'ACTIVE', 'DRAFT', 'CLOSED'
  final int registeredCount;
  final double progress; // e.g., 0.65 for 65%

  Program({
    required this.id,
    required this.title,
    required this.status,
    required this.registeredCount,
    required this.progress,
  });
}

// Sample dummy list to display on your screen
final List<Program> dummyPrograms = [
  Program(
    id: '1',
    title: 'Program Alpha',
    status: 'ACTIVE',
    registeredCount: 45,
    progress: 0.65,
  ),
  Program(
    id: '2',
    title: 'Leadership Series',
    status: 'DRAFT',
    registeredCount: 12,
    progress: 0.20,
  ),
  Program(
    id: '3',
    title: 'Program Gamma',
    status: 'ACTIVE',
    registeredCount: 89,
    progress: 0.90,
  ),
];
