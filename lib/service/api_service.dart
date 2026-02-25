import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "https://fakestoreapi.com";

  Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse("$baseUrl/products"));
    return jsonDecode(response.body);
  }

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      body: {
        "username": username,
        "password": password,
      },
    );

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>> fetchUser() async {
    final response = await http.get(Uri.parse("$baseUrl/users/1"));
    return jsonDecode(response.body);
  }
}