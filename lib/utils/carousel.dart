import 'package:flutter/material.dart';

class CarouselWidget extends StatelessWidget {
  final String title;
  final List<Widget> items;
  final List<String?> name;

  const CarouselWidget({
    Key? key,
    required this.items,
    required this.title,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16, left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: Container(
              child: Padding(
                padding: EdgeInsets.only(left: 32, right: 24, top: 24, bottom: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Stack(
                              children: [
                                Container(
                                  width: 150,
                                  height: double.infinity,
                                  child: FittedBox(
                                    child: items[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    color: Colors.black.withOpacity(0.5),
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      name[index] ?? '',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ]
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
        ),
      ],
    );
  }
}