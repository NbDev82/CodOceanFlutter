import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';

class EditUserDetailPage extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function(Map<String, dynamic>) userUpdatedCallback;

  const EditUserDetailPage({
    Key? key,
    required this.user,
    required this.userUpdatedCallback,
  }) : super(key: key);

  @override
  _EditUserDetailPageState createState() => _EditUserDetailPageState();
}

class _EditUserDetailPageState extends State<EditUserDetailPage> {
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _emailController = TextEditingController();
  final _vipexpDateController = TextEditingController();

  String _selectedRole = 'USER';
  DateTime _vipexpDate = DateTime.now();
  DateTime _dateOfBirth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeUserDetails();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _dateOfBirthController.dispose();
    _emailController.dispose();
    _vipexpDateController.dispose();
    super.dispose();
  }

  void _initializeUserDetails() {
    setState(() {
      _fullNameController.text = widget.user['fullName'] ?? '';
      _phoneNumberController.text = widget.user['phoneNumber'] ?? '';
      _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.user['dateOfBirth']));
      _emailController.text = widget.user['email'] ?? '';
      _selectedRole = widget.user['role'] ?? 'USER';
      if (_selectedRole == 'USER_VIP') {
        _vipexpDate = DateTime.parse(widget.user['vipexpDate']);
        _vipexpDateController.text = DateFormat('yyyy-MM-dd').format(_vipexpDate);
      }
      _dateOfBirth = DateTime.parse(widget.user['dateOfBirth']);
    });
  }

  bool _validateData() {
    if (_fullNameController.text.isEmpty || _phoneNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Full name and phone number are required')),
      );
      return false;
    }
    return true;
  }

  Future<void> _saveChanges() async {
    if (!_validateData()) return;

    final updatedUser = {
      'fullName': _fullNameController.text,
      'phoneNumber': _phoneNumberController.text,
      'dateOfBirth': _dateOfBirth.toIso8601String(),
      'role': _selectedRole,
      if (_selectedRole == 'USER_VIP') 'vipexpDate': _vipexpDate.toIso8601String(),
    };

    try {
      final user = await ApiService.editUser(widget.user['email'], updatedUser);
      widget.userUpdatedCallback(user);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save changes')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User Details'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_fullNameController, 'Full Name'),
              const SizedBox(height: 16),
              _buildTextField(_phoneNumberController, 'Phone Number', keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              _buildDateOfBirthField(_dateOfBirthController, 'Date of Birth', _dateOfBirth, (pickedDate) {
                setState(() {
                  _dateOfBirth = pickedDate;
                  _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(_dateOfBirth);
                });
              }),
              const SizedBox(height: 16),
              _buildDropdown(),
              if (_selectedRole == 'USER_VIP') ...[
                const SizedBox(height: 16),
                _buildDateVIPField(_vipexpDateController, 'VIP Expiration Date', _vipexpDate, (pickedDate) {
                  setState(() {
                    _vipexpDate = pickedDate;
                    _vipexpDateController.text = DateFormat('yyyy-MM-dd').format(_vipexpDate);
                  });
                }),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildDateOfBirthField(TextEditingController controller, String label, DateTime initialDate, Function(DateTime) onDateSelected) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      readOnly: true,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) onDateSelected(picked);
      },
    );
  }

   Widget _buildDateVIPField(TextEditingController controller, String label, DateTime initialDate, Function(DateTime) onDateSelected) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      readOnly: true,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (picked != null) onDateSelected(picked);
      },
    );
  }

  Widget _buildDropdown() {
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
        });
      },
      items: <String>['USER', 'USER_VIP', 'MODERATOR']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}