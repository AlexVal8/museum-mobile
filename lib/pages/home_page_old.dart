import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:museum/controllers/login_controller.dart';

import '../utils/carousel.dart';
import '../utils/text_field.dart';
import 'event_page.dart';
import 'event_page_old.dart';

class HomePageOld extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageOld> {
  int pageIndex = 0;
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Map<String, dynamic>> _filteredPoster = [];

  final AuthService authService = AuthService();

  // Списки мероприятий и их описания
  final List<Map<String, dynamic>> _demoPoster = [
    {
      'images': ["assets/images/poster2.jpg", "assets/images/poster1.jpg"],
      'name': "«Театр: люблю и ненавижу»",
      'genre': "Жанр: Концерт",
      'age_limit': "Возрастное ограничение: 16+",
      'time': "24 мая, 19:30",
      'location': "Креативный кластер «Л52» пр. Ленина, 52",
      'photo_location': "assets/images/demoplace.jpg",
      'description': "Актеры Открытого студийного театра обратятся к личному опыту и попытаются разобраться в чувствах по отношению к своему делу. Мир театра не так уж далек от обычной жизни: здесь также по-разному складываются судьбы, сталкиваются амбиции и возможности, возникает горячая увлеченность и болезненное разочарование, сходятся и расходятся разные характеры. Это спектакль-признание в том, что занятие театром вызывает целую гамму чувств, которые, скорее всего, хорошо знакомы тем, кто также пытается реализовать себя в чем-то лично значимом.",
      'price': "400 руб.",
      'url': 'https://ekb.kassir.ru/frame/event/2115925?key=7c3aaea1-b122-cc20-e512-a1bb29918d2d&WIDGET_697006768=t9525kl5pb3gahj2eq9g20hdbp'
    },
    {
      'images': ["assets/images/demoitem2.jpg"],
      'name' : "«Исследования»",
      'genre': "Жанр: Экскурсия",
      'age_limit': "Возрастное ограничение: 16+",
      'time': "24 мая, 19:30",
      'location': "Креативный кластер «Л52» пр. Ленина, 52",
      'description': "Актеры Открытого студийного театра обратятся к личному опыту и попытаются разобраться в чувствах по отношению к своему делу. Мир театра не так уж далек от обычной жизни: здесь также по-разному складываются судьбы, сталкиваются амбиции и возможности, возникает горячая увлеченность и болезненное разочарование, сходятся и расходятся разные характеры. Это спектакль-признание в том, что занятие театром вызывает целую гамму чувств, которые, скорее всего, хорошо знакомы тем, кто также пытается реализовать себя в чем-то лично значимом.",
      'price': "400 руб."
    },
  ];

  final List<Map<String, dynamic>> _demoNews = [
    {
      'name' : "«Исследования»",
      'images': ["assets/images/demoitem4.jpg"],
      'description': "Актеры Открытого студийного театра"
    },
    {
      'images': ["assets/images/demoitem5.jpg"],
      'description': "Описание новости 2"
    },
    {
      'name' : "«Исследования»",
      'images': ["assets/images/demoitem6.jpg"],
      'description': "Описание новости 3"
    },
  ];

  final List<Map<String, dynamic>> _demoPaper = [
    {
      'name' : "«Статья»",
      'images': ["assets/images/demoitem7.jpg"],
      'description': "Описание статьи 1"
    },
    {
      'images': ["assets/images/demoitem8.jpg"],
      'description': "Описание статьи 2"
    },
    {
      'images': ["assets/images/demoitem9.jpg"],
      'description': "Описание статьи 3"
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _isSearching = _searchController.text.isNotEmpty;
        _filteredPoster = _demoPoster.where((item) {
          final name = item['name']?.toLowerCase();
          final searchTerm = _searchController.text.toLowerCase();
          final description = item["description"]?.toLowerCase();
          return name != null && name.contains(searchTerm) || description != null && description.contains(searchTerm);
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 22),
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset("assets/icons/logo_vector.svg",width: 210,),
                ),
                Spacer(),
                IconButton(
                  padding: EdgeInsets.only(right: 30),
                  icon: Icon(Icons.logout, size: 40,),
                  alignment: Alignment.centerRight,
                  onPressed: () { authService.logoutUser(context); },
                )
              ],
            ),
            SizedBox(height: 16),
            if (_isSearching != true)
            Container(
                width: 343,
                height: 249,
                decoration: BoxDecoration(
                  color: Color(0xffE9EFEB),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: CarouselWidget(
                  items: _demoPoster.map((event) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventPageOld(
                            name: event['name'],
                            items: event['images']
                                .map<Widget>((image) => Image.asset(image))
                                .toList(),
                            description: event['description'],
                            genre: event['genre'],
                            age_limit: event['age_limit'],
                            time: event['time'],
                            location: event['location'],
                            photo_location: event['photo_location'],
                            price: event['price'],
                            url: event['url'],
                          ),
                        ),
                      );
                    },
                    child: Image.asset(event['images'][0], fit: BoxFit.cover),
                  )).toList(),
                  title: "Афиша", name: _demoPoster.map((event) => event['name'] != null ? event['name'] as String : '').toList(),
                )
            ),
            SizedBox(height: 16),
            MyTextField(
              controller: _searchController,
              readOnly: false,
              suffixIcon: const Icon(Icons.search, color: Color(0xff49454F)),
              hintText: 'Поиск',
              obscureText: false,
              prefixIcon: const Icon(Icons.menu, color: Color(0xff49454F)),
            ),
            SizedBox(height: 16),
            _isSearching
                ? _buildSearchResults()
                : Column(
              children: [
                Container(
                    width: 343,
                    height: 249,
                    decoration: BoxDecoration(
                      color: Color(0xffE9EFEB),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: CarouselWidget(
                      items: _demoNews.map((event) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventPageOld(
                                items: event['images']
                                    .map<Widget>((image) => Image.asset(image))
                                    .toList(),
                                description: event['description'],
                              ),
                            ),
                          );
                        },
                        child: Image.asset(event['images'][0]),
                      )).toList(),
                      title: "Новости", name: _demoNews.map((event) => event['name'] != null ? event['name'] as String : '').toList(),
                    )
                ),
                SizedBox(height: 16),
                Container(
                    width: 343,
                    height: 249,
                    decoration: BoxDecoration(
                      color: Color(0xffE9EFEB),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: CarouselWidget(
                      items: _demoPaper.map((event) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventPageOld(
                                items: event['images']
                                    .map<Widget>((image) => Image.asset(image))
                                    .toList(),
                                description: event['description'],
                              ),
                            ),
                          );
                        },
                        child: Image.asset(event['images'][0]),
                      )).toList(),
                      title: "Интересные статьи", name: _demoPaper.map((event) => event['name'] != null ? event['name'] as String : '').toList(),
                    )
                ),
                SizedBox(height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Column(
      children: _filteredPoster.map((event) {
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              event['images'][0],
              width: 80,
              height: 60,
              fit: BoxFit.fill,
            ),
          ),
          title: Text(event['name'] ?? ''),
          subtitle: Text(event['genre'] ?? ''),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventPageOld(
                  name: event['name'],
                  items: event['images']
                      .map<Widget>((image) => Image.asset(image))
                      .toList(),
                  description: event['description'],
                  genre: event['genre'],
                  age_limit: event['age_limit'],
                  time: event['time'],
                  location: event['location'],
                  photo_location: event['photo_location'],
                  price: event['price'],
                  url: event['url'],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

