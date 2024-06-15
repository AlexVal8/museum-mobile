import 'package:flutter/material.dart';

class BadgeIcon extends StatelessWidget {
  const BadgeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Icon(Icons.circle, size: 15, color: Color(0xff49454F)),
        Transform.translate(
          offset: Offset(7, -7),
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Color(0xffb3261e),
              borderRadius: BorderRadius.circular(1000),
            ),
            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Text(
                '3',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
      ],
    );
  }
}
