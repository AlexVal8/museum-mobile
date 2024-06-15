import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:museum/pages/home_page.dart';

import '../pages/floor_plan_page.dart';
import '../pages/histories.dart';
import '../pages/presentation.dart';
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
          child: NavigationBar(
            backgroundColor: Color(0xffF3EDF7),
            selectedIndex: _currentIndex,
            indicatorColor: Color(0xffE8DEF8),
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: [
              NavigationDestination(icon: Icon(Icons.circle, size: 15, color: Color(0xff1D192B)), label: 'Label'),
              NavigationDestination(icon: Icon(Icons.circle, size: 15, color: Color(0xff49454F)), label: 'Label'),
              NavigationDestination(icon: Icon(Icons.circle, size: 15, color: Color(0xff49454F)), label: 'Label'),
              NavigationDestination(
                icon: BadgeIcon(),
                label: 'Label',
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
        return Historie();
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