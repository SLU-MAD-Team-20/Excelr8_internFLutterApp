import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/program.dart';
import '../models/home_data.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;

  // ─────────────────────────────────────────
  // PROGRAMS
  // ─────────────────────────────────────────

  static Stream<List<Program>> programsStream() {
    return _db.collection('programs').snapshots().map((snapshot) {
      return snapshot.docs.map<Program>((doc) {
        final data = doc.data();
        return Program(
          id: doc.id,
          title: data['title'] ?? 'Untitled',
          status: data['status'] ?? 'ACTIVE',
          registeredCount: (data['registeredCount'] ?? 0) as int,
          progress: (data['progress'] ?? 0.0).toDouble(),
          description: data['description'] ?? '',
          durationWeeks: (data['durationWeeks'] ?? 8) as int,
          startDate: data['startDate'] ?? 'TBD',
          enrolledUsers: List<String>.from(data['enrolledUsers'] ?? []),
        );
      }).toList();
    });
  }

  static Future<void> addProgram({
    required String title,
    required String description,
    required int durationWeeks,
    required String startDate,
    String status = 'ACTIVE',
  }) async {
    await _db.collection('programs').add({
      'title': title,
      'description': description,
      'durationWeeks': durationWeeks,
      'startDate': startDate,
      'status': status,
      'registeredCount': 0,
      'progress': 0.0,
      'enrolledUsers': [],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> deleteProgram(String id) async {
    await _db.collection('programs').doc(id).delete();
  }

  static Future<void> enrollInProgram(String programId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await _db.collection('programs').doc(programId).update({
      'enrolledUsers': FieldValue.arrayUnion([uid]),
      'registeredCount': FieldValue.increment(1),
    });
  }

  static Future<void> unenrollFromProgram(String programId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await _db.collection('programs').doc(programId).update({
      'enrolledUsers': FieldValue.arrayRemove([uid]),
      'registeredCount': FieldValue.increment(-1),
    });
  }

  // ─────────────────────────────────────────
  // USER DASHBOARD DATA
  // ─────────────────────────────────────────

  static Future<HomeData> getUserHomeData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return _defaultHomeData();

    try {
      final userDoc = await _db.collection('users').doc(uid).get();

      final announcementSnap = await _db
          .collection('announcements')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      final internshipSnap = await _db
          .collection('internships')
          .where('status', isEqualTo: 'ACTIVE')
          .limit(1)
          .get();

      final enrolledSnap = await _db
          .collection('programs')
          .where('enrolledUsers', arrayContains: uid)
          .get();

      final userData = userDoc.data() ?? {};
      final announcement = announcementSnap.docs.isNotEmpty
          ? announcementSnap.docs.first.data()
          : <String, dynamic>{};
      final internship = internshipSnap.docs.isNotEmpty
          ? internshipSnap.docs.first.data()
          : <String, dynamic>{};

      return HomeData(
        successItems: [
          SuccessItem(
              value: userData['scholarships'] ?? '\$0',
              title: 'My Scholarships'),
          SuccessItem(
              value: userData['skills']?.toString() ?? '0',
              title: 'My Skills'),
          SuccessItem(
              value: userData['badges']?.toString() ?? '0',
              title: 'My Badges'),
          SuccessItem(
              value: enrolledSnap.docs.length.toString(),
              title: 'Enrolled'),
        ],
        internship: InternshipData(
          title: internship['title'] ?? 'Flutter Development',
          description:
              internship['description'] ?? 'Your active internship',
        ),
        announcement: AnnouncementData(
          title: announcement['title'] ?? 'Welcome to Excelerate',
          subtitle:
              announcement['subtitle'] ?? 'Start your journey today',
        ),
      );
    } catch (e) {
      return _defaultHomeData();
    }
  }

  static Future<void> initUserData(String uid, String username) async {
    final userDoc = _db.collection('users').doc(uid);
    final exists = (await userDoc.get()).exists;
    if (!exists) {
      await userDoc.set({
        'username': username,
        'scholarships': '\$0',
        'skills': 0,
        'badges': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // ─────────────────────────────────────────
  // FEEDBACK
  // ─────────────────────────────────────────

  static Future<void> submitFeedback(String feedback) async {
    final user = FirebaseAuth.instance.currentUser;
    await _db.collection('feedback').add({
      'feedback': feedback,
      'userId': user?.uid,
      'userEmail': user?.email,
      'userName': user?.displayName ?? 'Anonymous',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ─────────────────────────────────────────
  // SEED DATA
  // ─────────────────────────────────────────

  static Future<void> seedInitialData() async {
    final announcementsRef = _db.collection('announcements');
    final existing = await announcementsRef.limit(1).get();
    if (existing.docs.isEmpty) {
      await announcementsRef.add({
        'title': 'New Flutter module released',
        'subtitle': 'Internship applications now open',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    final internshipsRef = _db.collection('internships');
    final existingInternship = await internshipsRef.limit(1).get();
    if (existingInternship.docs.isEmpty) {
      await internshipsRef.add({
        'title': 'Flutter Development',
        'description': 'Build real-world apps using Flutter and Dart.',
        'status': 'ACTIVE',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    final programsRef = _db.collection('programs');
    final existingPrograms = await programsRef.limit(1).get();
    if (existingPrograms.docs.isEmpty) {
      final samplePrograms = [
        {
          'title': 'Flutter Development',
          'description':
              'Learn to build beautiful cross-platform mobile apps using Flutter and Dart from scratch.',
          'durationWeeks': 8,
          'startDate': 'August 2026',
          'status': 'ACTIVE',
          'registeredCount': 24,
          'progress': 0.6,
          'enrolledUsers': [],
        },
        {
          'title': 'React Native Basics',
          'description':
              'Build native mobile apps using React Native and JavaScript. Covers components, navigation, and APIs.',
          'durationWeeks': 6,
          'startDate': 'September 2026',
          'status': 'ACTIVE',
          'registeredCount': 18,
          'progress': 0.3,
          'enrolledUsers': [],
        },
        {
          'title': 'UI/UX Design Fundamentals',
          'description':
              'Master the principles of user interface and experience design using Figma and modern design systems.',
          'durationWeeks': 4,
          'startDate': 'TBD',
          'status': 'DRAFT',
          'registeredCount': 0,
          'progress': 0.0,
          'enrolledUsers': [],
        },
        {
          'title': 'Backend with Node.js',
          'description':
              'Build scalable REST APIs using Node.js, Express, and PostgreSQL with authentication and deployment.',
          'durationWeeks': 10,
          'startDate': 'October 2026',
          'status': 'ACTIVE',
          'registeredCount': 31,
          'progress': 0.8,
          'enrolledUsers': [],
        },
      ];
      for (final program in samplePrograms) {
        await programsRef.add({
          ...program,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  static HomeData _defaultHomeData() {
    return const HomeData(
      successItems: [
        SuccessItem(value: '\$0', title: 'My Scholarships'),
        SuccessItem(value: '0', title: 'My Skills'),
        SuccessItem(value: '0', title: 'My Badges'),
        SuccessItem(value: '0', title: 'Enrolled'),
      ],
      internship: InternshipData(
        title: 'Flutter Development',
        description: 'Build real-world apps using Flutter and Dart.',
      ),
      announcement: AnnouncementData(
        title: 'Welcome to Excelerate',
        subtitle: 'Start your journey today',
      ),
    );
  }
}
