import 'package:flutter/material.dart';
import 'report_list.dart'; // Đã sửa từ report_detail.dart thành report_list.dart
class ReportManagementPage extends StatelessWidget {
  const ReportManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Reports'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Select Report Type',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildOptionCard(
                    context,
                    title: 'Reported Problems',
                    icon: Icons.assignment,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReportList(type: 'Problem')),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildOptionCard(
                    context,
                    title: 'Reported Discussions',
                    icon: Icons.chat,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReportList(type: 'Discuss')),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildOptionCard(
                    context,
                    title: 'Reported Comments',
                    icon: Icons.report,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReportList(type: 'Comment')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}

