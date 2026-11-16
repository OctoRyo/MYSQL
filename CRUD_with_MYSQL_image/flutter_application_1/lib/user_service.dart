import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'user_model.dart';

class UserService {
  static const String _baseUrl = 'http://192.168.72.49/APIFlutter/api.php';
  static const String _uploadUrl = 'http://192.168.72.49/APIFlutter/upload.php';

  // Upload foto ke server
  static Future<String?> uploadImage(File image) async {
    final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseData);
        return jsonData['filePath']; // Kembalikan path foto
      } else {
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
  // CREATE user dengan foto
  static Future<void> createUser(User user, File? image) async {
    String? fotoPath;
    if (image != null) {
      fotoPath = await uploadImage(image); // Upload foto
    }

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': user.name,
        'email': user.email,
        'foto': fotoPath, // Kirim path foto ke API
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create user');
    }
  }

  // READ users
  static Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // UPDATE
  static Future<void> updateUser(User user, File? image) async {
    String? fotoPath;
    if (image != null) {
      fotoPath = await _uploadImage(image);
    }

    final response = await http.put(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'foto': fotoPath ?? user.foto,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

  // Upload gambar
  static Future<String?> _uploadImage(File image) async {
    final request = http.MultipartRequest('POST', Uri.parse('http://192.168.72.49/APIFlutter/upload.php'));
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseData);
        return jsonData['filePath'];
      } else {
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // DELETE user
  static Future<void> deleteUser(int id) async {
    final response = await http.delete(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}