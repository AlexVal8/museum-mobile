import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:carousel_indicator/carousel_indicator.dart';

import 'package:museum/controllers/login_controller.dart';
import 'package:museum/controllers/site_controller.dart';
import 'package:museum/controllers/token_service.dart';
import 'package:museum/controllers/type_of_event_controller.dart';
import 'package:museum/controllers/event_controller.dart';
import 'package:museum/utils/service_locator.dart';

import 'ticket_page.dart';

class EventPage extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventPage({Key? key, required this.event}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  // Сервисы
  final AuthService authService = AuthService();
  final EventsService eventsService = EventsService();
  final SiteService siteService = SiteService();
  final TypeOfEventService typeOfEventService = TypeOfEventService();
  final TokenService tokenService = getIt<TokenService>();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // Данные, которые подгружаем
  Map<String, dynamic>? event;
  Map<String, dynamic>? site;
  Map<String, dynamic>? typeOfEvent;

  // Байты изображений
  List<Uint8List?> images = [];

  // Состояние загрузки/ошибок
  bool _isLoading = true;
  String? _errorMessage;

  // Состояние лайка
  bool _isLike = false;

  // Для карусели
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  /// Основная логика загрузки события
  Future<void> _loadEvent() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // final token = await tokenService.getAccessToken();
      final token = await storage.read(key: 'access_token');
      if (token == null) {
        setState(() {
          _errorMessage = 'Токен не найден, авторизуйтесь заново';
          _isLoading = false;
        });
        return;
      }

      final result = await _fetchEvent(token, widget.event["id"]);
      if (result == null) {
        setState(() {
          _errorMessage = 'Не удалось получить данные о событии';
          _isLoading = false;
        });
      } else {
        setState(() {
          event = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка загрузки: $e';
        _isLoading = false;
      });
    }
  }

  /// Несколько попыток получить event + site + typeOfEvent
  Future<Map<String, dynamic>?> _fetchEvent(String token, int eventId) async {
    for (int i = 0; i < 3; i++) {
      try {
        final eventData = await eventsService.fetchEventById(token, eventId);

        if (eventData != null) {
          final siteData = await siteService.getSite(token, eventData['siteId']);
          final typeOfEventData = await typeOfEventService.getTypeOfEvent(
            token,
            eventData['typeOfEventId'],
          );

          final rawLinks = eventData['images'] as List<dynamic>? ?? [];
          final List<String> imageLinks =
          rawLinks.map((image) => image['link'] as String).toList();
          final loadedImages = await _fetchEventImages(token, imageLinks);

          setState(() {
            site = siteData;
            typeOfEvent = typeOfEventData;
            images = loadedImages;
          });

          return eventData;
        }
      } catch (e) {
        print("Failed to fetch event $eventId, attempt ${i + 1}, error: $e");

        await Future.delayed(const Duration(seconds: 2));
      }
    }

    return null;
  }

  /// Загрузить изображения по списку ссылок
  Future<List<Uint8List?>> _fetchEventImages(String token, List<String> links) async {
    final futures = <Future<Uint8List?>>[];

    for (String link in links) {
      final id = link.split('/').last;
      futures.add(eventsService.fetchEventImage("Bearer $token", id));
    }

    return Future.wait(futures);
  }

  /// Изменение состояния лайка
  void _toggleLike() {
    setState(() {
      _isLike = !_isLike;
    });
  }

  /// Форматировать дату
  String formatDate(String dateStr) {
    final format = DateFormat("dd-MM-yyyy HH:mm");

    final dateTime = format.parse(dateStr);
    return DateFormat("d MMMM, HH:mm", 'ru').format(dateTime);
  }

  /// Виджет карусели
  Widget _buildCarousel() {
    if (images.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Center(child: Text('Нет изображений')),
      );
    } else {
      return Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            children: images.map((imgBytes) {
              if (imgBytes == null) {
                return Container(
                  color: Colors.grey,
                  child: const Center(child: Icon(Icons.error)),
                );
              }
              return Image.memory(
                imgBytes,
                fit: BoxFit.cover,
              );
            }).toList(),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: CarouselIndicator(
                count: images.length,
                index: _currentIndex,
                color: Colors.white54,
                activeColor: Colors.white,
              ),
            ),
          ),
        ],
      );
    }
  }

  /// Нажатие на "Купить билет"
  void _onBuyTicket() {
    if (event == null) return;

    final eventData = event!;
    final eventName = eventData['name'] ?? 'Название не указано';
    final dateText = (eventData['date'] != null) ? formatDate(eventData['date']) : 'Не указана';
    final siteName = site?['name'] ?? '';
    final siteAddress = site?['address'] ?? '';
    final siteText = '$siteName\n$siteAddress';

    Uint8List? firstImage = images.isNotEmpty ? images.first : null;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketPage(
          performanceTitle: eventName,
          dateTimePlace: '$dateText\n$siteText',
          ticketNumber: '${eventData["id"].hashCode}',
          isPaid: true,
          isBookedFirstStep: false,
          isVisibleButton: true,
          countHours: 48,
          performanceImageWidget: (firstImage != null)
              ? Image.memory(
            firstImage,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          )
              : null,
        ),
      ),
    );
  }

  /// Нажатие на "Забронировать"
  void _onReserveTicket() {
    if (event == null) return;

    final eventData = event!;
    final eventName = eventData['name'] ?? 'Название не указано';
    final dateText = (eventData['date'] != null) ? formatDate(eventData['date']) : 'Не указана';
    final siteName = site?['name'] ?? '';
    final siteAddress = site?['address'] ?? '';
    final siteText = '$siteName\n$siteAddress';

    Uint8List? firstImage = images.isNotEmpty ? images.first : null;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketPage(
          performanceTitle: eventName,
          dateTimePlace: '$dateText\n$siteText',
          ticketNumber: '${eventData["id"].hashCode}',
          isPaid: false,
          isBookedFirstStep: true,
          isVisibleButton: true,
          countHours: 48,
          performanceImageWidget: (firstImage != null)
              ? Image.memory(
            firstImage,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ошибка'),
          centerTitle: true,
        ),
        body: Center(child: Text(_errorMessage!)),
      );
    }

    if (event == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Мероприятие'),
          centerTitle: true,
        ),
        body: const Center(child: Text('Не удалось получить данные о мероприятии')),
      );
    }

    // Мероприятие
    final eventData = event!;
    final eventName = eventData['name'] ?? 'Название не указано';

    // Тип мероприятия
    final typeName = typeOfEvent?['name'] ?? 'Тип не указан';

    // Возраст
    final age = eventData['age'] ?? 0;

    // Дата
    String dateText = 'Дата не указана';
    if (eventData['date'] != null) {
      dateText = formatDate(eventData['date']);
    }

    // Описание
    final rawDescription = eventData['description'] ?? '';
    final description = rawDescription.replaceAll(r'\n', '\n');

    // Цены
    String priceText = 'Цена не указана';
    final prices = eventData['prices'] as List<dynamic>?;
    if (prices != null && prices.isNotEmpty && prices.first['price'] != null) {
      priceText = 'Стоимость: ${prices.first['price']} руб.';
    }

    // Площадка и адрес
    String siteText = 'Площадка не указана';
    if (site != null && site!['name'] != null && site!['address'] != null) {
      siteText = '${site!['name']}\n${site!['address']}';
    }

    // Высота экрана
    final screenHeight = MediaQuery.of(context).size.height;
    // 1/3 под карусель
    final double carouselHeight = screenHeight / 3;
    const double cornerRadius = 24;
    // Верхний отступ карточки
    final double cardTop = carouselHeight - cornerRadius;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Карусель
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: carouselHeight,
            child: _buildCarousel(),
          ),

          // Белая карточка
          Positioned(
            top: cardTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5FBF6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(cornerRadius),
                  topRight: Radius.circular(cornerRadius),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заголовок
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            eventName,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Жанр, возраст и лайк
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Text(
                                'Жанр: $typeName',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Возрастное ограничение: $age+',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        ),
                        IconButton(
                          onPressed: () {
                            _toggleLike();
                          },
                          iconSize: 40,
                          icon: Icon(
                            _isLike? Icons.favorite : Icons.favorite_border,
                            color: Colors.teal
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_rounded, color: Color(0xFF406376)),
                        SizedBox(width: 4.0),
                        Text(
                          "Место и время:",
                          style: TextStyle(
                            color: Color(0xFF406376),
                            fontSize: 22,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    ),

                    // Место и дата
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dateText,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                siteText,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      "О мероприятии:",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Описание
                    Text(
                      description,
                      style: const TextStyle(fontSize: 20, height: 1.2),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 16),

                    // Телефон (пока зашитый)
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Телефон: ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '+7 950 000 00 00',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Стоимость
                    Row(
                      children: [
                        Text(
                          priceText,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Кнопки
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF156B55),
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: _onBuyTicket,
                                  child: const Text(
                                      'Купить билет',
                                      style: TextStyle(fontSize: 20)
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF6B2415),
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: _onReserveTicket,
                                  child: const Text(
                                      'Забронировать',
                                      style: TextStyle(fontSize: 20)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
