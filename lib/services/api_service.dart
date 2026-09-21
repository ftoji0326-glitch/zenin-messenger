import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/models.dart';

class ApiException implements Exception {
  const ApiException(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  String toString() => message;
}

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const _configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000/api',
  );

  final http.Client _client;
  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  Future<AuthSession> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _send(
      'POST',
      '/auth/register',
      body: {'name': name, 'email': email, 'password': password},
    );
    return AuthSession.fromJson(response);
  }

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final response = await _send(
      'POST',
      '/auth/login',
      body: {'email': email, 'password': password},
    );
    return AuthSession.fromJson(response);
  }

  Future<User> fetchProfile() async {
    final response = await _send('GET', '/profile');
    return User.fromJson(response['user'] as Map<String, dynamic>? ?? {});
  }

  Future<List<Chat>> fetchChats() async {
    final response = await _send('GET', '/chats');
    final chats = response['chats'] as List<dynamic>? ?? [];
    return chats
        .whereType<Map<String, dynamic>>()
        .map(Chat.fromJson)
        .toList();
  }

  Future<Map<String, dynamic>> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$_configuredBaseUrl$path');
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };

    late http.Response response;
    switch (method) {
      case 'GET':
        response = await _client.get(uri, headers: headers);
      case 'POST':
        response = await _client.post(
          uri,
          headers: headers,
          body: jsonEncode(body ?? {}),
        );
      default:
        throw UnsupportedError('Unsupported HTTP method: $method');
    }

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException('The server returned an invalid response.', response.statusCode);
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        decoded['error'] as String? ?? 'Request failed.',
        response.statusCode,
      );
    }

    return decoded;
  }
}
