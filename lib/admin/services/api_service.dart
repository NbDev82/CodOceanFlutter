import 'dart:convert';
import 'package:http/http.dart' as http;
import '/auth/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = Constants.apiBaseUrl;

  static Future<List<dynamic>> getUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    final response = await http.get(Uri.parse('$baseUrl/admin/v1/account/view-users'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        });
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<dynamic> getUserDetail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    final response = await http.get(Uri.parse('$baseUrl/admin/v1/account/view-user/$email'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        });
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load user detail');
    }
  }

  static Future<bool> editRole(String email, String newRole) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    final response = await http.put(Uri.parse('$baseUrl/admin/v1/account/edit-role/$email'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'newRole': newRole,
        }));
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to edit role');
    }
  }

  static Future<bool> lockUser(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    final response = await http.put(Uri.parse('$baseUrl/admin/v1/account/lock-user/$email'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        });
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to lock user');
    }
  }

  static Future<bool> unlockUser(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    final response = await http.put(Uri.parse('$baseUrl/admin/v1/account/unlock-user/$email'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        });
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to unlock user');
    }
  }

  static Future<dynamic> editUser(String email, dynamic profileDTO) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    final response = await http.put(Uri.parse('$baseUrl/admin/v1/account/edit-user/$email'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(profileDTO));
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to edit user');
    }
  }

  static Future<dynamic> getCurrentUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    final response = await http.get(Uri.parse('$baseUrl/user/current'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        });
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to get current user');
    }
  }
}
