import 'package:flutter/material.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({Key? key}) : super(key: key);

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage>
    with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Цвет фона всего экрана (примерно под макет)
      backgroundColor: const Color(0xFFF5FBF6),
      appBar: AppBar(
        automaticallyImplyLeading: false, // убираем кнопку назад
        elevation: 0,                    // убираем разделительную полосу
        backgroundColor: const Color(0xFFF5FBF6),
        centerTitle: true,
        title: const Text(
          'История',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          // Блок переключения вкладок (Активные / Архив)
          _buildTabSelector(),

          // Содержимое вкладок
          Expanded(
            child: _selectedTabIndex == 0
                ? _buildActiveTab()
                : _buildArchiveTab(),
          ),
        ],
      ),
    );
  }

  /// Виджет со «сложной» овальной подложкой, внутри которой две кнопки.
  Widget _buildTabSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Color(0xFFD9D9D9),             // цвет «овала»
          borderRadius: BorderRadius.circular(15),
        ),
        // Делаем две вкладки одинаковой ширины
        child: Row(
          children: [
            Expanded(child: _buildTabButton(index: 0, text: 'Активные')),
            Expanded(child: _buildTabButton(index: 1, text: 'Архив')),
          ],
        ),
      ),
    );
  }

  /// Каждая «вкладка» – это интерактивный контейнер.
  /// Если вкладка активна, то у неё другой цвет фона и/или текста.
  Widget _buildTabButton({required int index, required String text}) {
    final bool isSelected = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFF5FBF6) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,

            ),
          ),
        )
      ),
    );
  }

  /// Вкладка "Активные"
  Widget _buildActiveTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          _EventCard(
            title: '«Театр: люблю и ненавижу»',
            dateTime: '24 мая, 19:30',
            imageUrl: 'https://via.placeholder.com/120x80?text=Theater',
          ),
          const SizedBox(height: 16),
          _EventCard(
            title: '«Резо» (12+)',
            dateTime: '2 апреля, 19:00',
            imageUrl: 'https://via.placeholder.com/120x80?text=Rezo',
          ),
        ],
      ),
    );
  }

  /// Вкладка "Архив"
  Widget _buildArchiveTab() {
    return Center(
      child: Text(
        'Архив пуст',
        style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
      ),
    );
  }
}

/// Виджет для карточки события.
class _EventCard extends StatelessWidget {
  final String title;
  final String dateTime;
  final String imageUrl;

  const _EventCard({
    Key? key,
    required this.title,
    required this.dateTime,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Цвет карточки – ориентируемся на макет
      decoration: BoxDecoration(
        color: Color(0x2B156B55),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Картинка
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.network(
              imageUrl,
              width: 100,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Текст
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateTime,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
