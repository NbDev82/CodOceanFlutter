// lib/utils/jwt_helper.dart
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class JWTHelper {
  static bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  static Map<String, dynamic> decodeToken(String token) {
    return JwtDecoder.decode(token);
  }

  static DateTime getExpirationDate(String token) {
    return JwtDecoder.getExpirationDate(token);
  }
}