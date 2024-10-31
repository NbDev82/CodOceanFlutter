import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cod Ocean',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/otp-verification': (context) => OTPVerificationScreen(),
        '/forget-password': (context) => ForgetPasswordScreen(),
        '/reset-password': (context) => ResetPasswordScreen(),
      },
    );
  }
}
