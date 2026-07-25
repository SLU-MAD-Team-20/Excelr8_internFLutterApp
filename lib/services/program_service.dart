import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/program_model.dart';

class ProgramService {
  final String baseUrl =
      'https://6a648a5db30b52361e1b1db9.mockapi.io';

  Future<List<ProgramModel>> getPrograms() async {
    final response = await http.get(Uri.parse('$baseUrl/programs'));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map((json) => ProgramModel.fromJson(json))
            .toList();
      }

      if (decoded is Map<String, dynamic>) {
        final listData = decoded['value'] ?? decoded['data'] ?? decoded['programs'];

        if (listData is List) {
          return listData
              .whereType<Map<String, dynamic>>()
              .map((json) => ProgramModel.fromJson(json))
              .toList();
        }

        if (listData is Map<String, dynamic>) {
          return [ProgramModel.fromJson(listData)];
        }
      }

      throw Exception('Unexpected response format for programs');
    } else {
      throw Exception('Failed to load programs');
    }
  }

  Future<ProgramModel?> getProgramById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/programs/$id'));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return ProgramModel.fromJson(decoded);
      }

      if (decoded is List && decoded.isNotEmpty) {
        final firstItem = decoded.first;
        if (firstItem is Map<String, dynamic>) {
          return ProgramModel.fromJson(firstItem);
        }
      }

      throw Exception('Unexpected response format for program detail');
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load program details');
    }
  }
}