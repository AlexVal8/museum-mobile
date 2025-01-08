import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:museum/pages/home_page.dart';
import 'package:museum/pages/statWeek.dart';
import 'package:museum/pages/ticket_page.dart';

import '../pages/create_event_page.dart';
import '../pages/events_created_page.dart';
import '../pages/floor_plan_page.dart';
import '../pages/histories.dart';
import '../pages/presentation.dart';
import '../pages/push_notification_page.dart';
import '../pages/rules.dart';
import '../pages/statWeek.dart';
import '../pages/tickets_page.dart';
import '../utils/badge_icon.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final bool isAdmin; // Флаг для проверки роли

  CustomBottomNavigationBar({required this.isAdmin});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;

  List<BottomNavigationBarItem> _getNavigationItems() {
    if (widget.isAdmin) {
      return [
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/images/main.svg', width: 32, height: 32),
          activeIcon:
          SvgPicture.asset('assets/images/main_select.svg', width: 32, height: 32),
          label: 'главная',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/images/events_select.svg', width: 32, height: 32, color: Color(0xff156B55)),
          activeIcon:
          SvgPicture.asset('assets/images/events.svg', width: 32, height: 32, color: Color(0xff156B55)),
          label: 'мероприятия',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/images/stat.svg', width: 32, height: 32),
          activeIcon:
          SvgPicture.asset('assets/images/stat_select.svg', width: 32, height: 32),
          label: 'статистика',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/images/push.svg', width: 32, height: 32, color: Color(0xff156B55)),
          activeIcon:
          SvgPicture.asset('assets/images/push_select.svg', width: 32, height: 32, color: Color(0xff156B55)),
          label: 'Пуш',
        ),
      ];
    } else {
      return [
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/images/main.svg', width: 32, height: 32),
          activeIcon:
          SvgPicture.asset('assets/images/main_select.svg', width: 32, height: 32),
          label: 'главная',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/images/map.svg', width: 32, height: 32),
          activeIcon:
          SvgPicture.asset('assets/images/map_select.svg', width: 32, height: 32),
          label: 'карта',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/images/rules.svg', width: 32, height: 32),
          activeIcon:
          SvgPicture.asset('assets/images/rules_select.svg', width: 32, height: 32),
          label: 'правила',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset('assets/images/ticket_select.svg', width: 32, height: 32,color: Color(0xff156B55)),
          activeIcon:
          SvgPicture.asset('assets/images/ticket.svg', width: 32, height: 32,color: Color(0xff156B55)),
          label: 'билеты',
        ),
      ];
    }
  }

  Widget _getPage(int index) {
    if (widget.isAdmin) {
      switch (index) {
        case 0:
          return HomePage();
        case 1:
          return EventsCreatedPage();
        case 2:
          return StatWeek();
        case 3:
          return PushNotificationPage();
        default:
          return UnderDevelopmentPage();
      }
    } else {
      switch (index) {
        case 0:
          return HomePage();
        case 1:
          return FloorPlanPage();
        case 2:
          return Rules();
        case 3:
          return TicketsPage();
        default:
          return UnderDevelopmentPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _getNavigationItems(),
        selectedItemColor: Color(0xff156B55),
        unselectedItemColor: Color(0xff9B9B9B),
        backgroundColor: Color(0xffD5E2D5),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class UnderDevelopmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('В разработке'),
      ),
      body: Center(
        child: Text(
          'Эта страница находится в разработке.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}