import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class EventsService {
  final String baseUrl = "https://museum.waranim.xyz";
  final String endpoint = "/api/events";
  final String imageEndpoint = "/api/images/";
  final String typeEventEndpoint = "api/type_of_event";

  Future<List<dynamic>?> fetchEvents(String token) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(
      url,
      headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      },
    );
    print(token);

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      return json.decode(decodedResponse);
    } else {
      print("Failed to load events: ${response.statusCode}");
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchEventById(String token, int id) async {
    final url = Uri.parse('https://museum.waranim.xyz/api/event/$id');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      return json.decode(decodedResponse) as Map<String, dynamic>;
    } else {
      print("Failed to load event: ${response.statusCode}");
      return null;
    }
  }


  // Future<Map<String, dynamic>?> fetchEventType(String token, int id) async {
  //   final url = Uri.parse('$baseUrl$typeEventEndpoint/$id');
  //   final response = await http.get(
  //     url,
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json',
  //     },
  //   );
  //   print(token);
  //
  //   if (response.statusCode == 200) {
  //     final decodedResponse = utf8.decode(response.bodyBytes);
  //     return json.decode(decodedResponse) as Map<String, dynamic>;
  //   } else {
  //     print("Failed to load type: ${response.statusCode}");
  //     return null;
  //   }
  // }

  Future<Uint8List?> fetchEventImage(String token, String id) async {
    final url = Uri.parse('$baseUrl$imageEndpoint$id');
    final response = await http.get(
      url,
      headers: {
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      print("Failed to load image: ${response.statusCode}");
      return null;
    }
  }
}