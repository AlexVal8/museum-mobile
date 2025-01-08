import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:museum/controllers/event_controller.dart';
import 'package:museum/controllers/login_controller.dart';
import 'create_event_page.dart';
import 'dart:typed_data' as typed;


class EventsCreatedPage extends StatefulWidget {
  @override
  _EventsCreatedPageState createState() => _EventsCreatedPageState();
}

class _EventsCreatedPageState extends State<EventsCreatedPage> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final EventsService _eventsService = EventsService();
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> userEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserEvents();
    _authService.startTokenRefreshTimer();
  }

  @override
  void dispose() {
    _authService.stopTokenRefreshTimer();
    super.dispose();
  }

  Future<String?> _getToken() async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      await _authService.refreshAccessToken();
      token = await storage.read(key: 'access_token');
    }
    return token;
  }

  Future<void> _fetchUserEvents() async {
    try {
      final token = await storage.read(key: 'access_token');
      if (token == null) {
        throw Exception('Токен отсутствует. Авторизуйтесь заново.');
      }

      final response = await http.get(
        Uri.parse('https://museum.waranim.xyz/api/events/info'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> eventsData =
        jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          userEvents = eventsData
              .map((event) => Map<String, dynamic>.from(event))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Ошибка загрузки мероприятий. Код: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки мероприятий')),
      );
    }
  }

  void _navigateToCreateEventPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateEventPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        userEvents.add(result);
      });
    }
  }

  void _editEvent(int index) async {
    final eventToEdit = userEvents[index];

    // Убедимся, что данные мероприятия корректны
    final editableEvent = Map<String, dynamic>.from(eventToEdit);

    if (editableEvent.containsKey('images') &&
        editableEvent['images'] is List &&
        editableEvent['images'].isNotEmpty) {
      // Гарантируем корректность формата списка изображений
      editableEvent['images'] = editableEvent['images']
          .map<Map<String, dynamic>>((image) => Map<String, dynamic>.from(image))
          .toList();
    }

    // Открываем страницу редактирования
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEventPage(eventData: editableEvent),
      ),
    );

    // Обновляем список мероприятий после редактирования
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        userEvents[index] = result; // Обновляем данные в списке
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Мероприятие успешно обновлено')),
      );
    }
  }




  void _deleteEvent(int index) async {
    try {
      final token = await storage.read(key: 'access_token');
      if (token == null) {
        throw Exception('Токен отсутствует. Авторизуйтесь заново.');
      }

      final eventId = userEvents[index]["id"];
      final response = await http.delete(
        Uri.parse('https://museum.waranim.xyz/marketer/api/event/$eventId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204) {
        setState(() {
          userEvents.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Мероприятие удалено')),
        );
      } else {
        print('Ответ сервера: ${response.body}');
        print(token);

        throw Exception('Ошибка удаления мероприятия');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка удаления мероприятия')),
      );
    }
  }

  String? _getFirstImageId(Map<String, dynamic> event) {
    if (event['images'] != null && event['images'].isNotEmpty) {
      final firstImage = event['images'][0];
      return firstImage['link'];
    }
    return null;
  }

  Widget _buildEventImage(String? imageId) {
    if (imageId == null) {
      return Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
    }

    return FutureBuilder<typed.Uint8List?>(
      future: _getToken().then((token) {
        if (token != null) {
          print("Token: $token");
          return _eventsService.fetchEventImage("Bearer $token", imageId);
        }
        return null;
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: 50,
            height: 50,
            color: Colors.grey[200],
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(
            snapshot.data!,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          );
        } else {
          return Icon(Icons.broken_image, size: 50, color: Colors.grey);
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мои мероприятия'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userEvents.isEmpty
          ? Center(child: Text('Нет созданных мероприятий'))
          : ListView.builder(
        itemCount: userEvents.length,
        itemBuilder: (context, index) {
          final event = userEvents[index];

          String? imageId;
          if (event['images'] != null && event['images'].isNotEmpty) {
            final String? imageUrl = event['images'][0]['link'];
            imageId = imageUrl?.split('/').last;
          }

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: imageId != null
                  ? _buildEventImage(imageId)
                  : Icon(Icons.event, size: 50),
              title: Text(
                event['name'] ?? 'Без названия',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                event['description'] ?? 'Описание отсутствует',
                style: TextStyle(color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editEvent(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteEvent(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateEventPage,
        child: Icon(Icons.add),
      ),
    );
  }
}
