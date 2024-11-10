import 'dart:convert';
import 'package:http/http.dart' as http;
import '/auth/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportService {
  static const String baseUrl = Constants.apiBaseUrl;

  static Future<List<dynamic>> getReportedItems(String type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    final response = await http.get(Uri.parse('$baseUrl/admin/v1/reports/$type/list'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        });
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      throw Exception('Failed to load reported items');
    }
  }

  static Future<List<dynamic>> getReports(String type, String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    final response = await http.get(Uri.parse('$baseUrl/admin/v1/reports/$type/list/$id'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        });
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      throw Exception('Failed to load reports');
    }
  }

  static Future<dynamic> getReportDetail(String type, String reportId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    final response = await http.get(Uri.parse('$baseUrl/admin/v1/reports/${type}/${reportId}'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        });
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      print("getReportDetail: $data");
      return data;
    } else {
      throw Exception('Failed to load report detail');
    }
  }

  static Future<bool> lockReportedItem(String type, String id, String reason) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    final response = await http.put(Uri.parse('$baseUrl/admin/v1/reports/$type/lock/$id'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(reason));
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      print("lockReportedItem: $data");
      return data;
    } else {
      throw Exception('Failed to lock reported item');
    }
  }

  static Future<bool> alertReportedItem(String type, String id, String reason) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    final response = await http.put(Uri.parse('$baseUrl/admin/v1/reports/$type/warn/$id'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(reason));
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      print("alertReportedItem: $data");
      return data;
    } else {
      throw Exception('Failed to warn reported item');
    }
  }

  static Future<bool> ignoreReportedItem(String type, String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    final response = await http.put(Uri.parse('$baseUrl/admin/v1/reports/$type/ignore/$id'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        });
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      print("ignoreReportedItem: $data");
      return data;
    } else {
      throw Exception('Failed to ignore reported item');
    }
  }
}
