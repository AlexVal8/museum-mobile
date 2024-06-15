import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'histories.dart';

class Rules extends StatefulWidget {
  const Rules({super.key});

  @override
  State<Rules> createState() => _RulesState();
}

class _RulesState extends State<Rules>{
  Color enableButton = const Color(0xFF156B55);
  Color boxBackground = const Color(0xFFE9EFEB);
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 64,),
          TextButton(onPressed: (){SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
            Navigator.push(context, MaterialPageRoute(builder: (context) => Historie()));},
          child: Text('Социальная история',
            style: TextStyle(
                fontSize: 16,
                color: Colors.white
            ),),
          style: TextButton.styleFrom(
            minimumSize: Size(350, 50),
            backgroundColor: enableButton,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),),
          SizedBox(height: 16,),
          Container(
              width: 350,
              height: 580,
              decoration: BoxDecoration(
                  color: boxBackground.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25)
              ),
              child: Column(children: [
                Text('Правила поведения в музее', style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,

                ),

              ), Text('Заполнительный текстЗаполнительный текстЗаполнительный текстЗаполнительный текстЗаполнительный текстЗаполнительный текстЗаполнительный текстЗаполнительный текстЗаполнительный текст',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  )
                ),]))
      ],))
    );
  }


}