// ignore_for_file: prefer_if_null_operators

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class UserSecureStorage {
  static final storage = FlutterSecureStorage();
  
  static const keyEmail = 'email';
  static const keyPassword = 'password';
  static const keyType = 'type';

  static Future setEmail(String email) async {
    await storage.write(key: keyEmail, value: email);
  }

  static Future<String?> getEmail() async {
    final value = await storage.read(key: keyEmail);
    return value != null ? value : null;
  }

  static Future setPassword(String password) async {
    await storage.write(key: keyPassword, value: password);
  }

  static Future<String?> getPassword() async {
    final value = await storage.read(key: keyPassword);
    return value != null ? value : null;
  }

  static Future setType(String type) async {
    await storage.write(key: keyType, value: type);
  }

  static Future<String?> getType() async {
    final value = await storage.read(key: keyType);
    return value != null ? value : null;
  }
}