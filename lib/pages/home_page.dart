import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:museum/controllers/login_controller.dart';

import '../controllers/event_controller.dart';
import '../utils/carousel.dart';
import '../utils/text_field.dart';
import 'event_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService authService = AuthService();
  final EventsService eventsService = EventsService();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Timer? _timer;
  List<dynamic>? events;

  @override
  void initState() {
    super.initState();
    authService.stopTokenRefreshTimer();
    _loadEvents();
  }

  @override
  void dispose() {
    _timer?.cancel();
    authService.stopTokenRefreshTimer();
    super.dispose();
  }

  String formatDate(String dateStr) {
    DateTime dateTime = DateFormat("dd-MM-yyyy HH:mm", 'ru').parse(dateStr);
    String formattedDate = DateFormat("dd-MM-yyyy HH:mm", 'ru').format(dateTime);
    return formattedDate;
  }

  void _startTokenRefreshTimer() {
    _timer = Timer.periodic(Duration(minutes: 2), (timer) async {
      await authService.refreshAccessToken();
      print("Токен обновлен");
    });
  }

  Future<String?> _getToken() async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      await authService.refreshAccessToken();
      token = await storage.read(key: 'access_token');
    }
    return token;
  }

  Future<void> _loadEvents() async {
    final token = await _getToken();
    if (token != null) {
      final result = await eventsService.fetchEvents("Bearer $token");
      if (result != null) {
        setState(() {
          events = result;
        });
      }
    }
  }

  Future<Map<String, dynamic>?> _fetchEventWithRetry(String token, int eventId) async {
    for (int i = 0; i < 3; i++) {
      try {
        final eventData = await eventsService.fetchEventById(token, eventId);
        if (eventData != null) {
          return eventData;
        }
      } catch (e) {
        print("Failed to fetch event $eventId, attempt ${i + 1}");
        await Future.delayed(Duration(seconds: 2));
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 22),
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset("assets/icons/logo_vector.svg", width: 210),
              ),
              Spacer(),
              IconButton(
                padding: EdgeInsets.only(right: 30),
                icon: Icon(Icons.logout, size: 40),
                alignment: Alignment.centerRight,
                onPressed: () {
                  authService.logoutUser(context);
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          MyTextField(
            controller: TextEditingController(),
            readOnly: false,
            suffixIcon: const Icon(Icons.search, color: Color(0xff49454F)),
            hintText: 'Поиск',
            obscureText: false,
            prefixIcon: const Icon(Icons.menu, color: Color(0xff49454F)),
          ),
          SizedBox(height: 16),
          Expanded(
            child: events == null
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: events!.length,
              itemBuilder: (context, index) {
                var event = events![index];
                String? imageId = event['image']?['link']?.split('/').last;
                int eventId = event['id'];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventPage(event: event),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Фоновое изображение
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: imageId != null
                              ? FutureBuilder<Uint8List?>(
                            future: _getToken().then((token) {
                              if (token != null) {
                                return eventsService.fetchEventImage("Bearer $token", imageId);
                              }
                              return null;
                            }),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Container(
                                  width: double.infinity,
                                  height: 180,
                                  color: Colors.grey[200],
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              } else if (snapshot.hasData) {
                                return Image.memory(
                                  snapshot.data!,
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return Container(
                                  width: double.infinity,
                                  height: 180,
                                  color: Colors.grey,
                                  child: Center(
                                    child: Image.asset('assets/images/not_found.png'),
                                  ),
                                );
                              }
                            },
                          )
                              : Container(
                            width: double.infinity,
                            height: 180,
                            color: Colors.white38,
                            child: Center(
                              child: Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.7),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: FutureBuilder<Map<String, dynamic>?>(
                            future: _getToken().then((token) {
                              if (token != null) {
                                return _fetchEventWithRetry(token, eventId);
                              }
                              return null;
                            }),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasData) {
                                int? age = snapshot.data?["age"];
                                String nameWithAge = '${event['name']} (${age ?? '0'}+)';

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nameWithAge,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    // Дополнительная информация под основным текстом
                                    FutureBuilder<Map<String, dynamic>?>(
                                      future: _getToken().then((token) {
                                        if (token != null) {
                                          return _fetchEventWithRetry(token, eventId);
                                        }
                                        return null;
                                      }),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Container();
                                        } else if (snapshot.hasData) {
                                          int? typeOfEventId = snapshot.data?['typeOfEventId'];
                                          String typeText;
                                          if (typeOfEventId == 2) {
                                            typeText = 'Концерт';
                                          } else if (typeOfEventId == 3) {
                                            typeText = 'Экскурсия';
                                          } else {
                                            typeText = snapshot.data?['typeName'] ?? 'Не указано';
                                          }

                                          String? date = snapshot.data?['date'];
                                          String dateFormat = date != null ? formatDate(date) : 'Дата не указана';

                                          int? price = snapshot.data?["prices"]
                                              ?.map((item) => item["price"] as int)
                                              .reduce((value, element) => value > element ? value : element);

                                          String? address = event['address'];

                                          return Text(
                                            '$typeText, $price руб, $dateFormat, $address',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[300], // Сделать текст более мягким
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                                  ],
                                );
                              } else {
                                return Text(
                                  event['name'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
