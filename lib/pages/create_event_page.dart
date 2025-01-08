import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../controllers/login_controller.dart';

class CreateEventPage extends StatefulWidget {
  final Map<String, dynamic>? eventData;

  CreateEventPage({this.eventData});

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  bool _isSaving = false;

  final _titleController = TextEditingController();
  final _placeController = TextEditingController();
  final _timeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  final _hourController = TextEditingController();
  final _minuteController = TextEditingController();

  String? _dateError;
  String? _formattedDate;

  bool _pushkinCardPayment = false;
  bool _freeEntry = false;

  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final AuthService authService = AuthService();

  String? _getFormattedDate() {
    final day = _dayController.text.padLeft(2, '0');
    final month = _monthController.text.padLeft(2, '0');
    final year = _yearController.text.padLeft(4, '0');
    final hour = _hourController.text.padLeft(2, '0');
    final minute = _minuteController.text.padLeft(2, '0');

    if (int.tryParse(day) == null ||
        int.tryParse(month) == null ||
        int.tryParse(year) == null ||
        int.tryParse(hour) == null ||
        int.tryParse(minute) == null) {
      return null;
    }

    return "$day-$month-$year $hour:$minute";
  }

  // Категории
  final Map<String, bool> _ageCategories = {
    "0+": false,
    "6+": false,
    "12+": false,
    "16+": false,
    "18+": false,
  };

  final Map<String, bool> _genreCategories = {
    "Экскурсия": false,
    "Мастер-класс": false,
    "Спектакль": false,
    "Выставка": false,
    "Интерактивное занятие": false,
    "Музейный урок": false,
    "Концерт": false,
    "Мероприятие": false,
    "Лекция": false,
    "Творческая встреча": false,
    "Фестиваль": false,
    "Артист-ток": false,
    "Паблик-ток": false,
    "Кинопоказы": false,
    "Public talk": false,
    "Бал": false,
  };

  final Map<String, bool> _options = {
    "Тифлокомментирование": false,
    "Использование субтиторов": false,
    "Перевод на русский жестовый язык": false,
    "Наличие тактильных материалов": false,
    "Предупреждающие таблички около экспонатов, издающих звуки": false,
    "Наличие маркировки на лестницах при перепаде высоты": false,
    "Предупреждения во время проведения события о перепадах света, высоты, звуках, большом количестве посетителей": false,
    "Ясный текст": false,
  };

  final List<File> _images = [];

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();

    if (widget.eventData != null) {
      _titleController.text = widget.eventData!['title'] ?? '';
      _placeController.text = widget.eventData!['place'] ?? '';
      _timeController.text = widget.eventData!['time'] ?? '';
      _descriptionController.text = widget.eventData!['description'] ?? '';
      _priceController.text = widget.eventData!['price'] ?? '';
      _pushkinCardPayment = widget.eventData!['pushkinCardPayment'] ?? false;
      _freeEntry = widget.eventData!['freeEntry'] ?? false;

      // Загружаем состояния чекбоксов категорий
      if (widget.eventData!['ageCategories'] != null) {
        for (var key in widget.eventData!['ageCategories'].keys) {
          _ageCategories[key] = widget.eventData!['ageCategories'][key];
        }
      }

      if (widget.eventData!['genreCategories'] != null) {
        for (var key in widget.eventData!['genreCategories'].keys) {
          _genreCategories[key] = widget.eventData!['genreCategories'][key];
        }
      }

      if (widget.eventData!['options'] != null) {
        for (var key in widget.eventData!['options'].keys) {
          _options[key] = widget.eventData!['options'][key];
        }
      }

      if (widget.eventData!['images'] != null) {
        _images.addAll(widget.eventData!['images'].cast<File>());
      }
    }

