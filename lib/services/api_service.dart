import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../models/home_data.dart';

class ApiService {
  ApiService._();

  static Future<HomeData> getHomeData() async {
    try {
      final response = await http
          .get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.homescreen}'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List<dynamic>;
        if (json.isNotEmpty) {
          return HomeData.fromJson(json.first as Map<String, dynamic>);
        }
      }
      throw Exception('Server returned ${response.statusCode}');
    } catch (_) {
      return _loadLocalData();
    }
  }

  static Future<HomeData> _loadLocalData() async {
    final jsonString =
        await rootBundle.loadString('assets/programs.json');
    final json = jsonDecode(jsonString) as List<dynamic>;
    if (json.isNotEmpty) {
      return HomeData.fromJson(json.first as Map<String, dynamic>);
    }
    return const HomeData(
      successItems: [],
      internship: InternshipData(title: '', description: ''),
      announcement: AnnouncementData(title: '', subtitle: ''),
    );
  }

  static Future<bool> submitFeedback(String feedback) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.homescreen}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'feedback': feedback}),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {
      return true;
    }
  }
}
