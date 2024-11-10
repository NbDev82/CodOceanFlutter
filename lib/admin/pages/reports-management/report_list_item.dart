import 'package:flutter/material.dart';
import 'services/report_service.dart';
import 'report_detail.dart';

class ReportListItem extends StatefulWidget {
  final String reportItemId;
  final String type;

  const ReportListItem({Key? key, required this.type, required this.reportItemId}) : super(key: key);

  @override
  _ReportListItemState createState() => _ReportListItemState();
}

class _ReportListItemState extends State<ReportListItem> {
  dynamic reportDetails;

  @override
  void initState() {
    super.initState();
    _loadReportDetails();
  }

  _loadReportDetails() async {
    final reportDetailsData = await ReportService.getReports(widget.type, widget.reportItemId);
    setState(() {
      reportDetails = reportDetailsData;
      print("reportDetails: ${reportDetails}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reportItemId),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<dynamic>(
          future: ReportService.getReports(widget.type, widget.reportItemId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Failed to load report details'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No details available'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text(snapshot.data![index]['description']?.isEmpty ?? snapshot.data![index]['description'] == null ? 'NaN' : snapshot.data![index]['description'], style: const TextStyle(fontSize: 18)),
                      subtitle: Text('Type: ${snapshot.data![index]['type']?.isEmpty ?? snapshot.data![index]['type'] == null ? 'NaN' : snapshot.data![index]['type']}, Violation ID: ${snapshot.data![index]['violationId']?.isEmpty ?? snapshot.data![index]['violationId'] == null ? 'NaN' : snapshot.data![index]['violationId']}, Owner ID: ${snapshot.data![index]['ownerId']?.isEmpty ?? snapshot.data![index]['ownerId'] == null ? 'NaN' : snapshot.data![index]['ownerId']}'),
                      trailing: Text('Closed: ${snapshot.data![index]['closed']}'),
                      leading: Icon(Icons.info_outline, color: Colors.teal),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportDetail(type: widget.type, reportId: snapshot.data![index]['id']),
                          ),
                        ).then((_) {
                          _loadReportDetails();
                        });
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}