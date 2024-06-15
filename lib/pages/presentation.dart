import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../classes/navigation_bar.dart';
import 'histories.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Triple<T1, T2, T3, T4> {
  T1 a;
  T2 b;
  T3 c;
  T4 d;
  Triple(this.a, this.b, this.c, this.d);

}

class Presentation extends StatefulWidget {
  const Presentation({super.key});

  @override
  State<Presentation> createState() => _PresentationState();
}

class _PresentationState extends State<Presentation> {
  Color disableButton = const Color(0xFF406376);
  Color containerColor = const Color(0xFFE9EFEB);
  Color outlineColor = const Color(0xFF707974);
  Color textColor = const Color(0xFF4B635A);
  Color lightTextColor = const Color(0xFFFFFFFF);
  Color enableButton = const Color(0xFF156B55);




  Future<void> _sendRequest() async {
    final String email = "string@string.ru";
    final String password = "stringing";
    final url = Uri.parse('http://217.119.129.70:8080/public/api/login');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({"email": email, "password": password});

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Успешный ответ: ${response.body}');
        final responseData = jsonDecode(response.body);
        final refresh_token = responseData['refresh_token'];
        final access_token = responseData['access_token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', access_token);
        await prefs.setString('refresh_token', refresh_token);
      } else {
        print('Ошибка: ${response.statusCode}');
      }
    } catch (error) {
      print('Ошибка при выполнении запроса: $error');
    }
  }

  
final List<String> text = ["Экскурсии", "Мастер-классы", "Спектакли", "Выставки", "Интерактивные занятия", "Концерты", "Лекции", "Мероприятия по генеалогии", "Творческие встречи", "Фестивали", "Артист-токи", "Кинопоказы", "Персонализация"];
final List<String> images = ["assets/pictures/excursions.jpg", "assets/pictures/master.jpg", "assets/pictures/perfomances.jpg", "assets/pictures/exhibitions.jpg", "assets/pictures/interactive.jpg", "assets/pictures/concerts.jpg", "assets/pictures/lectures.jpg", "assets/pictures/genealogy.jpg", "assets/pictures/creative.jpg", "assets/pictures/festivals.jpg", "assets/pictures/artist-talk.jpg", "assets/pictures/cinema.jpg", "assets/pictures/filler.jpg" ];
final List<String> description = ["Погружение в историю города, увлекательные рассказы", "Практическое знакомство с ремёслами и техниками прошлых эпох под руководством мастеров", "Театральные постановки, оживляющие исторические события и личности", "Просмотр уникальных артефактов и арт-инсталляций, раскрывающих историю Екатеринбурга", "Увлекательные активности для детей и взрослых, позволяющие изучить историю", "Музыкальные выступления, отражающие дух времени и культурное наследие", "Исследование семейной истории и родословных", "Освещение ключевых тем истории города", "Общение с художниками, писателями и творческими личностями", "События, посвященные определенным историческим периодам или темам", "Дискуссии с художниками и культурными деятелями", "Показ фильмов, документальных лент и художественных работ о городе и его истории", "Вы можете выбрать любимые категории мероприятий, чтобы узнавать о них чаще"];
 late List<Triple> buttonColors;
 int counter = 0;
 int imageIndex = 12;

 @override
 void initState() {
   super.initState();
   buttonColors = List.generate(12, (index) => Triple(containerColor, textColor, 20, 0));
 }

  Widget build(BuildContext context) {
    var buttons = List.generate(12, (index) => Padding(padding: EdgeInsets.all(4),
      child: Container(
        height: 40,
        child: TextButton.icon(
          icon: Icon(Icons.add,
          color: textColor,
            size: buttonColors[index].c.toDouble(),
            ),
          style: TextButton.styleFrom(
            backgroundColor: buttonColors[index].a,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            side: BorderSide(color: outlineColor, width: 1),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
            onPressed: (){ setState(() {
              if (buttonColors[index].d == 0){
                buttonColors[index].a = textColor;
                buttonColors[index].b = lightTextColor;
                buttonColors[index].c = 0;
                buttonColors[index].d = 1;
                counter++;
                imageIndex = index;
              } else {
              buttonColors[index].a = containerColor;
              buttonColors[index].b = textColor;
              buttonColors[index].c = 20;
              buttonColors[index].d = 0;
              counter--;
              imageIndex = 12;
              }
            });
              },
            label: Text(text[index],
              style: TextStyle(color: buttonColors[index].b)
            )
        ),
        )
      ,)
    );
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          SizedBox(height: 35,),
          Container(
            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            width: 350,
            height: 150,


            child: Row(children: [
            Container(
              height: 150,
              width: 120,
            decoration: BoxDecoration(
              borderRadius:  BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
              image:DecorationImage(image:  AssetImage(images[imageIndex]),
                fit: BoxFit.cover
            )
            )
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 150,
              width: 224,
                decoration: BoxDecoration(
                    borderRadius:  BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
                  color: containerColor,
                ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(text[imageIndex],
                style: TextStyle(fontSize: 16,
                fontWeight: FontWeight.w700),),
                SizedBox(height: 12,),
                Text(description[imageIndex],
                style: TextStyle(fontSize: 13,
                    fontWeight: FontWeight.w600),)
              ],),
            )
          ],),

        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          width: 350,
          height: 420,
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Column( mainAxisAlignment: MainAxisAlignment.center,
            children: [ Row(children: [buttons[0], buttons[1]], mainAxisAlignment: MainAxisAlignment.center,), Row(children: [buttons[2], buttons[3]],mainAxisAlignment: MainAxisAlignment.center), buttons[4], Row(children: [buttons[5], buttons[6]],mainAxisAlignment: MainAxisAlignment.center), buttons[7], buttons[8], Row(children: [buttons[9], buttons[10]],mainAxisAlignment: MainAxisAlignment.center), buttons[11]],), ) ],),
      bottomNavigationBar: Container(
        height: 50,
        width: 350,
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
        child:
      TextButton(onPressed: () async
      {
        await _sendRequest();
        Navigator.push(context, MaterialPageRoute(builder: (context) => CustomBottomNavigationBar()));},
      style: TextButton.styleFrom(backgroundColor: counter == 0?disableButton:enableButton,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        child: Text(counter == 0?"Позже" :"Сохранить выбор", style: TextStyle(color: Colors.white),),

      ),),
    );
  }
}
