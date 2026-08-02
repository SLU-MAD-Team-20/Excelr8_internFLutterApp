import '../models/home_data.dart';
import 'firestore_service.dart';

class ApiService {
  ApiService._();

  static Future<HomeData> getHomeData() async {
    return FirestoreService.getUserHomeData();
  }

  static Future<bool> submitFeedback(String feedback) async {
    try {
      await FirestoreService.submitFeedback(feedback);
      return true;
    } catch (_) {
      return false;
    }
  }
}
