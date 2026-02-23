import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:konektz/features/auth/data/models/user_model.dart';

/// Contract for the remote authentication data source.
abstract class AuthRemoteDatasource {
  Future<UserModel> login({required String email, required String password});

  Future<UserModel> register({
    required String email,
    required String username,
    required String password,
  });

  Future<void> logout();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final String baseUrl;
  final http.Client _client;

  AuthRemoteDatasourceImpl({
    this.baseUrl = 'http://192.168.1.66:5000/auth',
    http.Client? client,
  }) : _client = client ?? http.Client();

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/login'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('Login response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return UserModel.fromLoginResponse(body);
      } else {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(body['message'] ?? 'Login failed');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid server response');
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/register'),
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint(
        'Register response: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return UserModel.fromRegisterResponse(body);
      } else {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(body['message'] ?? 'Registration failed');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid server response');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await _client.post(Uri.parse('$baseUrl/logout'));
      if (response.statusCode != 200) {
        throw Exception('Logout failed');
      }
    } on SocketException {
      throw Exception('No internet connection');
    }
  }
}


// emulator → use 10.0.2.2 to reach your PC's localhost
// this.baseUrl = 'http://10.0.2.2:5000/auth',

// physical device → use your PC's local network IP, e.g.:
// this.baseUrl = 'http://192.168.1.X:5000/auth',