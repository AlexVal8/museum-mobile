import 'package:flutter/material.dart';

class CategoriesWidget extends StatefulWidget {
  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  // Состояния для чекбоксов
  Map<String, bool> _ageCategories = {
    "0+": false,
    "6+": false,
    "12+": false,
    "16+": false,
    "18+": false,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Категории:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),

        Text(
          "Возраст:",
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),

        // Чекбоксы в две колонки
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Первая колонка
            Expanded(
              child: Column(
                children: [
                  _buildCheckbox("0+"),
                  _buildCheckbox("6+"),
                  _buildCheckbox("12+"),
                ],
              ),
            ),
            SizedBox(width: 16), // Промежуток между колонками
            // Вторая колонка
            Expanded(
              child: Column(
                children: [
                  _buildCheckbox("16+"),
                  _buildCheckbox("18+"),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Виджет чекбокса с текстом
  Widget _buildCheckbox(String label) {
    return Row(
      children: [
        Checkbox(
          value: _ageCategories[label],
          onChanged: (bool? newValue) {
            setState(() {
              _ageCategories[label] = newValue ?? false;
            });
          },
        ),
        Text(label),
      ],
    );
  }
}
