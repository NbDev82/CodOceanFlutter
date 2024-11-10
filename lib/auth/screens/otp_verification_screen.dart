// lib/screens/otp_verification_screen.dart
import 'package:codoceanflutter/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;

  OTPVerificationScreen({required this.email});

  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              decoration: InputDecoration(labelText: 'Enter OTP'),
            ),
            TextField(
              controller: newPasswordController,
              decoration: InputDecoration(labelText: 'Enter New Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                final authService = Provider.of<AuthService>(context, listen: false);
                try {
                  await authService.forgotPassword(widget.email, newPasswordController.text, otpController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('OTP verified successfully and password reset')),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to verify OTP or reset password: $e')),
                  );
                }
              },
              child: Text('Verify OTP and Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}