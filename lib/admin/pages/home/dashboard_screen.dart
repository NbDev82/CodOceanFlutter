import 'package:flutter/material.dart';
import '../user-management/user_list_page.dart';
import '../admin-profile/admin_information_page.dart';
import '../statistics/statistics_page.dart';
import '../reports-management/report_management_page.dart'; // Import trang quản lý báo cáo
import '../categories/category_management_page.dart'; // Import trang quản lý categories

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Dashboard'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            DashboardCard(
              title: 'Statistics',
              icon: Icons.pie_chart,
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StatisticsPage()),
                );
              },
            ),
            DashboardCard(
              title: 'User List',
              icon: Icons.list,
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserListPage()),
                );
              },
            ),
            DashboardCard(
              title: 'Report\n Management',
              icon: Icons.report,
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportManagementPage()),
                );
              },
            ),
            DashboardCard(
              title: 'Category\n Management',
              icon: Icons.category,
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryManagementPage()),
                );
              },
            ),
            DashboardCard(
              title: 'Settings',
              icon: Icons.settings,
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Container()),
                );
              },
            ),
            DashboardCard(
              title: 'Profile',
              icon: Icons.person,
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminInformationPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const DashboardCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}