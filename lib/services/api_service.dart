import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../models/home_data.dart';

class ApiService {
  ApiService._();

  static Future<List<Program>> getPrograms() async {
    try {
      final response = await http
          .get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.programs}'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List<dynamic>;
        return json
            .map((item) => Program.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Server returned ${response.statusCode}');
    } catch (_) {
      return _loadLocalData();
    }
  }

  static Future<List<Program>> _loadLocalData() async {
    final jsonString =
        await rootBundle.loadString('assets/programs.json');
    final json = jsonDecode(jsonString) as List<dynamic>;
    return json
        .map((item) => Program.fromJson(item as Map<String, dynamic>))
        .toList();
  }

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
      return true;
    }
  }

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
      return true;
    }
  }
}
