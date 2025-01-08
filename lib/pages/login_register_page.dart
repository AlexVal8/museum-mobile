import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:museum/pages/register_page.dart';

import 'login_page.dart';

class LoginRegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      SizedBox(height: 40,),
                      SvgPicture.asset(
                        "assets/icons/logo_vector.svg",
                        width: 295,
                        height: 129,
                        alignment: Alignment.topCenter,
                      ),
                      Spacer(),
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff3fb53b),
                          minimumSize: const Size(343, 49),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegistrationScreen()));
                        },
                        child: const Text(
                          'Регистрация',
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(343, 49),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: const BorderSide(
                              color: Color(0xff3fb53b),
                              width: 2.5
                            )
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                        child: const Text(
                          'Войти',
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Color(0xff3fb53b),
                          ),
                        ),
                      ),
                      const SizedBox(height: 200,)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
