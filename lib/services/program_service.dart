import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/program.dart';

class ProgramService {
  // The URL of the public Mock API server
  static const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';

  // Async function that returns a Future holding a list of Program objects
  static Future<List<Program>> fetchPrograms() async {
    try {
      // 1. Send the HTTP GET request to the Mock API URL
      final response = await http.get(Uri.parse(apiUrl));

      // 2. Check if the server responded successfully (Status Code 200 = OK)
      if (response.statusCode == 200) {
        // Decode the raw JSON string into a Dart List
        List<dynamic> jsonList = jsonDecode(response.body);

        // Take 10 items from the list and map each JSON item into a Program object
        return jsonList.take(10).map((json) => Program.fromJson(json)).toList();
      } else {
        // If the server responded with an error (e.g., 404 or 500)
        throw Exception('Server returned error code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch network errors (e.g., no internet connection)
      throw Exception('Failed to fetch programs: $e');
    }
  }
}
