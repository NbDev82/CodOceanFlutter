import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import '../user-management/user_list_page.dart';
import '../admin-profile/admin_information_page.dart'; 
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Admin Panel')),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirmation'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Log out'),
                      onPressed: () {
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.remove('accessToken');
                          prefs.remove('refreshToken');
                        });
                        Navigator.of(context).pushNamed('/');
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: DashboardScreen()),
        ],
      ),
    );
  }
}
