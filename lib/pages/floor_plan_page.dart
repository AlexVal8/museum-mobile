import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';

class FloorPlanPage extends StatefulWidget {
  @override
  _FloorPlanPageState createState() => _FloorPlanPageState();
}

class _FloorPlanPageState extends State<FloorPlanPage> {
  Map<String, String> _roomInfo = {
    'room1': 'Информация о комнате 1',
    'room2': 'Информация о комнате 2',
  };

  int _currentIndex = 0;

  final List<String> _floorPlans = [
    'assets/images/floor0.svg',
    'assets/images/floor1.svg',
    'assets/images/floor2.svg',
  ];

  final List<String> _floorNames = [
    'Цокольный этаж',
    'Первый этаж',
    'Второй этаж'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isPortrait = constraints.maxHeight > constraints.maxWidth;
          return isPortrait ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    children:
                    List.generate(_floorPlans.length, (index) {
                      int reverseIndex = _floorPlans.length - 1 - index;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _currentIndex = reverseIndex;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: _currentIndex == reverseIndex ? Color(0xff156B55) : Color(0xff4B635A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          //  primary: Colors.white, // Text color
                          ),
                          child: Container(
                            width: 64 - 15,
                            height: 48 - 15,
                            alignment: Alignment.center,
                            child: Text(
                              '$reverseIndex',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: Text(
                  _floorNames[_currentIndex],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: PhotoView.customChild(
                  child: SvgPicture.asset(
                    _floorPlans[_currentIndex],
                    fit: BoxFit.contain,
                  ),
                  backgroundDecoration: BoxDecoration(color: Colors.white),
                  minScale: PhotoViewComputedScale.contained * 1.0,
                  maxScale: PhotoViewComputedScale.covered * 2.0,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 34, bottom: 34),
                child: Icon(Icons.screen_rotation_sharp,
                  size: 30,),
              )
            ],
          ) : Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(_floorPlans.length, (index) {
                      int reverseIndex = _floorPlans.length - 1 - index;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _currentIndex = reverseIndex;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: _currentIndex == reverseIndex ? Color(0xff156B55) : Color(0xff4B635A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                         //   primary: Colors.white, // Text color
                          ),
                          child: Container(
                            width: 64 - 15,
                            height: 48 - 15,
                            alignment: Alignment.center,
                            child: Text(
                              '$reverseIndex',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    Center(
                      child: Text(
                        _floorNames[_currentIndex],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: PhotoView.customChild(
                        child: SvgPicture.asset(
                          _floorPlans[_currentIndex],
                          fit: BoxFit.contain,
                        ),
                        backgroundDecoration: BoxDecoration(color: Colors.white),
                        minScale: PhotoViewComputedScale.contained * 1.0,
                        maxScale: PhotoViewComputedScale.covered * 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}







