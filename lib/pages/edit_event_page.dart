import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class EditEventPage extends StatefulWidget {
  final Map<String, dynamic> event;

  EditEventPage({required this.event});

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  late TextEditingController _nameController;
  late TextEditingController _summaryController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _kassirController;

  late bool _adult;
  late bool _teenagers;
  late bool _kids;
  late bool _hia;
  late bool _completed;

  int? _selectedSiteId;
  int? _selectedTypeOfEventId;

  List<Map<String, dynamic>> eventTypes = [];
  List<Map<String, dynamic>> sites = [];
  bool isLoadingSites = true;
  bool isLoadingEventTypes = true;

  @override
  void initState() {
    super.initState();

    // Инициализируем контроллеры
    _nameController = TextEditingController(text: widget.event['name']);
    _summaryController = TextEditingController(text: widget.event['summary']);
    _descriptionController = TextEditingController(text: widget.event['description']);
    _dateController = TextEditingController(text: widget.event['date']);
    _kassirController = TextEditingController(text: widget.event['kassir']);

    // Инициализируем флаги
    _adult = widget.event['adult'];
    _teenagers = widget.event['teenagers'];
    _kids = widget.event['kids'];
    _hia = widget.event['hia'];
    _completed = widget.event['completed'];

    _selectedSiteId = widget.event['siteId'];
    _selectedTypeOfEventId = widget.event['typeOfEventId'];

    _fetchSites();
    _fetchEventTypes();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _summaryController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _kassirController.dispose();
    super.dispose();
  }

  Future<String?> _getToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<void> _fetchSites() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Токен отсутствует.');

      final response = await http.get(
        Uri.parse('https://museum.waranim.xyz/api/sites'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> sitesData = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          sites = sitesData.map((e) => Map<String, dynamic>.from(e)).toList();
          isLoadingSites = false;
        });
      } else {
        throw Exception('Ошибка загрузки площадок: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки площадок: $e')),
      );
    }
  }

  Future<void> _fetchEventTypes() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Токен отсутствует.');

      final response = await http.get(
        Uri.parse('https://museum.waranim.xyz/api/types-of-event'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> typesData = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          eventTypes = typesData.map((e) => Map<String, dynamic>.from(e)).toList();
          isLoadingEventTypes = false;
        });
      } else {
        throw Exception('Ошибка загрузки типов мероприятий: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки типов мероприятий: $e')),
      );
    }
  }

  Future<void> _saveEvent() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception("Токен отсутствует. Авторизуйтесь заново.");
      }

      final updatedEvent = {
        ...widget.event,
        'name': _nameController.text.trim(),
        'summary': _summaryController.text.trim(),
        'description': _descriptionController.text.trim(),
        'date': _dateController.text.trim(),
        'kassir': _kassirController.text.trim(),
        'adult': _adult,
        'teenagers': _teenagers,
        'kids': _kids,
        'hia': _hia,
        'completed': _completed,
        'siteId': _selectedSiteId,
        'typeOfEventId': _selectedTypeOfEventId,
      };

      final response = await http.put(
        Uri.parse('https://museum.waranim.xyz/marketer/api/event/${updatedEvent["id"]}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedEvent),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, updatedEvent); // Возвращаем обновленное мероприятие
      } else {
        throw Exception('Ошибка обновления мероприятия: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка сохранения мероприятия: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактировать мероприятие'),
      ),
      body: isLoadingSites || isLoadingEventTypes
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
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
            SizedBox(height: 16),
            TextField(
              controller: _summaryController,
              decoration: InputDecoration(
                labelText: 'Краткое описание',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Описание',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Дата (ДД-ММ-ГГГГ)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _kassirController,
              decoration: InputDecoration(
                labelText: 'Кассир',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButton<int>(
              value: _selectedSiteId,
              isExpanded: true,
              items: sites.map((site) {
                return DropdownMenuItem<int>(
                  value: site['id'],
                  child: Text(site['name'] ?? 'Без названия'),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  _selectedSiteId = newValue;
                });
              },
              hint: Text('Выберите площадку'),
            ),
            SizedBox(height: 16),
            DropdownButton<int>(
              value: _selectedTypeOfEventId,
              isExpanded: true,
              items: eventTypes.map((type) {
                return DropdownMenuItem<int>(
                  value: type['id'],
                  child: Text(type['name']),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  _selectedTypeOfEventId = newValue!;
                });
              },
              hint: Text('Выберите тип мероприятия'),
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Завершено'),
              value: _completed,
              onChanged: (value) {
                setState(() {
                  _completed = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveEvent,
              child: Text('Сохранить изменения'),
            ),
          ],
        ),
      ),
    );
  }
}
