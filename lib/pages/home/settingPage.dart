import 'package:driklink/data/pref_manager.dart';
import 'package:driklink/pages/Api.dart';
import 'package:driklink/pages/home/home.dart';
import 'package:driklink/pages/home/savecard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class setPage extends StatefulWidget {
  @override
  _setPageState createState() => _setPageState();
}

class _setPageState extends State<setPage> {
  bool sound = true;
  bool ring = true;
  bool checkedValue = false;
  String uName = '';
  TextEditingController billname = new TextEditingController();
  TextEditingController billlast = new TextEditingController();
  TextEditingController billadd = new TextEditingController();
  TextEditingController billemail = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  getDetails() {
    setState(() {
      Prefs.load();

      uName = Prefs.getString('uname') ?? '';
      billname.text = Prefs.getString('bfName' + uName) ?? '';
      billlast.text = Prefs.getString('blMame' + uName) ?? '';

      billadd.text = Prefs.getString('billAdd' + uName) ?? '';
      billemail.text = Prefs.getString('billEmail' + uName) ?? '';
      sound = Prefs.getBool('sound' + uName) ?? '';

      ring = Prefs.getBool('alert' + uName) ?? '';

      checkedValue = Prefs.getBool('bsendBill' + uName) ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2b2b61),
      appBar: new AppBar(
        backgroundColor: Color(0xFF2b2b61),
        title: new Text(
          "Settings",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Cards',
                style: TextStyle(fontSize: 20, color: Colors.deepOrange),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  // Alert(
                  //   title: "ADD CREDIT CARD",
                  //   content: Text("1 AED will be authorized and then release in order to validate your credit card. Do you want to continue?"),
                  //   buttons: [
                  //     DialogButton(
                  //       child: Text(
                  //         "NO",
                  //         style: TextStyle(color: Colors.white, fontSize: 20),
                  //       ),
                  //       onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                  //       color: Color(0xFF2b2b61),
                  //     ),
                  //     DialogButton(
                  //       child: Text(
                  //         "YES",
                  //         style: TextStyle(color: Colors.white, fontSize: 20),
                  //       ),
                  //       onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                  //       color: Colors.deepOrange,
                  //     )
                  //   ],
                  // ).show();
                  _showDialog('ADD CREDIT CARD',
                      "1 AED will be authorized and then released in order to validate your credit card. Do you want to continue?");
                },
                child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: Colors.white, // red as border color
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "ADD NEW CARD",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Default Message Sound',
                style: TextStyle(fontSize: 20, color: Colors.deepOrange),
              ),
              Text(
                'Default Message Sound for each Order Status Change',
                style: TextStyle(
                    fontSize: 14, color: Colors.white.withOpacity(.8)),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.black45.withOpacity(.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          sound = true;
                        });
                      },
                      child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: sound == true
                                ? Color(0xFF2b2b61)
                                : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              "ON",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          sound = false;
                        });
                      },
                      child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: sound == false
                                ? Color(0xFF2b2b61)
                                : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              "OFF",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Default Ring for Order Ready',
                style: TextStyle(fontSize: 20, color: Colors.deepOrange),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.black45.withOpacity(.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          ring = true;
                        });
                      },
                      child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: ring == true
                                ? Color(0xFF2b2b61)
                                : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              "ON",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          ring = false;
                        });
                      },
                      child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: ring == false
                                ? Color(0xFF2b2b61)
                                : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              "OFF",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                child: TextField(
                  controller: billemail,
                  style: TextStyle(color: Colors.white),
                  decoration: new InputDecoration(
                    hintText: "Send bill to email",
                    hintStyle: TextStyle(color: Colors.white54),
                    labelStyle: new TextStyle(color: Colors.white),
                    labelText: 'Send bill to email',
                  ),
                ),
              ),
              Container(
                  //padding: EdgeInsets.fromLTRB(0, 10, 15, 5),
                  child: CheckboxListTile(
                checkColor: Colors.white,
                title: Text("Use name on card for billing",
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
              Visibility(
                visible: checkedValue == true ? false : true,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: TextFormField(
                    controller: billname,
                    style: TextStyle(color: Colors.white),
                    decoration: new InputDecoration(
                      hintText: "First name on bill",
                      hintStyle: TextStyle(color: Colors.white54),
                      labelStyle: new TextStyle(color: Colors.white),
                      labelText: 'First name on bill',
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: checkedValue == true ? false : true,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: TextField(
                    onChanged: (val) {
                      print(val);
                    },
                    controller: billlast,
                    style: TextStyle(color: Colors.white),
                    decoration: new InputDecoration(
                      hintText: "Last name on bill",
                      hintStyle: TextStyle(color: Colors.white54),
                      labelStyle: new TextStyle(color: Colors.white),
                      labelText: 'Last name on bill',
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                child: TextField(
                  controller: billadd,
                  style: TextStyle(color: Colors.white),
                  decoration: new InputDecoration(
                    hintText: "Address, City, Country",
                    hintStyle: TextStyle(color: Colors.white54),
                    labelStyle: new TextStyle(color: Colors.white),
                    labelText:
                        'Billing to: Address, City, Country(separated with: ,)',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                          height: 50,
                          minWidth: double.infinity,
                          color: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          onPressed: () async {
                            updateChanges();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
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
                                'APPLY SETTINGS',
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

  updateChanges() async {
    Prefs.load();
    uName = Prefs.getString('uname');
    String bname = billname.text;
    String blast = billlast.text;
    String badd = billadd.text;
    String bemail = billemail.text;
    bool bsendBill = checkedValue;
    Prefs.setString('bfName' + uName, bname);
    Prefs.setString('blMame' + uName, blast);
    Prefs.setString('billName' + uName, bname + " " + blast);
    Prefs.setString('billAdd' + uName, badd);
    Prefs.setString('billEmail' + uName, bemail);
    Prefs.setBool('bsendBill' + uName + '', bsendBill);

    setState(() {
      Prefs.setBool('sound' + uName, sound);
      Prefs.setBool('alert' + uName, ring);
    });

    FirebaseMessaging.instance.requestPermission(
      alert: ring,
      sound: sound,
    );
  }

  _showDialog1(String title, String message) {
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
            FlatButton(
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

  _showDialog(String title, String message) async {
    Prefs.load();
    String token = Prefs.getString('token');
    print(token);
    String linkpayment = '';
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + token
      };
      String url = ApiCon.baseurl() + '/users/currentUser/savedCards';
      final response = await http.post(url, headers: headers);
      print(json.decode(response.body));
      if (response.statusCode == 200) {
        linkpayment = json.decode(response.body)['paymentLink'];
        confirmDialog(title, message, linkpayment);
      }
    } catch (e) {
      _showDialog1('DrinkLink', 'Please login first.');
    }
  }

  confirmDialog(String title, String message, String linkpayment) {
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
            FlatButton(
              child: Text(
                'No',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            FlatButton(
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                // Navigator.of(context, rootNavigator: true).pop();
                // Navigator.of(context).push(
                //     new PageRouteBuilder(
                //         opaque: false,
                //         barrierDismissible:false,
                //         pageBuilder: (BuildContext context, _, __) {
                //           return Center(
                //             child: Container(
                //               padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                //               width: 150,
                //               height: 150,
                //               color: Colors.transparent,
                //               child: Center(
                //                 child: new SizedBox(
                //                   height: 50.0,
                //                   width: 50.0,
                //                   child: new CircularProgressIndicator(
                //                     value: null,
                //                     strokeWidth: 7.0,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           );
                //         }
                //     )
                // );
                // await Future.delayed(const Duration(seconds: 1), (){
                //   Navigator.of(context).pop();
                // });

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SaveCardWeb(linkpayment)),
                );

                if (result != 'failed') {
                  _showDialog1('DinkLink', 'New card save.');
                } else {
                  print(result);
                  _showDialog1('DinkLink', 'Failed to save card.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
