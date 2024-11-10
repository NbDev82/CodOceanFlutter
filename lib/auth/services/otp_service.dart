import 'dart:convert';
import 'package:http/http.dart' as http;

class OTPService {
  final String baseUrl;

  OTPService({required this.baseUrl});

  Future<void> sendOTP(String phoneNumber) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phoneNumber}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send OTP');
    }
  }

  Future<bool> verifyOTP(String phoneNumber, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phoneNumber, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['success'];
    } else {
      throw Exception('Failed to verify OTP');
    }
  }
}