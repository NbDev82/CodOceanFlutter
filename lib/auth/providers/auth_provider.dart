import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthProvider with ChangeNotifier {
  String _fullName = '';
  String _phoneNumber = '';
  String _dateOfBirth = '';
  String _email = '';
  String _urlImage = '';
  String _createdAt = '';
  String _updatedAt = '';

  String get fullName => _fullName;
  String get phoneNumber => _phoneNumber;
  String get dateOfBirth => _dateOfBirth;
  String get email => _email;
  String get urlImage => _urlImage;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;



AuthProvider({required Map<String, dynamic> userData}) {
    setUserData(userData);
  }


  void setUserData(Map<String, dynamic> userData) {
    _fullName = userData['fullName'] ?? '';
    _phoneNumber = userData['phoneNumber'] ?? '';
    _dateOfBirth = userData['dateOfBirth'] ?? '';
    _email = userData['email'] ?? '';
    _urlImage = userData['urlImage'] ?? '';
    _createdAt = userData['createdAt'] ?? '';
    _updatedAt = userData['updatedAt'] ?? '';
    notifyListeners();
  }

  void clearUserData() {
    _fullName = '';
    _phoneNumber = '';
    _dateOfBirth = '';
    _email = '';
    _urlImage = '';
    _createdAt = '';
    _updatedAt = '';
    notifyListeners();
  }
  
} 