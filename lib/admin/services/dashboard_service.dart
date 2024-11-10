import 'package:http/http.dart' as http;
import 'dart:convert';
import '/auth/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardService {
  static const String baseUrl = Constants.apiBaseUrl;
  static const String apiPrefix = '/admin/v1/dashboard';
  
  static Future<String> _getAccessToken() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('access_token') ?? '';
  }

  static Future<List<Map<String, int>>> fetchMonthlyPosts(String year) async {
      final String accessToken = await _getAccessToken();
      final response = await http.get(
          Uri.parse('$baseUrl$apiPrefix/posts/monthly?year=$year'),
          headers: {
              'Authorization': 'Bearer $accessToken',
          }
      );
      if (response.statusCode == 200) {
          return json.decode(response.body).map<Map<String, int>>((e) => Map<String, int>.from(e)).toList();
      } else {
          throw Exception('Failed to load monthly posts');
      }
  }

  static Future<List<Map<String, int>>> fetchTotalUsersMonthly(String year) async {
      final String accessToken = await _getAccessToken();
      final response = await http.get(
          Uri.parse('$baseUrl$apiPrefix/users/total/monthly?year=$year'),
          headers: {
              'Authorization': 'Bearer $accessToken',
          }
      );
      if (response.statusCode == 200) {
          return json.decode(response.body).map<Map<String, int>>((e) => Map<String, int>.from(e)).toList();
      } else {
          throw Exception('Failed to load total users monthly');
      }
  }

  static Future<List<Map<String, int>>> fetchNewUsersMonthly(String year) async {
      final String accessToken = await _getAccessToken();
      final response = await http.get(
          Uri.parse('$baseUrl$apiPrefix/users/new/monthly?year=$year'),
          headers: {
              'Authorization': 'Bearer $accessToken',
          }
      );
      if (response.statusCode == 200) {
          return json.decode(response.body).map<Map<String, int>>((e) => Map<String, int>.from(e)).toList();
      } else {
          throw Exception('Failed to load new users monthly');
      }
  }
}
