import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'histories.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'histories.dart';

class Rules extends StatefulWidget {
  const Rules({Key? key}) : super(key: key);

  @override
  State<Rules> createState() => _RulesState();
}

class _RulesState extends State<Rules> {
  Color enableButton = const Color(0xFF156B55);
  Color boxBackground = const Color(0xFFE9EFEB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 64,),
              TextButton(
                onPressed: () {
                  SystemChrome.setEnabledSystemUIMode(
                    SystemUiMode.manual,
                    overlays: [SystemUiOverlay.top],
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Historie()),
                  );
                },
                child: Text(
                  'Социальная история',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                style: TextButton.styleFrom(
                  minimumSize: Size(350, 50),
                  backgroundColor: enableButton,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 16,),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: 350,
                    decoration: BoxDecoration(
                      color: boxBackground.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Правила поведения в музее',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8,),
                          Text(
                            '''Мы рады приветствовать вас и хотим, чтобы ваше пребывание у нас было приятным и безопасным. Пожалуйста, ознакомьтесь с правилами посещения музея:

Соблюдайте тишину: Уважайте других посетителей и экспонаты, избегайте громких разговоров и шумов.

Не прикасайтесь к экспонатам: Экспонаты представляют собой ценности, требующие бережного отношения. Не касайтесь их руками, если это не разрешено специально.

Фотосъемка: Фотографировать можно только без вспышки. Обратите внимание на знаки, запрещающие съемку в определённых залах.

Еда и напитки: Вход с едой и напитками запрещён. Для перекусов воспользуйтесь кафе музея или специально отведёнными зонами.

Большие сумки и рюкзаки: Оставьте крупные сумки и рюкзаки в гардеробе или шкафчиках для хранения.

Мобильные телефоны: Переведите мобильные телефоны в беззвучный режим. Разговоры по телефону допускаются только в специально отведённых местах.

Дети: Дети должны находиться под присмотром взрослых. Пожалуйста, не оставляйте их без присмотра.

Экскурсии и группы: Если вы посетили музей в составе группы, следуйте указаниям вашего экскурсовода и не отставайте от группы.

Дорожки и проходы: Пожалуйста, не загромождайте проходы и дорожки, чтобы другие посетители могли свободно передвигаться.

Эвакуационные выходы: Обратите внимание на расположение эвакуационных выходов и планы эвакуации. В случае чрезвычайной ситуации следуйте указаниям персонала музея.

Спасибо за понимание и сотрудничество. Желаем вам увлекательного и познавательного посещения!
''',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 50,)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
