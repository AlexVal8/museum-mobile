import 'package:museum/pages/statWeek.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Historie extends StatefulWidget {
  const Historie({super.key});

  @override
  State<Historie> createState() => _HistorieState();
}

class _HistorieState extends State<Historie>{
  Color enableButton = const Color(0xFF156B55);
  Color boxBackground = const Color(0xFF666666);


  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/historieBG/museumBG.jfif"),
            fit: BoxFit.fitHeight
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 220,
              width: 350,
              padding: EdgeInsets.symmetric(vertical: 25),
              decoration: BoxDecoration(
                color: boxBackground.withOpacity(0.5),
                borderRadius: BorderRadius.circular(25)
              ),
              child: Column(children: [

                Text('Социальная история',
                style: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.white,
                  height: 24/20
                ),),

                SizedBox(height: 12,),

                Container(
                  alignment: Alignment.centerLeft,
                    width: 310,
                    child:
                Text("Это текст заполнитель, на этом месте будет текст социальной истории и фото на фоне",

                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat-Regular',
                  fontSize: 16,
                  height: 19.5/16,
                  color: Colors.white
                ),))
              ],),
            ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
              child:
          TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => StatWeek()));},
              child: Text('Продолжить',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white
                ),),
          style: TextButton.styleFrom(
            minimumSize: Size(350, 50),
              backgroundColor: enableButton,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),))
          ],
        ),
      ),
    );
  }
}