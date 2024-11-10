import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '/admin/services/dashboard_service.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late String _selectedYear;
  final List<String> _years = List.generate(5, (index) => (DateTime.now().year - index).toString());

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Dropdown to select the year for which the statistics are displayed
              _buildYearDropdown(),
              const SizedBox(height: 20),
              _buildChartCard('Monthly Registered Users', DashboardService.fetchTotalUsersMonthly),
              const SizedBox(height: 20),
              _buildChartCard('Monthly Posts Created', DashboardService.fetchMonthlyPosts),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYearDropdown() {
    return DropdownButton<String>(
      value: _selectedYear,
      items: _years.map((String year) {
        return DropdownMenuItem<String>(
          value: year,
          child: Text(year),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedYear = newValue!;
        });
      },
      style: const TextStyle(color: Colors.teal, fontSize: 16),
    );
  }

  Widget _buildChartCard(String title, Future<List<Map<String, int>>> Function(String) fetchData) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<Map<String, int>>>(
              future: fetchData(_selectedYear),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final data = snapshot.data!;
                  if (data.isEmpty) {
                    return const Center(child: Text('No data available!'));
                  }

                  // Prepare data for the chart
                  List<ChartData> chartData = data.map((entry) {
                    return ChartData('Month ${entry['month']}', entry['total']?.toDouble() ?? 0.0);
                  }).toList();

                  return SizedBox(
                    height: 250,
                    child: SfCartesianChart(
                      title: ChartTitle(text: title),
                      primaryXAxis: CategoryAxis(),
                      series: <CartesianSeries>[
                        ColumnSeries<ChartData, String>(
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.month,
                          yValueMapper: (ChartData data, _) => data.count,
                          name: title,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Data class for chart data
class ChartData {
  final String month;
  final double count;

  ChartData(this.month, this.count);
}