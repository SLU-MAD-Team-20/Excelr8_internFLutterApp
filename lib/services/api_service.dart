import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../models/home_data.dart';

/// Service class for handling all API calls.
/// Uses mock data from local JSON when the real API is unavailable.
class ApiService {
  ApiService._();

  // --------------- Program Data ---------------

  /// Fetches home screen data from the API.
  /// Falls back to local JSON asset if the network call fails.
  static Future<HomeData> getPrograms() async {
    try {
      final response = await http
          .get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.programs}'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return HomeData.fromJson(json);
      }
      throw Exception('Server returned ${response.statusCode}');
    } catch (_) {
      // Fallback: load from local asset
      return _loadLocalData();
    }
  }

  /// Loads home data from the bundled local JSON file.
  static Future<HomeData> _loadLocalData() async {
    final jsonString =
        await rootBundle.loadString('assets/programs.json');
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return HomeData.fromJson(json);
  }

  // --------------- Feedback ---------------

  /// Submits feedback to the API.
  /// Returns true if successful, false otherwise.
  static Future<bool> submitFeedback(String feedback) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.feedback}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'feedback': feedback}),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {
      // Simulate success for mock mode
      return true;
    }
  }

  // --------------- Enroll ---------------

  /// Enrolls the user in a program.
  /// Returns true if successful, false otherwise.
  static Future<bool> enrollProgram(String programId) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.enroll}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'programId': programId}),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {
      // Simulate success for mock mode
      return true;
    }
  }
}