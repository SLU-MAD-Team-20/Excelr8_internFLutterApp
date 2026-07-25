/// API configuration constants.
/// Replace the base URL with your actual API server address.
class ApiConstants {
  ApiConstants._();

  // --------------- Base URL ---------------

  /// MockAPI base URL.
  static const String baseUrl = 'https://6a648a5db30b52361e1b1db9.mockapi.io';

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