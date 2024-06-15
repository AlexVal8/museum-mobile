import 'dart:core';
import 'dart:core';
import 'dart:math';

import 'package:museum/pages/histories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'charts.dart';




class StatWeek extends StatefulWidget {
  const StatWeek({super.key});
  @override
  State<StatWeek> createState() => _StatWeekState();
}


const Color graphGreenColor = const Color(0xFF156B55);
const Color graphRedColor = const Color(0xFFBD4C4C);



class Tuple<T1, T2> {
  T1 a;
  T2 b;

  Tuple(this.a, this.b);
}

class _StatWeekState extends State<StatWeek> {
  Color disableBox = const Color(0xFFD9D9D9);
  Color graphBox = const Color(0xFFE9EFEB);
  Color disableText = const Color(0xFF7A7A7A);

  List<String> topMenuTexts = ['День', "Неделя", "Месяц", "Период"];
  late var topMenuData;





  @override
  void initState() {
    super.initState();
    topMenuData = List.generate(4, (index) => Tuple(disableBox, disableText));
  }


  Widget build(BuildContext context) {

    var topMenu = List.generate(4, (index) =>  TextButton(
      onPressed: (){
        setState(() {
          for(var i = 0; i < 4; i++){
            topMenuData[i].a = disableBox;
            topMenuData[i].b = disableText;
          }
          topMenuData[index].a = Colors.white;
          topMenuData[index].b = Colors.black;

        });
      },
      child: Text(topMenuTexts[index], style: TextStyle(color: topMenuData[index].b),),
      style: TextButton.styleFrom(backgroundColor: topMenuData[index].a,
          fixedSize: Size(88, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), ), );
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(65),
          child: Column(children: [SizedBox(height: 58,),
          Container(
        width: 352,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: disableBox,
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            topMenu[0],
            topMenu[1],
            topMenu[2],
            topMenu[3],

      ],),)],)
    ),
    body: Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Container(
          alignment: Alignment.center,
          height: 50,
          width: 172,
          decoration: BoxDecoration(color: disableBox, borderRadius: BorderRadius.circular(10)),
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text('Выберите период'),
          Text('11.05.2024 - 17.05.2024')
        ],
        ),
        ),
    SizedBox(width: 9,),
    Container(
      alignment: Alignment.center,
      height: 50 ,
      width: 166,
      decoration: BoxDecoration(color: disableBox, borderRadius: BorderRadius.circular(10)),
    child: Text('Выбрать Мероприятие'),)
      ],),
      SizedBox(height: 10 ,),
      Container(child: LineChart(lineChartData) ,
      color: graphBox,
      height: 165, width: 350,),
      SizedBox(height: 10,),
      Container(child: BarChart(barChartData),
      color: graphBox,
      height: 165,
      width: 350,) ,
      SizedBox(height: 10,),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: graphBox,
          height: 185,
        width: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text('Статистика', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
        Text('Оплата по Пушкинской карте = 25\nОплата наличкой = 17\nОплата картой = 57\nБесплатно пенсионерам = 3\nПосетило = 280\nЗабронированно = 43\nВсего посетителей = 99', style: TextStyle(fontWeight: FontWeight.w500),)
      ],),
      )



    ],),
    );
  }
}