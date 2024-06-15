import 'package:museum/pages/statWeek.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<Tuple> barStatLine = [
  Tuple(80.0, 32.0),
  Tuple(50.0, 20.0),
  Tuple(47.0, 30.0),
  Tuple(25.0, 32.0),
  Tuple(45.0, 38.0),
  Tuple(80.0, 12.0),
  Tuple(77.0, 33.0),
];

List<Tuple> weekStatLine =
[Tuple(1, 112.0),
  Tuple(2, 70.0),
  Tuple(3, 77.0),
  Tuple(4, 57.0),
  Tuple(5, 83.0),
  Tuple(6, 92.0),
  Tuple(7, 110.0)
];

double findBarMax(List<Tuple> list){
  double result = 0;
  for(var i = 0; i< list.length; i++){
    var sum = list[i].a + list[i].b;
    if(sum > result) result = sum;
  }
  return result;
}

List<BarChartRodData> generateGroupBar(List<Tuple> list){
  List<BarChartRodData> result = [];
  for(var i = 0; i < list.length; i++){
    var sum = list[i].a + list[i].b;

    result.add(BarChartRodData(toY: sum,
        width: 31,
        rodStackItems: [BarChartRodStackItem(0, list[i].a, graphGreenColor),
          BarChartRodStackItem(list[i].a, sum, graphRedColor)]));
  };
  return result;
}


LineChartData get lineChartData => LineChartData(
    lineTouchData: lineTouchData,
    gridData: gridLineData,
    titlesData: titlesLineData,
    borderData: borderData,
    lineBarsData: lineBarsData,
    minX: 0.5,
    maxX: 7.5

);

LineTouchData get lineTouchData => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) => Colors.white.withOpacity(0.8)

    )
);

FlTitlesData get titlesLineData => FlTitlesData(
  bottomTitles: AxisTitles(
    sideTitles: bottomLineTitles,
  ),
  rightTitles: AxisTitles(
    sideTitles: rightLineTitles(),
  ),
  topTitles: const AxisTitles(
    sideTitles: SideTitles(showTitles: false),
  ),
  leftTitles: const AxisTitles(
    sideTitles: SideTitles(showTitles: false),
  ),
);

List<LineChartBarData> get lineBarsData => [
  lineChartBarData

];

Widget rightTitleLineWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  String text = value.toString();
  value%10 ==0?
  text = value.round().toString():
  text = '';
  return Text(text, style: style, textAlign: TextAlign.center);
}

SideTitles rightLineTitles() => const SideTitles(
  getTitlesWidget: rightTitleLineWidgets,
  showTitles: true,
  interval: 10,
  reservedSize: 30,
);


Widget bottomLineTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  Widget text;
  switch (value) {
    case 1:
      text = const Text('Пн', style: style);
      break;
    case 2:
      text = const Text('Вт', style: style);
      break;
    case 3:
      text = const Text('Ср', style: style);
      break;
    case 4:
      text = const Text('Чт', style: style);
      break;
    case 5:
      text = const Text('Пт', style: style);
      break;
    case 6:
      text = const Text('Сб', style: style);
      break;
    case 7:
      text = const Text('Вс', style: style);
      break;
    default:
      text = const Text('');
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 10,
    child: text,
  );
}

SideTitles get bottomLineTitles => SideTitles(
  showTitles: true,
  reservedSize: 30,
  interval: 1,
  getTitlesWidget: bottomLineTitleWidgets,
);

FlGridData get gridLineData => const FlGridData(
    show: true,
    verticalInterval: 1,
    horizontalInterval: 10

);

BarChartData get barChartData => BarChartData(
    gridData: gridBarData,
    titlesData: titlesBarData,
    borderData: borderData,
    barGroups: [BarChartGroupData(x: 0,
        barsSpace: 17,
        barRods: generateGroupBar(barStatLine)
    )]

);



FlBorderData get borderData => FlBorderData(
  show: false,
);

LineChartBarData get lineChartBarData => LineChartBarData(
  isCurved: true,
  color: graphGreenColor,
  barWidth: 4,
  isStrokeCapRound: true,
  dotData: const FlDotData(show: false),
  belowBarData: BarAreaData(show: false),
  spots: [
    FlSpot(1, weekStatLine[0].b),
    FlSpot(2, weekStatLine[1].b),
    FlSpot(3, weekStatLine[2].b),
    FlSpot(4, weekStatLine[3].b),
    FlSpot(5, weekStatLine[4].b),
    FlSpot(6, weekStatLine[5].b),
    FlSpot(7, weekStatLine[6].b),
  ],
);

FlTitlesData get titlesBarData => FlTitlesData(
  bottomTitles: AxisTitles(
    sideTitles: SideTitles(showTitles: false),
  ),
  rightTitles: AxisTitles(
    sideTitles: rightBarTitles(),
  ),
  topTitles: const AxisTitles(
    sideTitles: SideTitles(showTitles: false),
  ),
  leftTitles: const AxisTitles(
    sideTitles: SideTitles(showTitles: false),
  ),
);

Widget rightTitleBarWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  String text =value.toInt().toString();

  return Text(text, style: style, textAlign: TextAlign.center);
}

SideTitles rightBarTitles() => SideTitles(
  getTitlesWidget: rightTitleBarWidgets,
  showTitles: true,
  interval: findBarMax(barStatLine)/2,
  reservedSize: 30,
);

FlGridData get gridBarData => const FlGridData(
  show: true,
  verticalInterval: 1,

);