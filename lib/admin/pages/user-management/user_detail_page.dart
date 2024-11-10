import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'edit_user_detail_page.dart';
import 'package:intl/intl.dart';

class UserDetailPage extends StatefulWidget {
  final String email;

  const UserDetailPage({super.key, required this.email});

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  Map<String, dynamic>?  user;
  late Future<void> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userData = await ApiService.getUserDetail(widget.email);
    setState(() {
      print("In detail page: ${userData}");
      user = userData;
    });
  }

  void _onUserUpdated(Map<String, dynamic> updatedUser) {
    setState(() {
      user = updatedUser;
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, user);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Details'),
          backgroundColor: Colors.teal,
        ),
        body: FutureBuilder(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || user == null) {
              return const Center(child: Text('User data not found'));
            }

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(user?['urlImage'] ?? ''),
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoCard('Full Name', user?['fullName'] ?? 'N/A'),
                    _buildInfoCard('Phone Number', user?['phoneNumber'] ?? 'N/A'),
                    _buildInfoCard('Date of Birth', _formatDate(user?['dateOfBirth'])),
                    _buildInfoCard('Email', user?['email'] ?? 'N/A'),
                    _buildInfoCard('Created At', _formatDateTime(user?['createdAt'])),
                    _buildInfoCard('Updated At', _formatDateTime(user?['updatedAt'])),
                    _buildInfoCard('VIP Expiration Date', _formatDateTime(user?['vipexpDate'])),
                    _buildInfoCard('Role', user?['role'] ?? 'N/A'),
                    _buildInfoCard('Lock Status', user?['locked'] == true ? 'Locked' : 'Unlocked'),
                    const SizedBox(height: 20),
                    _buildActionButtons(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(value, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () async {
            final updatedUser = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditUserDetailPage(
                  user: user!,
                  userUpdatedCallback: _onUserUpdated,
                ),
              ),
            );
            if (updatedUser != null) {
              _onUserUpdated(updatedUser);
              Navigator.pop(context, updatedUser);
            }
          },
          child: const Text('Edit'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final isLocked = user?['locked'] == true;
            final action = isLocked ? ApiService.unlockUser : ApiService.lockUser;
            final result = await action(user?['email']);
            if (result) {
              setState(() {
                user?['locked'] = isLocked ? false : true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isLocked ? 'User unlocked successfully' : 'User locked successfully')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to update user status')),
              );
            }
            Navigator.pop(context, user);

          },
          child: Text(user?['locked'] == true ? 'Unlock' : 'Lock'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            backgroundColor: user?['locked'] == true ? Colors.red : Colors.green,
          ),
        ),
      ],
    );
  }
}