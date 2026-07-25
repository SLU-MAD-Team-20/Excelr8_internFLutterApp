/// API configuration constants.
/// Replace the base URL with your actual API server address.
class ApiConstants {
  ApiConstants._();

  // --------------- Base URL ---------------

  /// Replace with your actual API base URL.
  static const String baseUrl = 'https://api.example.com/v1';

  // --------------- Endpoints ---------------

  /// Fetches program/home screen data.
  /// GET {baseUrl}/programs
  static const String programs = '/programs';

  /// Enrolls the user in a program.
  /// POST {baseUrl}/enroll
  static const String enroll = '/enroll';

  /// Submits user feedback.
  /// POST {baseUrl}/feedback
  static const String feedback = '/feedback';
}