import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:museum/pages/home_page.dart';
import 'package:museum/pages/statWeek.dart';

import '../pages/floor_plan_page.dart';
import '../pages/histories.dart';
import '../pages/presentation.dart';
import '../pages/rules.dart';
import '../pages/statWeek.dart';
import '../utils/badge_icon.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();

}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ));
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: _getPage(_currentIndex),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            backgroundColor: Color(0xffD5E2D5),
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            selectedItemColor: Color(0xff156B55),
            unselectedItemColor: Color(0xff9B9B9B),
            selectedLabelStyle: TextStyle(color: Color(0xff156B55), fontSize: 12, fontFamily: 'Roboto', fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(color: Color(0xff9B9B9B), fontSize: 12, fontFamily: 'Roboto', fontWeight: FontWeight.w600),

            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/main.svg',
                  width: 32,
                  height: 32,
                ),
                activeIcon: SvgPicture.asset(
                  'assets/images/main_select.svg',
                  width: 32,
                  height: 32,
                ),
                label: 'главная',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/map.svg',
                  width: 32,
                  height: 32,
                ),
                activeIcon: SvgPicture.asset(
                  'assets/images/map_select.svg',
                  width: 32,
                  height: 32,
                ),
                label: 'карта',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/stat.svg',
                  width: 32,
                  height: 32,
                ),
                activeIcon: SvgPicture.asset(
                  'assets/images/stat_select.svg',
                  width: 32,
                  height: 32,
                ),
                label: 'статистика',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/rules.svg',
                  width: 32,
                  height: 32,
                ),
                activeIcon: SvgPicture.asset(
                  'assets/images/rules_select.svg',
                  width: 32,
                  height: 32,
                ),
                label: 'правила',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   systemNavigationBarColor: Colors.black
    // ));
    super.dispose();
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return FloorPlanPage();
      case 2:
        return StatWeek();
      case 3:
        return Rules();
      default:
        return UnderDevelopmentPage();
    }
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