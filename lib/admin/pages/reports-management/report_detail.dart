import 'package:codoceanflutter/admin/pages/reports-management/alert_form.dart';
import 'package:codoceanflutter/admin/pages/reports-management/lock_form.dart';
import 'package:flutter/material.dart';
import 'package:codoceanflutter/admin/pages/reports-management/services/report_service.dart';

class ReportDetail extends StatefulWidget {
  final String type;
  final String reportId;

  const ReportDetail({Key? key, required this.type, required this.reportId}) : super(key: key);

  @override
  _ReportDetailState createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail> {
  dynamic reportDetail;

  @override
  void initState() {
    super.initState();
    _loadReportDetail();
  }

  _loadReportDetail() async {
    final reportDetailData = await ReportService.getReportDetail(widget.type, widget.reportId);
    setState(() {
      reportDetail = reportDetailData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${reportDetail?['type'] ?? 'NaN'} Report Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Report Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Report ID: ${reportDetail?['id'] ?? 'NaN'}'),
            Text('Description: ${reportDetail?['description'] ?? 'NaN'}'),
            Text('Violation ID: ${reportDetail?['violationId'] ?? 'NaN'}'),
            Text('Owner ID: ${reportDetail?['ownerId'] ?? 'NaN'}'),
            Text('Violation Types: ${reportDetail?['violationTypes']?.map((e) => e['description'])?.join(', ') ?? 'NaN'}'),
            Text('Result: ${reportDetail?['result'] ?? 'NaN'}'),
            Text('Closed: ${reportDetail?['closed'] ?? 'NaN'}'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LockForm(type: widget.type, reportId: widget.reportId),
                      ),
                    ).then((_) {
                      _loadReportDetail();
                    });
                  },
                  child: const Text('Lock'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlertForm(type: widget.type, reportId: widget.reportId),
                      ),
                    ).then((_) {
                      _loadReportDetail();
                    });
                  },
                  child: const Text('Alert'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
                ElevatedButton(
                  onPressed: () {
                    ReportService.ignoreReportedItem(widget.type, widget.reportId);
                    Navigator.pop(context);
                  },
                  child: const Text('Ignore'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}