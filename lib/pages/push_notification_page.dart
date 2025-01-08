import 'package:flutter/material.dart';

class PushNotificationPage extends StatefulWidget {
  @override
  _PushNotificationPageState createState() => _PushNotificationPageState();
}

class _PushNotificationPageState extends State<PushNotificationPage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isSending = false;

  Future<void> _sendNotification() async {
    if (_titleController.text.trim().isEmpty || _bodyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Пожалуйста, заполните заголовок и текст уведомления")),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      // Пример данных для отправки
      final notificationData = {
        "title": _titleController.text.trim(),
        "body": _bodyController.text.trim(),
      };

      // Отправка запроса на сервер
      final response = await sendPushNotification(notificationData);
      if (response) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Уведомление успешно отправлено")),
        );
        _titleController.clear();
        _bodyController.clear();
      } else {
        throw Exception("Ошибка при отправке уведомления");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка: $e")),
      );
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Пуш-уведомления")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Заголовок",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Текст уведомления",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSending ? null : _sendNotification,
              child: _isSending ? CircularProgressIndicator() : Text("Отправить"),
            ),
          ],
        ),
      ),
    );
  }

  // Имитация запроса на сервер для отправки уведомления
  Future<bool> sendPushNotification(Map<String, dynamic> data) async {
    // Здесь вы отправляете данные на сервер
    // Например, через HTTP POST-запрос
    // Пример:
    // final response = await http.post(
    //   Uri.parse('https://your-server.com/api/notifications'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode(data),
    // );
    // return response.statusCode == 200;

    // Для теста
    await Future.delayed(Duration(seconds: 2));
    return true;
  }
}
