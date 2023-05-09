import 'package:flutter/material.dart';

class UnderMaintenance extends StatefulWidget {
  const UnderMaintenance();

  @override
  State<UnderMaintenance> createState() => _UnderMaintenanceState();
}

class _UnderMaintenanceState extends State<UnderMaintenance> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bkgdefault.png"),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          child: Stack(children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Center(
                  child: Text(
                'DrinkLink is under maintenance',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
              child: Center(
                  child: Text(
                'We are preparing to serve you.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 110, 10, 0),
              child: Center(
                child: Icon(
                  Icons.construction_rounded,
                  size: 35,
                  color: Colors.deepOrange,
                ),
              ),
            ),
            // Container(
            //   padding: EdgeInsets.fromLTRB(10, 190, 10, 0),
            //   child: Center(
            //       child: Text(
            //     'If you need immediate assistance, feel free to call us at +971 55 618 0677/+971 55 561 7212.',
            //     style: TextStyle(
            //       fontSize: 10,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.white,
            //     ),
            //   )),
            // ),
          ]),
        ),
      ),
    );
  }
}
