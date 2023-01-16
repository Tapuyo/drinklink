import 'dart:convert';

import 'package:driklink/data/pref_manager.dart';
import 'package:driklink/pages/Api.dart';
import 'package:driklink/pages/home/home.dart';
import 'package:driklink/pages/home/menupage.dart';
import 'package:driklink/pages/login/resetpassemail.dart';
import 'package:driklink/pages/login/signin.dart';
import 'package:driklink/pages/login/signup.dart';
import 'package:driklink/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class ResetPass extends StatefulWidget {
  String email;
  ResetPass(this.email);
  @override
  _ResetPassPageState createState() => _ResetPassPageState(this.email);
}

class _ResetPassPageState extends State<ResetPass> {
  String email;
  _ResetPassPageState(this.email);
  final codeController = TextEditingController();
  final passController = TextEditingController();
  final confirmpassController = TextEditingController();
  bool resendActive = true;
  bool reserPass = true;

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

  ResetPassword() async {
    String em = codeController.text;
    String pss = passController.text;
    String cpss = confirmpassController.text;
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(email);

    if (em.isEmpty) {
      _showDialog('Reset Password', 'Please input correct code.');
      return;
    }
    if (pss.isEmpty) {
      _showDialog('Reset Password', 'Please input password.');
      return;
    }
    if (cpss.isEmpty) {
      _showDialog('Reset Password', 'Please input confirm password.');
      return;
    }

    if (pss == cpss) {
      print('login');
      Map<String, String> headers = {"Content-Type": "application/json"};
      Map map = {
        'data': {
          "resetToken": em,
          "password": pss,
          "passwordConfirmed": cpss,
        },
      };
      var body = json.encode(map['data']);
      String url = ApiCon.baseurl() + '/auth/users/$encoded/resetpassword';
      print(url);
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        );
        setState(() {
          reserPass = true;
        });
        print('200');
      } else {
        if (response.body.contains('Invalid password reset code')) {
          _showDialog('Reset Password', 'Please input correct code.');
          return;
        } else if (response.body.contains('Could not reset password')) {
          Alert(
            context: context,
            title: "Reset Password",
            content: Container(
              child: Center(
                child: Text("Password does not meet requirements."),
              ),
            ),
            buttons: [
              DialogButton(
                child: Text(
                  "Close",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                color: Color(0xFF2b2b61).withOpacity(.7),
              ),
            ],
          ).show();
          return;
        } else if (response.body.contains('Password mismatched')) {
          Alert(
            context: context,
            title: "Reset Password",
            content: Container(
              child: Center(
                child: Text("Password don't match."),
              ),
            ),
            buttons: [
              DialogButton(
                child: Text(
                  "Close",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                color: Color(0xFF2b2b61).withOpacity(.7),
              ),
            ],
          ).show();
          return;
        } else {
          Alert(
            context: context,
            title: "Reset Password",
            content: Container(
              child: Center(
                child: Text("Please check inputs."),
              ),
            ),
            buttons: [
              DialogButton(
                child: Text(
                  "Close",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                color: Color(0xFF2b2b61).withOpacity(.7),
              ),
            ],
          ).show();
        }

        print('error');
      }
    } else {
      Alert(
        context: context,
        title: "Reset password",
        content: Container(
          child: Center(
            child: Text('Password mismatched'),
          ),
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(setState(() {
              reserPass = true;
            })),
            color: Color(0xFF2b2b61).withOpacity(.7),
          ),
        ],
      ).show();
    }
  }

  forgotpassword(String email) async {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(email);

    Map<String, String> headers = {"Content-Type": "application/json"};
    String url = ApiCon.baseurl() + '/auth/users/$encoded/resetcode';

    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Alert(
        context: context,
        title: "Resend code",
        content: Container(
          child: Center(
            child: Text('Code has been sent to your email.'),
          ),
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(setState(() {
              resendActive = true;
            })),
            color: Color(0xFF2b2b61).withOpacity(.7),
          ),
        ],
      ).show();
    } else {
      Alert(
        context: context,
        title: "Reset Password",
        content: Container(
          child: Center(
            child: Text('Something went wrong.'),
          ),
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(setState(() {
              resendActive = true;
            })),
            color: Color(0xFF2b2b61).withOpacity(.7),
          ),
        ],
      ).show();
    }

    print(response.body.toString());
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
                      MaterialPageRoute(builder: (context) => ResetPassEmail()),
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
                    'Code has been sent to your email.',
                    style: TextStyle(
                        wordSpacing: 3, color: Colors.white, fontSize: 16),
                  )),
              Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                  child: GestureDetector(
                      onTap: () {
                        if (resendActive) {
                          forgotpassword(this.email);
                          setState(() {
                            resendActive = false;
                          });
                        }
                      },
                      child: Text(
                        'Resend code.',
                        style: TextStyle(
                            wordSpacing: 3,
                            color: Colors.deepOrange,
                            fontSize: 16),
                      ))),
              SizedBox(
                height: 150,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: TextField(
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  controller: codeController,
                  decoration: new InputDecoration(
                      hintText: "Reset Code",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 25),
                      labelStyle:
                          new TextStyle(color: const Color(0xFF424242))),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: TextField(
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  obscureText: true,
                  controller: passController,
                  decoration: new InputDecoration(
                      hintText: "New Password",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 25),
                      labelStyle:
                          new TextStyle(color: const Color(0xFF424242))),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: TextField(
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  obscureText: true,
                  controller: confirmpassController,
                  decoration: new InputDecoration(
                      hintText: "Confirm Password",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 25),
                      labelStyle:
                          new TextStyle(color: const Color(0xFF424242))),
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
                  child: Text(
                    'Minimum length 8 characters. At least ONE digit and ONE upper case letter.',
                    style: TextStyle(
                        wordSpacing: 3, color: Colors.white, fontSize: 16),
                  )),
              SizedBox(
                height: 90,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          style: flatButtonStyle,
                          onPressed: () {
                            ResetPassword();
                            // if (reserPass) {
                            //   ResetPassword();
                            //   setState(() {
                            //     reserPass = false;
                            //   });
                            // }
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
                                'RESET PASSWORD',
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
