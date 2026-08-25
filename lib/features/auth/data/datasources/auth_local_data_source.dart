import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;

  static const String keyToken = 'auth_token';
  static const String keyUser = 'user_data';

  AuthLocalDataSourceImpl({required this.prefs});

  @override
  Future<void> saveToken(String token) async {
    await prefs.setString(keyToken, token);
  }

  @override
  Future<String?> getToken() async {
    return prefs.getString(keyToken);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(keyUser, userJson);
  }

  @override
  Future<UserModel?> getUser() async {
    final userJsonStr = prefs.getString(keyUser);
    if (userJsonStr == null || userJsonStr.isEmpty) {
      return null;
    }
    try {
      final Map<String, dynamic> decoded = jsonDecode(userJsonStr);
      return UserModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearSession() async {
    await prefs.remove(keyToken);
    await prefs.remove(keyUser);
  }
}
