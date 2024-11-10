import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'user_detail_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> initialUsers = [];
  List<dynamic> users = [];
  String _selectedRole = 'All';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final profiles = await ApiService.getUsers();
    setState(() {
      initialUsers = profiles;
      users = initialUsers;
    });
  }

  void _filterUsers() {
    final searchText = _searchController.text.toLowerCase();
    setState(() {
      users = initialUsers.where((user) {
        final matchesEmail = user['email'].toLowerCase().contains(searchText);
        final matchesRole = _selectedRole == 'All' || user['role'] == _selectedRole;
        return matchesEmail && matchesRole;
      }).toList();
    });
  }

  Future<void> _refreshUsers() async {
    await _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshUsers,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSearchField(),
              _buildRoleDropdown(),
              const SizedBox(height: 16),
              Expanded(
                child: _buildUserList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: const InputDecoration(
        labelText: 'Search by Email',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (value) {
        _filterUsers();
      },
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButton<String>(
      value: _selectedRole,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.teal),
      underline: Container(
        height: 2,
        color: Colors.tealAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _selectedRole = newValue!;
          _filterUsers();
        });
      },
      items: <String>['All', 'USER', 'USER_VIP', 'MODERATOR']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildUserList() {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(user['fullName'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Email: ${user['email']}'),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user['urlImage'] ?? ''),
              backgroundColor: Colors.grey[200],
            ),
            onTap: () async {
              final updatedUser = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetailPage(email: user['email'] ?? ''),
                ),
              );

              if (updatedUser != null) {
                setState(() {
                  final userIndex = users.indexWhere((u) => u['email'] == updatedUser['email']);
                  if (userIndex != -1) {
                    users[userIndex] = updatedUser;
                  }
                  final initialUserIndex = initialUsers.indexWhere((u) => u['email'] == updatedUser['email']);
                  if (initialUserIndex != -1) {
                    initialUsers[initialUserIndex] = updatedUser;
                  }
                  print("In user_list updated: ${updatedUser}");
                  _filterUsers();
                });
              }
            },
          ),
        );
      },
    );
  }
}