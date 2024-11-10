import 'package:flutter/material.dart';
import './services/report_service.dart';

class AlertForm extends StatelessWidget {
  final String reportId;
  final String type;

  const AlertForm({Key? key, required this.type, required this.reportId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController reasonController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert'),
        backgroundColor: Colors.orange,
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
                ReportService.alertReportedItem(type, reportId, reasonController.text);
                Navigator.pop(context);
              },
              child: const Text('Alert'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}