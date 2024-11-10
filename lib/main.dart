import 'package:codoceanflutter/admin/pages/home/admin_home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/screens/login_screen.dart';
import 'auth/screens/otp_verification_screen.dart';
import 'auth/screens/forgot_password_screen.dart';
import 'auth/providers/auth_provider.dart';
import 'auth/services/auth_service.dart';
import 'admin/pages/home/admin_home_page.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider(userData: {})),
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
      ],
      child: MainApp(),
    ),
  );
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
        '/otp-verification': (context) => OTPVerificationScreen(email: ''),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/admin': (context) => AdminHomePage(),
      },
    );
  }
}
