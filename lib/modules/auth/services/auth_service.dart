import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "https://waygo-uoqs.onrender.com/api";

  static Future<Map<String, dynamic>> login({
    required String aadhar,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/passengers/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "aadhar": aadhar,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (data["success"] == true) {
      return data;
    }

    throw Exception(data["message"] ?? "Login failed");
  }

  static Future<Map<String, dynamic>> register({
    required String aadhar,
    required String name,
    required String phone,
    String? email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/passengers/register"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "aadhar": aadhar,
        "name": name,
        "phone": phone,
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (data["success"] == true) {
      return data;
    }

    throw Exception(data["message"] ?? "Registration failed");
  }
}