class OTP {
  final String code;
  final DateTime expiry;

  OTP({
    required this.code,
    required this.expiry,
  });

  factory OTP.fromJson(Map<String, dynamic> json) {
    return OTP(
      code: json['code'],
      expiry: DateTime.parse(json['expiry']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'expiry': expiry.toIso8601String(),
    };
  }
}