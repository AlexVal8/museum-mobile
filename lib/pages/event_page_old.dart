import 'package:flutter/material.dart';
import '../utils/launch_url.dart';

class EventPageOld extends StatefulWidget {
  final List<Widget> items;
  final String? name;
  final String description;
  final String? genre;
  final String? age_limit;
  final String? time;
  final String? location;
  final String? photo_location;
  final String? price;
  final String? url;

  EventPageOld({
    required this.items,
    this.name,
    required this.description,
    this.genre,
    this.age_limit,
    this.time,
    this.location,
    this.price,
    this.url,
    this.photo_location,
  });

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPageOld> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 250,
                  child: PageView.builder(
                    itemCount: widget.items.length,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      return FittedBox(
                        fit: BoxFit.fitWidth,
                        child: widget.items[index],
                      );
                    },
                  ),
                ),
                if (widget.items.length > 1)
                  Container(
                    width: 38,
                    height: 17,
                    margin: EdgeInsets.only(bottom: 45),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(999)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.items.length,
                            (index) => Container(
                          width: 11.0,
                          height: 11.0,
                          margin: EdgeInsets.symmetric(horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Transform.translate(
              offset: Offset(0,-40),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    if (widget.name != null) SizedBox(height: 40,),
                    if (widget.name != null) Text(widget.name!,
                      style: TextStyle(
                        color: Color(0xff171D1A),
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700,
                          fontSize: 20
                      ),),
                    if (widget.genre != null)SizedBox(height: 12,),
                    if (widget.genre != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 22, top:16),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(widget.genre!,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                fontSize: 16
                            ),),
                        ),
                      ),
                    if (widget.age_limit != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 22),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(widget.age_limit!,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                fontSize: 16
                            ),),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 22, top: 16, bottom: 16, right: 16),
                      child:  Row(
                        children: [
                          if (widget.photo_location != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              width: 100,
                              height: 100,
                              child: Image.asset(
                                widget.photo_location!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          if (widget.location != null || widget.time != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.place, color: Color(0xff406376), size: 25,),
                                    SizedBox(width: 4),
                                    Text("Место и время:",
                                      style: TextStyle(
                                          color: Color(0xff406376),
                                          fontSize: 16,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w600
                                      ),)
                                  ],
                                ),
                                SizedBox(height: 10,),
                                SizedBox(
                                  width: 200,
                                  child: Text(
                                    widget.time!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Montserrat",
                                        fontSize: 14
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 204,
                                  child: Text(
                                    widget.location!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Montserrat",
                                        fontSize: 14
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 375,
                      child: Padding(
                        padding: const EdgeInsets.only( left: 16, right: 16),
                        child: Text(widget.description,
                          style: TextStyle(
                            color: Color(0xff171D1A),
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                              fontSize: 16
                          ),),
                      ),
                    ),
                    if (widget.price != null)
                      SizedBox(height: 22),
                    if (widget.price != null)
                      SizedBox(
                        width: 375,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Text(
                            "Стоимость: ${widget.price!}",
                            style: TextStyle(
                              color: Color(0xff171D1A),
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                    if (widget.price != null)
                      SizedBox(height:16),
                    if (widget.url != null)
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff156B55),
                          minimumSize: Size(343, 49),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          launchURL(widget.url!);
                        },
                        child: Text('Купить билет',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.white
                          ),),
                      ),
                    if (widget.url != null)
                      SizedBox(height: 16),
                    if (widget.url != null)
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff6B2415),
                          minimumSize: Size(343, 49),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {},
                        child: Text('Забронировать',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.white
                          ),),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
