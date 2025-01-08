import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:museum/pages/login_register_page.dart';

import '../classes/navigation_bar.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Timer? _tokenRefreshTimer;

  void startTokenRefreshTimer() {
    _tokenRefreshTimer = Timer.periodic(Duration(minutes: 2), (timer) async {
      await refreshAccessToken();
    });
    print('Таймер обновления токена запущен');
  }

  void stopTokenRefreshTimer() {
    _tokenRefreshTimer?.cancel();
    _tokenRefreshTimer = null;
    print('Таймер обновления токена остановлен');
  }


  Future<void> loginUser(BuildContext context, final email, final password) async {
    final response = await http.post(
      Uri.parse('https://museum.waranim.xyz/public/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final access_token = responseData['access_token'];
      final refresh_token = responseData['refresh_token'];
      await storage.write(key: 'access_token', value: access_token);
      await storage.write(key: 'refresh_token', value: refresh_token);
      print(access_token);

      print(storage.read(key: 'access_token'));
      print(storage.read(key: 'refresh_token'));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Вход успешен')),
      );
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CustomBottomNavigationBar()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Неверные данные')),
      );
    }
  }

  Future<void> registerUser (BuildContext context, final email, final password) async {
    final response = await http.post(
      Uri.parse('https://museum.waranim.xyz/public/api/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Регистрация успешна')),
      );
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginRegisterPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пользователь уже существует')),
      );
    }
  }

  Future<void> logoutUser(BuildContext context) async {
    final refreshToken  = await storage.read(key: 'refresh_token');
    final accessToken  = await storage.read(key: 'access_token');
    if (refreshToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удается выйти: токен отсутствует')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('https://museum.waranim.xyz/api/logout'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, String> {
        'refreshToken': refreshToken,
      }),
    );
    print(response.statusCode);

    if (response.statusCode == 204) {
      await storage.delete(key: 'access_token');
      await storage.delete(key: 'refresh_token');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Вы вышли из системы')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginRegisterPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка выхода')),
      );
    }
  }

  Future<void> refreshAccessToken() async {
    final refreshToken = await storage.read(key: 'refresh_token');

    final response = await http.post(
      Uri.parse('https://museum.waranim.xyz/public/api/token/update'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'refreshToken': refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final newAccessToken = responseData['access_token'];
      final newRefreshToken = responseData['refresh_token'];

      await storage.write(key: 'access_token', value: newAccessToken);
      await storage.write(key: 'refresh_token', value: newRefreshToken);
      print('Токены обновлены');
    } else {
      print('Ошибка обновления токена: ${response.statusCode}');
    }
  }
}