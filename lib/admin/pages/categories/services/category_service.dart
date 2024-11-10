import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '/auth/utils/constants.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class CategoryService {
  static const String baseUrl = Constants.apiBaseUrl;

  static Future<List<dynamic>> getAllCategories() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    final response = await http.get(Uri.parse('$baseUrl/v1/discuss/categories'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        });

    print("response response: $response");
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<dynamic> addCategory(String name, String description, File image) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';

    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/admin/v1/category/add'))
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..fields['name'] = name
      ..fields['description'] = description
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: MediaType('image', 'jpeg'),
      ));

    request.headers['Content-Type'] = 'multipart/form-data';

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final data = jsonDecode(utf8.decode(responseData.bodyBytes));
      return data;
    } else {
      throw Exception('Failed to add category');
    }
  }

  static Future<void> deleteCategory(String id) async {
    print("id id: $id");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('access_token') ?? '';
    final response = await http.delete(Uri.parse('$baseUrl/admin/v1/category/delete/$id'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        });
    if (response.statusCode != 200) {
      throw Exception('Failed to delete category');
    }
  }
}
