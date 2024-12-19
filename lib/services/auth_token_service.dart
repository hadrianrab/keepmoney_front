import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TokenStorage {
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}

class AuthService {
  final String baseUrl = 'http://localhost:8080/api/users';
  final TokenStorage tokenStorage = TokenStorage();

  Future<Map<String, dynamic>> registerUser(String username, String email, String password) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Cadastro realizado com sucesso!',
        };
      } else {
        final errorData = response.body.isNotEmpty ? json.decode(response.body) : {};
        return {
          'success': false,
          'message': errorData['message'] ?? 'Falha no cadastro. Tente novamente.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro na requisição: $e',
      };
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        await tokenStorage.saveToken(data['token']);
        return {
          'success': true,
          'token': data['token'],
        };
      } else {
        final errorData = response.body.isNotEmpty ? json.decode(response.body) : {};
        return {
          'success': false,
          'message': errorData['message'] ?? 'Falha na autenticação. Verifique suas credenciais.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro na requisição de login: $e',
      };
    }
  }

  Future<int?> getUserId() async {
    final token = await tokenStorage.getToken();

    if (token == null) {
      return null;
    }

    final url = Uri.parse('$baseUrl/me');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['userId'];
      } else {
        final errorData = response.body.isNotEmpty ? json.decode(response.body) : {};
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await tokenStorage.clearToken();
  }
}