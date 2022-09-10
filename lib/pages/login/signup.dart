import 'dart:convert';
import 'package:driklink/pages/Api.dart';
import 'package:driklink/pages/login/signin.dart';
import 'package:http/http.dart' as http;
import 'package:driklink/pages/home/menupage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SignUp extends StatefulWidget {
  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignUp> {
  bool checkedValue = false;
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passController = TextEditingController();
  final passConfirmController = TextEditingController();
  SignUp() async {
    String euser = usernameController.text;
    String em = emailController.text;
    String pss = passController.text;
    String pssc = passConfirmController.text;
    bool v1 = false, v2 = false, v3 = false, v4 = false;

    if (euser.isNotEmpty) {
      v1 = true;
    }
    if (em.isNotEmpty) {
      v2 = true;
    }
    if (pss.isNotEmpty) {
      v3 = true;
    }
    if (pssc.isNotEmpty) {
      v4 = true;
    }

    if (v1 == false && v2 == false && v3 == false && v4 == false) {
      Alert(
        context: context,
        title: "Sign up",
        content: Container(
          child: Center(
            child: Text("Please fill out the registration details"),
          ),
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            color: Color(0xFF2b2b61).withOpacity(.7),
          ),
        ],
      ).show();
      return;
    }
    print('Singup');
    Map<String, String> headers = {"Content-Type": "application/json"};
    Map map = {
      'data': {
        "email": em,
        "passwordConfirmed": pss,
        "password": pssc,
        "userName": euser
      },
    };
    var body = json.encode(map['data']);
    String url = ApiCon.baseurl() + '/auth/users';
    final response = await http.post(url, headers: headers, body: body);
    //var jsondata = json.decode(response.headers);
    print(response.body.toString());
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    } else {
      if (response.body.toString().contains('DuplicateUserName')) {
        Alert(
          context: context,
          title: "Sign up",
          content: Container(
            child: Center(
              child: Text("Username is already taken."),
            ),
          ),
          buttons: [
            DialogButton(
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              color: Color(0xFF2b2b61).withOpacity(.7),
            ),
          ],
        ).show();
      } else if (response.body.toString().contains('DuplicateEmail:')) {
        Alert(
          context: context,
          title: "Sign up",
          content: Container(
            child: Center(
              child: Text("Email is already taken."),
            ),
          ),
          buttons: [
            DialogButton(
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              color: Color(0xFF2b2b61).withOpacity(.7),
            ),
          ],
        ).show();
      } else {
        Alert(
          context: context,
          title: "Sign up",
          content: Container(
            child: Center(
              child: Text(response.body.toString()),
            ),
          ),
          buttons: [
            DialogButton(
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              color: Color(0xFF2b2b61).withOpacity(.7),
            ),
          ],
        ).show();
      }
    }
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
                    'REGISTER',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  )),
              Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text(
                    'Welcome to DrinkLink',
                    style: TextStyle(
                        wordSpacing: 1, color: Colors.deepOrange, fontSize: 16),
                  )),
              Divider(
                color: Colors.deepOrange,
                thickness: 2,
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                  child: Text(
                    'Only registered users can have their card details saved.',
                    style: TextStyle(
                        wordSpacing: 3, color: Colors.white, fontSize: 16),
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: TextField(
                  controller: emailController,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  decoration: new InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 25),
                      labelStyle:
                          new TextStyle(color: const Color(0xFF424242))),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: TextField(
                  controller: usernameController,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  decoration: new InputDecoration(
                      hintText: "Username",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 25),
                      labelStyle:
                          new TextStyle(color: const Color(0xFF424242))),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: TextField(
                  controller: passController,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  obscureText: true,
                  decoration: new InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 25),
                      labelStyle:
                          new TextStyle(color: const Color(0xFF424242))),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: TextField(
                  controller: passConfirmController,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  obscureText: true,
                  decoration: new InputDecoration(
                      hintText: "Confirm Password",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 25),
                      labelStyle:
                          new TextStyle(color: const Color(0xFF424242))),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                  child: Text(
                    'Minimum length 8 characters. At least ONE digit and ONE upper case letter.',
                    style: TextStyle(
                        wordSpacing: 3, color: Colors.white, fontSize: 16),
                  )),
              Container(
                  //padding: EdgeInsets.fromLTRB(0, 10, 15, 5),
                  child: CheckboxListTile(
                checkColor: Colors.white,
                title: Text("I have read and agree to",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                value: checkedValue,
                onChanged: (newValue) {
                  setState(() {
                    checkedValue = newValue;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              )),
              Container(
                  padding: EdgeInsets.fromLTRB(100, 0, 0, 0),
                  child: Text(
                    'Terms of Service',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        decoration: TextDecoration.underline),
                  )),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
                child: Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                          height: 50,
                          minWidth: double.infinity,
                          color: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          onPressed: () {
                            if (checkedValue) {
                              SignUp();
                            } else {
                              Alert(
                                context: context,
                                title: "Sign up",
                                content: Container(
                                  child: Center(
                                    child: Text(
                                        "Please check Terms of Service to proceed"),
                                  ),
                                ),
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "Close",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.of(context,
                                            rootNavigator: true)
                                        .pop(),
                                    color: Color(0xFF2b2b61).withOpacity(.7),
                                  ),
                                ],
                              ).show();
                            }
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
                                'REGISTER',
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
