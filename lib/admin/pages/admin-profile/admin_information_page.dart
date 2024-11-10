import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';

class AdminInformationPage extends StatefulWidget {
  const AdminInformationPage({Key? key}) : super(key: key);

  @override
  _AdminInformationPageState createState() => _AdminInformationPageState();
}

class _AdminInformationPageState extends State<AdminInformationPage> {
  Map<String, dynamic> adminData = {
    "fullName": "",
    "phoneNumber": "",
    "dateOfBirth": "",
    "email": "",
    "urlImage": "",
    "createdAt": "",
    "updatedAt": ""
  };

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    final currentUser = await ApiService.getCurrentUser();
    setState(() {
      adminData = currentUser;
    });
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    try {
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
    } catch (e) {
      return 'Invalid date';
    }
  }

  String _formatDateTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return 'N/A';
    try {
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(dateTime));
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Information'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(),
              const SizedBox(height: 20),
              _buildInfoCard('Email', adminData["email"]),
              _buildInfoCard('Phone Number', adminData["phoneNumber"]),
              _buildInfoCard('Date of Birth', _formatDate(adminData["dateOfBirth"])),
              _buildInfoCard('Created At', _formatDateTime(adminData["createdAt"])),
              _buildInfoCard('Updated At', _formatDateTime(adminData["updatedAt"])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(adminData['urlImage'] ?? ''),
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adminData["fullName"] ?? 'N/A',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String? value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              value ?? 'N/A',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
