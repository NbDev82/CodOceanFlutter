// lib/models/otp.dart
class OTP {
  final String code;
  final DateTime expiry;

  OTP({
    required this.code,
    required this.expiry,
  });

  // Phương thức để chuyển đổi từ JSON sang OTP
  factory OTP.fromJson(Map<String, dynamic> json) {
    return OTP(
      code: json['code'],
      expiry: DateTime.parse(json['expiry']),
    );
  }

  // Phương thức để chuyển đổi từ OTP sang JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'expiry': expiry.toIso8601String(),
    };
  }
}