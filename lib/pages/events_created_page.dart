import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:museum/controllers/event_controller.dart';
import 'package:museum/controllers/login_controller.dart';
import 'create_event_page.dart';
import 'dart:typed_data' as typed;

import 'edit_event_page.dart';


class EventsCreatedPage extends StatefulWidget {
  @override
  _EventsCreatedPageState createState() => _EventsCreatedPageState();
}

class _EventsCreatedPageState extends State<EventsCreatedPage> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final EventsService _eventsService = EventsService();
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> userEvents = [];
  List<Map<String, dynamic>> eventTypes = [];
  List<Map<String, dynamic>> sites = [];


  final _newTypeController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  bool isLoadingEvents = true;
  bool isLoadingTypes = true;
  bool isLoadingSites = true;

  @override
  void initState() {
    super.initState();
    _fetchUserEvents();
    _fetchEventTypes();
    _fetchSites();
    _authService.startTokenRefreshTimer();
  }

  @override
  void dispose() {
    _authService.stopTokenRefreshTimer();
    _newTypeController.dispose();
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
          isLoadingEvents = false;
        });
      } else {
        throw Exception('Ошибка загрузки мероприятий. Код: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoadingEvents = false;
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
    final eventToEdit = userEvents[index]; // Получаем мероприятие для редактирования

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventPage(event: eventToEdit), // Передаем мероприятие
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        userEvents[index] = result; // Обновляем мероприятие в списке
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

  Future<void> _fetchEventTypes() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Токен отсутствует.');

      final response = await http.get(
        Uri.parse('https://museum.waranim.xyz/api/types-of-event'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {

        final List<dynamic> typesData = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          eventTypes = typesData.map((e) => Map<String, dynamic>.from(e)).toList();
          isLoadingTypes = false;
        });
      } else {
        throw Exception('Ошибка загрузки типов мероприятий: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      setState(() => isLoadingTypes = false);
    }
  }

  Future<void> _addEventType(String name) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Токен отсутствует.');

      final response = await http.post(
        Uri.parse('https://museum.waranim.xyz/admin/api/type-of-event'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode({'name': name}),
      );

      if (response.statusCode == 201) {
        _fetchEventTypes();
        _newTypeController.clear();
      } else {
        throw Exception('Ошибка добавления типа мероприятия: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _deleteEventType(int id) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Токен отсутствует.');

      final response = await http.delete(
        Uri.parse('https://museum.waranim.xyz/admin/api/type-of-event/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 204) {
        _fetchEventTypes();
      } else {
        throw Exception('Ошибка удаления типа мероприятия: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchSites() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Токен отсутствует.');
      }

      final response = await http.get(
        Uri.parse('https://museum.waranim.xyz/api/sites'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> sitesData = jsonDecode(utf8.decode(response.bodyBytes));

        setState(() {
          sites = sitesData
              .map((e) => Map<String, dynamic>.from(e))
              .where((site) =>
          site['latitude'] != null &&
              site['longitude'] != null)
              .toList();
          isLoadingSites = false;
        });
      } else if (response.statusCode == 401) {
        throw Exception('Ошибка авторизации. Проверьте токен.');
      } else {
        throw Exception('Ошибка загрузки сайтов: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка: $e');
      setState(() {
        isLoadingSites = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось загрузить площадки: $e')),
      );
    }
  }

  Future<void> _deleteSite(int id) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Токен отсутствует.');

      final response = await http.delete(
        Uri.parse('https://museum.waranim.xyz/admin/api/site/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );
      print(id);

      if (response.statusCode == 204) {
        _fetchSites();
      } else {
        throw Exception('Ошибка удаления площадки: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _addSite(String name, String address) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Токен отсутствует.');

      final newSite = {
        "name": name,
        "address": address,
        "latitude": 0,
        "longitude": 0,
      };

      final response = await http.post(
        Uri.parse('https://museum.waranim.xyz/admin/api/site'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode(newSite),
      );

      if (response.statusCode == 201) {
        final createdSite = jsonDecode(utf8.decode(response.bodyBytes));

        setState(() {
          sites.add(createdSite);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Площадка успешно создана!")),
        );
      } else {
        throw Exception('Ошибка создания площадки: ${response.statusCode}');
      }
    } catch (e) {
      print("Ошибка: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Не удалось создать площадку: $e")),
      );
    }
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

  Widget _buildEventList() {
    if (isLoadingEvents) {
      return Center(child: CircularProgressIndicator());
    }

    if (userEvents.isEmpty) {
      return Center(child: Text('Нет созданных мероприятий'));
    }

    return ListView.builder(
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
                ? _buildEventImage(imageId) // Вернули использование функции для отображения изображения
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
    );
  }

  Widget _buildEventTypes() {
    if (isLoadingTypes) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: eventTypes.length,
            itemBuilder: (context, index) {
              final type = eventTypes[index];
              return ListTile(
                title: Text(type['name']),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteEventType(type['id']),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _newTypeController,
            decoration: InputDecoration(
              labelText: 'Добавить новый тип',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_newTypeController.text.trim().isNotEmpty) {
              _addEventType(_newTypeController.text.trim());
            }
          },
          child: Text('Добавить'),
        ),
      ],
    );
  }

  Widget _buildSites() {
    if (isLoadingSites) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Список площадок
        Expanded(
          child: ListView.builder(
            itemCount: sites.length,
            itemBuilder: (context, index) {
              final site = sites[index];
              return ListTile(
                title: Text("${site['name']} (${site['address']})"),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteSite(site['id']),
                ),
              );
            },
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Название',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Адрес',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  final name = _nameController.text.trim();
                  final address = _addressController.text.trim();

                  if (name.isEmpty || address.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Заполните все поля!")),
                    );
                    return;
                  }

                  _addSite(name, address);

                  // Очищаем поля
                  _nameController.clear();
                  _addressController.clear();
                },
                child: Text('Добавить площадку'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Мои мероприятия'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Мероприятия'),
              Tab(text: 'Типы мероприятий'),
              Tab(text: 'Площадки'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEventList(),
            _buildEventTypes(),
            _buildSites(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToCreateEventPage,
          child: Icon(Icons.add),
          tooltip: 'Создать мероприятие',
        ),
      ),
    );
  }
}
