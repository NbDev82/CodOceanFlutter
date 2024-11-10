import 'package:flutter/material.dart';
import 'report_list_item.dart';
import 'services/report_service.dart';

class ReportList extends StatefulWidget {
  final String type;

  const ReportList({Key? key, required this.type}) : super(key: key);

  @override
  _ReportListState createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = ReportService.getReportedItems(widget.type.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.type} Reports'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<dynamic>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Failed to load reports'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No reports available'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final report = snapshot.data![index];
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text(report['id'], style: const TextStyle(fontSize: 18)),
                      subtitle: Text(widget.type == 'Comment' ? report['text'] : report['title'], overflow: TextOverflow.ellipsis),
                      onTap: () {
                        // Chuyển đến trang ReportListItem với report đã chọn
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportListItem(type: widget.type.toLowerCase(), reportItemId: report['id']),
                          ),
                        ).then((_) {
                          setState(() {
                            _future = ReportService.getReportedItems(widget.type.toLowerCase());
                          });
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