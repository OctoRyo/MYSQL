import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';

class UserService {
  // Ganti IP ini kalau IP laptop/server berubah
  static const String _baseUrl = 'http://192.168.100.85/APIFlutter/api.php';
  static const Duration _timeout = Duration(seconds: 15);
  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
  };

  static void _checkStatus(int statusCode, String message) {
    if (statusCode < 200 || statusCode >= 300) {
      throw Exception('$message (kode $statusCode)');
    }
  }

  // CREATE
  static Future<void> createUser(User user) async {
    final response = await http
        .post(
          Uri.parse(_baseUrl),
          headers: _jsonHeaders,
          body: jsonEncode({'name': user.name, 'email': user.email}),
        )
        .timeout(_timeout);
    _checkStatus(response.statusCode, 'Gagal menambah user');
  }

  // READ
  static Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(_baseUrl)).timeout(_timeout);
    _checkStatus(response.statusCode, 'Gagal memuat user');

    final dynamic data = jsonDecode(response.body);
    if (data is! List) {
      throw const FormatException('Respon server bukan daftar user');
    }
    return data
        .map((json) => User.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // UPDATE
  static Future<void> updateUser(User user) async {
    final response = await http
        .put(
          Uri.parse(_baseUrl),
          headers: _jsonHeaders,
          body: jsonEncode({
            'id': user.id,
            'name': user.name,
            'email': user.email,
          }),
        )
        .timeout(_timeout);
    _checkStatus(response.statusCode, 'Gagal mengubah user');
  }

  // DELETE
  static Future<void> deleteUser(int id) async {
    final response = await http
        .delete(
          Uri.parse(_baseUrl),
          headers: _jsonHeaders,
          body: jsonEncode({'id': id}),
        )
        .timeout(_timeout);
    _checkStatus(response.statusCode, 'Gagal menghapus user');
  }
}
