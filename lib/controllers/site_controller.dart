import 'dart:convert';

import 'package:http/http.dart' as http;

class SiteService {
  final String baseUrl = "https://museum.waranim.xyz";

  Future<Map<String, dynamic>?> getSite(String accessToken, int id) async {
    final url = Uri.parse('$baseUrl/api/site/$id');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);

      return json.decode(decodedResponse) as Map<String, dynamic>;
    } else {
      throw Exception('Ошибка при получении площадки: ${response.body}');
    }
  }
}