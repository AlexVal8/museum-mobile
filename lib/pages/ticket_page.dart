import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:typed_data';

class TicketPage extends StatefulWidget {
  /// Заголовок спектакля
  final String performanceTitle;

  /// Место и дата/время
  final String dateTimePlace;

  /// Номер билета (или код брони)
  final String ticketNumber;

  /// Флаг: куплен ли билет (true) или пока только бронь (false)
  final bool isPaid;

  /// Флаг: находится ли пользователь ещё на первом шаге бронирования
  final bool isBookedFirstStep;

  /// Флаг: показывать ли кнопку
  final bool isVisibleButton;

  /// Сколько часов осталось до окончания брони
  final int countHours;

  /// Готовый виджет с изображением, если уже создан
  final Image? performanceImageWidget;

  /// Данные изображения в памяти
  final Uint8List? performanceImageData;

  const TicketPage({
    Key? key,
    this.performanceTitle = "Спектакль «Театр: люблю и ненавижу»",
    this.dateTimePlace = "24 мая, 19:30\nКреативный кластер «Л52»\nпр. Ленина, 52",
    this.ticketNumber = "WNWSF6L",

    this.isPaid = false,
    this.isBookedFirstStep = true,
    this.isVisibleButton = true,
    this.countHours = 48,

    this.performanceImageWidget,
    this.performanceImageData,
  }) : super(key: key);

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  late bool isPaid;
  late bool isBookedFirstStep;
  late bool isVisibleButton;
  late int countHours;

  @override
  void initState() {
    super.initState();
    isPaid = widget.isPaid;
    isBookedFirstStep = widget.isBookedFirstStep;
    isVisibleButton = widget.isVisibleButton;
    countHours = widget.countHours;
  }

  /// Метод, который возвращает нужное изображение (или заглушку)
  Widget _buildPerformanceImage() {
    if (widget.performanceImageWidget != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: widget.performanceImageWidget,
      );
    }

    if (widget.performanceImageData != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.memory(
          widget.performanceImageData!,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.asset(
        'assets/images/not_found.png',
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      ),
    );
  }

  /// Метод, который будет менять состояние.
  void _isBookedFirstStepToggle() {
    setState(() {
      if (isBookedFirstStep) {
        isBookedFirstStep = false;
      }
    });
  }

  /// Виджет с текстовым блоком и QR-кодом
  Widget _message(bool isBooked, int hours) {
    if (isBooked) {
      return Column(
        children: [
          Text(
            "Билет забронирован на $hours часов",
            style: const TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Color(0xFF156B55),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            "Благодарим за интерес к нашему мероприятию!\n"
                "Рекомендуем своевременно выкупить билеты.\nБудем рады видеть Вас!",
            style: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ],
      );
    }

    // Если билет уже не в брони (или куплен), показываем блок с билетом и QR-кодом
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x2B156B55),
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isPaid ? "Билет" : "Код брони",
            style: const TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontFamily: "Roboto",
            ),
          ),

          Text(
            widget.ticketNumber,
            style: TextStyle(
              fontSize: 22,
              color: isPaid ? const Color(0xFFE53737) : const Color(0xFF156B55),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // QR-код
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4.0),
              child: QrImageView(
                data: widget.ticketNumber,
                version: QrVersions.auto,
                errorCorrectionLevel: QrErrorCorrectLevel.H,
                size: 120.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Кнопка внизу
  Widget _button(bool isVisible, bool isBooked) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF156B55),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _isBookedFirstStepToggle,
        child: Text(
          isBooked ? "Продолжить" : "Готово",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5FBF6),
        // Основной контент
        body: SingleChildScrollView(
          padding:
          const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Название спектакля
              Text(
                widget.performanceTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Roboto",
                ),
              ),
              const SizedBox(height: 16),

              // Изображение + Блок "Место и время" в одном ряду
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPerformanceImage(),
                  const SizedBox(width: 16),

                  // Место и время + текст
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Место и время:",
                          style: TextStyle(
                            fontSize: 22,
                            color: Color(0xFF406376),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.dateTimePlace,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Блок с билетом / кодом брони / QR
              _message(isBookedFirstStep, countHours),
              const SizedBox(height: 16),

              // Благодарность за покупку (если билет куплен)
              Visibility(
                visible: isPaid,
                child: const Center(
                  child: Text(
                    "Благодарим Вас за покупку!",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Roboto",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Кнопка внизу экрана
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _button(isVisibleButton, isBookedFirstStep),
        ),
      ),
    );
  }
}