    _authService.startTokenRefreshTimer();
  }

  @override
  void dispose() {
    _authService.stopTokenRefreshTimer();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _saveEvent() async {
    if (_isSaving) return; // Если сохранение уже выполняется, ничего не делаем

    setState(() {
      _isSaving = true; // Устанавливаем флаг
    });

    try {
      final eventJson = jsonEncode({
        "hia": true,
        "siteId": 52,
        "typeOfEventId": 3,
        "teenagers": true,
        "bookingTime": {
          "days": 0,
          "hours": 0,
          "minutes": 0,
        },
        "summary": _descriptionController.text.trim(),
        "prices": [
          {
            "price": int.tryParse(_priceController.text.trim()) ?? 0,
            "age": 0,
          }
        ],
        "name": _titleController.text.trim(),
        "kids": true,
        "date": _formattedDate,
        "bookingAllowed": true,
        "duration": 0,
        "adult": true,
        "description": _descriptionController.text.trim(),
        "age": 0,
        "kassir": "kassir_example",
      });

      final token = await _getToken();
      if (token == null) {
        throw Exception("Токен отсутствует. Авторизуйтесь заново.");
      }

      final uri = Uri.parse('https://museum.waranim.xyz/marketer/api/event');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(http.MultipartFile.fromString(
          'event',
          eventJson,
          contentType: MediaType('application', 'json'),
        ));

      if (_images.isNotEmpty) {
        final image = _images.first;
        if (await image.exists()) {
          request.files.add(await http.MultipartFile.fromPath(
            'images',
            image.path,
            contentType: MediaType('image', 'jpeg'),
          ));
        } else {
          throw Exception("Файл изображения не найден: ${image.path}");
        }
      } else {
        throw Exception("Нет изображений для загрузки");
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseBody.isEmpty) {
          print("Успешный ответ, но тело ответа пустое.");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Мероприятие успешно создано!")),
          );
        } else {
          print("Успешный ответ: $responseBody");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Мероприятие успешно создано!")),
          );
        }
        Navigator.pop(context);
      } else {
        print("Ответ сервера: $responseBody");
        throw Exception("Не удалось создать мероприятие: ${response.statusCode}");
      }
    } catch (error) {
      print("Ошибка: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Не удалось создать мероприятие: $error")),
      );
    } finally {
      setState(() {
        _isSaving = false; // Сбрасываем флаг
      });
    }
  }


  Future<String?> _getToken() async {
    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      await authService.refreshAccessToken();
      token = await storage.read(key: 'access_token');
    }
    return token;
  }

  Widget _buildCheckbox(String label, Map<String, bool> map) {
    return Row(
      children: [
        Checkbox(
          value: map[label],
          onChanged: (bool? newValue) {
            setState(() {
              map[label] = newValue ?? false;
            });
          },
        ),
        Expanded(child: Text(label)),
      ],
    );
  }

  Widget _buildImageItem(File file) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        file,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildAddPhotoItem() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.add_photo_alternate_outlined,
          color: Colors.grey[600],
          size: 32,
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // День
            Expanded(
              child: TextField(
                controller: _dayController,
                maxLength: 2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'День',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            SizedBox(width: 8),

            // Месяц
            Expanded(
              child: TextField(
                controller: _monthController,
                maxLength: 2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Месяц',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            SizedBox(width: 8),

            // Год
            Expanded(
              child: TextField(
                controller: _yearController,
                maxLength: 4,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Год',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),

        Row(
          children: [
            // Часы
            Expanded(
              child: TextField(
                controller: _hourController,
                maxLength: 2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Часы',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            SizedBox(width: 8),

            // Минуты
            Expanded(
              child: TextField(
                controller: _minuteController,
                maxLength: 2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Минуты',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),

        // Ошибка
        if (_dateError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _dateError!,
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

// Проверка даты перед сохранением
  void _validateAndSaveEvent() {
    final formattedDate = _getFormattedDate();
    if (formattedDate == null || !_isValidDate(formattedDate)) {
      setState(() {
        _dateError = "Введите корректную дату в формате ДД-ММ-ГГГГ ЧЧ:ММ";
      });
      return;
    }

    setState(() {
      _dateError = null;
      _formattedDate = formattedDate; // Сохраняем дату
    });

    // Вызываем сохранение
    _saveEvent();
  }


// Проверка формата даты
  bool _isValidDate(String date) {
    final regex = RegExp(r'^\d{2}-\d{2}-\d{4} \d{2}:\d{2}$');
    return regex.hasMatch(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventData == null ? 'Создать мероприятие' : 'Редактировать мероприятие'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Название мероприятия
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Название',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Место проведения
            TextField(
              controller: _placeController,
              decoration: InputDecoration(
                labelText: 'Место',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Время проведения
            _buildDateField(),
            SizedBox(height: 16),

            // Описание мероприятия
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Описание',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Фото
            Text('Фото', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var file in _images) _buildImageItem(file),
                _buildAddPhotoItem(),
              ],
            ),
            SizedBox(height: 16),

            // Категории
            Text('Категории', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            TextField(
              controller: _priceController,
              maxLines: 1,
              decoration: InputDecoration(
                labelText: 'Цена',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            SizedBox(height: 8),
            ..._ageCategories.keys.map((key) => _buildCheckbox(key, _ageCategories)).toList(),
            SizedBox(height: 16),

            // Жанры
            Text('Жанры', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ..._genreCategories.keys.map((key) => _buildCheckbox(key, _genreCategories)).toList(),
            SizedBox(height: 16),

            // Инклюзивность
            Text('Инклюзивность', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ..._options.keys.map((key) => _buildCheckbox(key, _options)).toList(),
            SizedBox(height: 16),

            // Кнопка сохранения
            ElevatedButton(
              onPressed: _validateAndSaveEvent,
              child: Text(widget.eventData == null ? 'Создать' : 'Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
