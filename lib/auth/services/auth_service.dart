// lib/services/auth_service.dart
import 'dart:convert';
import 'package:codoceanflutter/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/auth/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/core/constants/http_status.dart';
import 'package:provider/provider.dart';


class AuthService with ChangeNotifier {
  final String baseUrl;

  AuthService() : baseUrl = Constants.apiBaseUrl;

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/v1/sign-in'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == HttpStatus.OK) {
      try {
        final responseData = jsonDecode(response.body);
        print(responseData['role']);
        if (responseData['role'].trim() != 'ADMIN') {
          throw Exception('Not a admin');
        }

        if (responseData['message'] != 'user.login.login_successfully') {
          throw Exception('Login failed');
        }
        
        final accessToken = responseData['accessToken'];
        final refreshToken = responseData['refreshToken'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setString('refresh_token', refreshToken);

        final userData = await http.get(Uri.parse('$baseUrl/user/current'),
            headers: {'Authorization': 'Bearer $accessToken'});
        if (userData.statusCode == HttpStatus.OK) {
          final userDataJson = jsonDecode(userData.body);
          Provider<AuthProvider>(create: (_) => AuthProvider(userData: userDataJson));
        } else {
          throw Exception('Failed to fetch user data');
        }

        return true;
      } catch (e) {
        print('Error during login: $e');
        return false;
      }
    } else {
      throw Exception('Auth not match!');
    }
  }

  Future<bool> forgotPassword(String email, String newPassword, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/v1/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'newPassword': newPassword, 'otp': otp}),
    );

    if (response.statusCode != HttpStatus.OK) {
      throw Exception('Failed to reset password');
    }

    return true;
  }

  Future<bool> requestOTP(String email) async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/v1/request-otp?email=$email'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != HttpStatus.CREATED) {
      throw Exception('Failed to request OTP');
    }
    return true;
  }
}