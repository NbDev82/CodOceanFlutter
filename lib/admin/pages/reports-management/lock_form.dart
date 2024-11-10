import 'package:flutter/material.dart';
import './services/report_service.dart';

class LockForm extends StatelessWidget {
  final String reportId;
  final String type;

  const LockForm({Key? key, required this.type, required this.reportId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController reasonController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lock'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter Reason', style: TextStyle(fontSize: 18)),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Reason',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ReportService.lockReportedItem(type, reportId, reasonController.text);
                Navigator.pop(context);
              },
              child: const Text('Lock'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}