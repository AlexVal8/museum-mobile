import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventPage extends StatelessWidget {
  final Map<String, dynamic> event;

  EventPage({required this.event});

  String formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    return DateFormat("d MMMM yyyy, HH:mm", 'ru').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    // Получение данных мероприятия
    String eventName = event['name'] ?? 'Название не указано';
    String? date = event['date'];
    String formattedDate = date != null ? formatDate(date) : 'Дата не указана';
    String? address = event['address'];
    String description = event['description'] ?? 'Описание не указано';
    List<dynamic>? prices = event['prices'];
    String priceText = prices != null && prices.isNotEmpty
        ? '${prices.map((item) => item["price"] as int).reduce((a, b) => a > b ? a : b)} руб.'
        : 'Цена не указана';
    String typeText = event['typeName'] ?? 'Тип не указан';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          eventName,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: event['image'] != null
                    ? DecorationImage(
                  image: NetworkImage(event['image']['link']),
                  fit: BoxFit.cover,
                )
                    : null,
                color: Colors.grey[200],
              ),
              child: event['image'] == null
                  ? Center(
                child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
              )
                  : null,
            ),
            SizedBox(height: 16),

            // Основная информация
            Text(
              eventName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Дата: $formattedDate',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 4),
            Text(
              'Место: $address',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 4),
            Text(
              'Цена: $priceText',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 4),
            Text(
              'Тип мероприятия: $typeText',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),

            // Описание
            Text(
              'Описание',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
