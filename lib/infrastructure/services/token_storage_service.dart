import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageService {
  static const _storage = FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';
  static const String _emailKey = 'user_email';
  static const String _nameKey = 'user_name';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> saveEmail(String email) async {
    await _storage.write(key: _emailKey, value: email);
  }

  static Future<String?> getEmail() async {
    return await _storage.read(key: _emailKey);
  }

  static Future<void> saveName(String name) async {
    await _storage.write(key: _nameKey, value: name);
  }

  static Future<String?> getName() async {
    return await _storage.read(key: _nameKey);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}