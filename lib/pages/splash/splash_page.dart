import 'dart:async';

import 'package:driklink/data/pref_manager.dart';
import 'package:driklink/pages/home/home.dart';
import 'package:driklink/pages/home/paymentsample.dart';
import 'package:driklink/routes/routes.dart';
import 'package:driklink/utils/constants.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(
        Duration(seconds: 1),
        () => {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              )
            });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bkgdefault.png"),
                  fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'DrinkLink',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  fontFamily: 'Roboto',
                  decoration: TextDecoration.none,
                ),
              ),
              Text(
                'More good times.',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 16,
                  fontFamily: 'NunitoSans',
                  decoration: TextDecoration.none,
                ),
              )
            ],
          )),
    );
  }
}
