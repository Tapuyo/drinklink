import 'dart:convert';

import 'package:driklink/data/pref_manager.dart';
import 'package:driklink/pages/Api.dart';
import 'package:driklink/pages/home/home.dart';
import 'package:driklink/pages/home/menupage.dart';
import 'package:driklink/pages/login/resetpassword.dart';
import 'package:driklink/pages/login/signin.dart';
import 'package:driklink/pages/login/signup.dart';
import 'package:driklink/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:email_validator/email_validator.dart';

class ResetPassEmail extends StatefulWidget {
  @override
  _ResetPassPageState createState() => _ResetPassPageState();
}

class _ResetPassPageState extends State<ResetPassEmail> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  forgotpassword() async {
    String email = emailController.text.replaceAll(' ', '');
    final bool isValid = EmailValidator.validate(email);
    print(isValid);
    if (isValid == false) {
      _showDialog('Reset Password', 'Enter valid email address.');
      return;
    }
    _sendcode();
  }

  _sendcode() async {
    Navigator.of(context).push(
      new PageRouteBuilder(
        opaque: false,
        barrierDismissible: false,
        pageBuilder: (BuildContext context, _, __) {
          return Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              width: 150,
              height: 150,
              color: Colors.transparent,
              child: Center(
                child: new SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: new CircularProgressIndicator(
                    value: null,
                    strokeWidth: 7.0,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(emailController.text);

    Map<String, String> headers = {"Content-Type": "application/json"};
    String url = ApiCon.baseurl() + '/auth/users/$encoded/resetcode';

    final response = await http.get(Uri.parse(url), headers: headers);
    print(response.body.toString());
    if (response.body.isNotEmpty) {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ResetPass(emailController.text)),
      );
    } else {
      Navigator.pop(context);
      _showDialog('Reset Password', 'Enter valid email address.');
      return;
    }
  }

  _showDialog(String title, String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: new AlertDialog(
          elevation: 15,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          title: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          backgroundColor: Color(0xFF2b2b61),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF2b2b61),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(15, 50, 0, 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignIn()),
                    );
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text(
                    'RESET PASSWORD',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  )),
              Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text(
                    'Enjoy Drinklink Our Old Friend',
                    style: TextStyle(
                        wordSpacing: 5, color: Colors.deepOrange, fontSize: 16),
                  )),
              Divider(
                color: Colors.deepOrange,
                thickness: 2,
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                  child: Text(
                    'Code will be sent to your email.',
                    style: TextStyle(
                        wordSpacing: 3, color: Colors.white, fontSize: 16),
                  )),
              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: TextField(
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  controller: emailController,
                  decoration: new InputDecoration(
                      hintText: "Enter email",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 25),
                      labelStyle:
                          new TextStyle(color: const Color(0xFF424242))),
                ),
              ),
              SizedBox(
                height: 150,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          style: flatButtonStyle,
                          onPressed: () {
                            forgotpassword();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Image.asset(
                              //   'assets/images/applelogo.png',
                              //   height: 30.0,
                              //   width: 30.0,
                              // ),
                              //SizedBox(width: 10,),
                              Text(
                                'SEND CODE',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
