import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TokenService {
  final String baseUrl = "https://museum.waranim.xyz/";
  final String updateLink = "public/api/token/update";
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  String? _accessToken;
  String? _refreshToken;
  DateTime? _accessTokenExpiresAt;
  DateTime? _refreshTokenExpiresAt;

  Future<void> init() async {
    _accessToken = await storage.read(key: 'access_token');
    _refreshToken = await storage.read(key: 'refresh_token');
    final String? accessTokenExpStr = await storage.read(key: 'expires_in');
    final String? refreshTokenExpStr = await storage.read(key: 'refresh_expires_in');
    _accessTokenExpiresAt = DateTime.parse(accessTokenExpStr!);
    _refreshTokenExpiresAt = DateTime.parse(refreshTokenExpStr!);
  }

  Future<String?> getAccessToken() async {
    if (_accessToken == null || _isAccessTokenExpired()) {
      await _refreshAccessToken();
    }
    return _accessToken;
  }

  bool _isAccessTokenExpired() {
    if (_accessTokenExpiresAt == null) return true;
    return DateTime.now().isAfter(_accessTokenExpiresAt!);
  }

  bool _isRefreshTokenExpired() {
    if (_refreshTokenExpiresAt == null) return true;
    return DateTime.now().isAfter(_refreshTokenExpiresAt!);
  }

  Future<void> _refreshAccessToken() async {
    final response = await http.post(
      Uri.parse(baseUrl + updateLink),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'refreshToken': _refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      final DateTime now = DateTime.now();
      final responseData = jsonDecode(response.body);
      _accessToken = responseData['access_token'];
      _refreshToken = responseData['refresh_token'];
      final Duration durationAccessToken = Duration(seconds: responseData['expires_in']);
      final Duration durationRefreshToken = Duration(seconds: responseData['refresh_expires_in']);
      _accessTokenExpiresAt = now.add(durationAccessToken);
      _refreshTokenExpiresAt = now.add(durationRefreshToken);

      await storage.write(key: 'access_token', value: _accessToken);
      await storage.write(key: 'refresh_token', value: _refreshToken);
      await storage.write(key: 'expires_in', value: _accessTokenExpiresAt?.toIso8601String());
      await storage.write(key: 'refresh_expires_in', value: _refreshTokenExpiresAt?.toIso8601String());
      print('Токены обновлены');
    } else {
      print('Ошибка обновления токена: ${response.statusCode}');
    }
  }
}