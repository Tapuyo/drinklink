import 'package:driklink/data/pref_manager.dart';
import 'package:driklink/pages/Api.dart';
import 'package:driklink/pages/home/home.dart';
import 'package:driklink/pages/home/savecard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:driklink/pages/home/menupage.dart';
import 'package:uuid/uuid.dart';

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
  bool isActive = true;

  List<CardDetails> myCardList = [];
  Future myCardFuture;

  int tipid = 0;
  String idCard = '0';
  String discountID = '';
  String discountPerc = '';
  int lengtofsub = 0;
  String iconid = '';
  bool saveCard = false;
  var uuid = Uuid();
  String token = '';

  String maskedPan = '';
  String expiry = '';
  String cardholderName = '';
  String scheme = '';
  String cardToken = '';
  String cardnamex = '';
  String cardidx = '';
  Color contColor = Colors.green;

  @override
  void initState() {
    super.initState();
    getDetails();
    myCardList = [];
    myCardFuture = getCard();
  }

  deleteusercardsingle(String cardtoken) async {
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

    String su = Prefs.getString('token');
    String un = Prefs.getString('uname') ?? '';
    print('Dele Card');
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + su,
      'Content-Type': 'application/json'
    };

    String url = ApiCon.baseurl() +
        '/users/currentUser/deletecard?cardtoken=' +
        cardtoken;

    // final request = http.Request('DELETE', Uri.parse(url));
    // request.headers.addAll(headers);
    // request.body = cardtoken;

    // final response = await request.send();

    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      print(response.statusCode);
      _showDialog_deletecard_single('My Card', 'Successfully deleted.');
    } else {
      _showDialog_deletecard_single('My Card', 'Failed to delete card.');
    }
    myCardFuture = getCard();
    Navigator.pop(context);
    // print(response.body);
    // print(response.statusCode);
    // if (response.statusCode == 200) {
    //   print(response.statusCode);
    //   getCard();
    // }
  }

  deleteuser() async {
    String su = Prefs.getString('token');
    String un = Prefs.getString('uname') ?? '';
    print('Dele Card');
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + su,
      'Content-Type': 'application/json'
    };

    String url = ApiCon.baseurl() + '/users/currentUser/savedcards';

    final response = await http.delete(url, headers: headers);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.statusCode);
      getCard();
    }
  }

  Future<List<CardDetails>> getCard() async {
    setState(() {
      myCardList = [];
    });
    String mytoken = Prefs.getString('token');
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ' + mytoken
    };
    try {
      final response = await http.get(
          ApiCon.baseurl() + '/users/currentUser/savedCards',
          headers: headers);
      var jsondata = json.decode(response.body);
      print(response.body);

      for (var u in jsondata) {
        var mask = u['maskedPan'];
        var fullname = mask.split('******');
        String latmask = "******" + fullname[1].trim().toString();

        CardDetails tmc = new CardDetails(
            u['id'].toString(),
            u['maskedPan'],
            u['expiry'],
            u['cardholderName'],
            u['scheme'],
            u['cardToken'],
            false,
            latmask);

        setState(() {
          myCardList.add(tmc);
        });
      }
    } catch (e) {}
    return myCardList;
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
      cardidx = Prefs.getString('bcardid' + uName) ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2b2b61),
      appBar: new AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFF2b2b61),
        title: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              child: IconButton(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                "SETTINGS",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(10, 10, 0, 20),
              child: Text(
                "Customize DrinkLink",
                style: TextStyle(fontSize: 12, color: Colors.deepOrange),
              ),
            ),
          ],
        ),
        shape: Border(bottom: BorderSide(color: Colors.deepOrange, width: 2)),
        elevation: 4,
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
              showCardDetails(),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (isActive) {
                    _showDialog('ADD CREDIT CARD',
                        "1 AED will be authorized and then released in order to validate your credit card. Do you want to continue?");
                    setState(() {
                      isActive = false;
                    });
                  }
                  print(isActive);
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
                'Default Message Sound for each order status change',
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
                    cardnamex = cardnamex;
                    cardidx = cardidx;
                    print(cardnamex);
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
                            if (checkedValue) {
                              if (cardidx.isEmpty) {
                                _messageDialog('Select Card',
                                    'Please choose your default card.');
                                return;
                              }
                            }
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
    uName = Prefs.getString('uname') ?? '';
    String bname = billname.text.trimLeft();
    String blast = billlast.text.trimLeft();
    String badd = billadd.text;
    String bemail = billemail.text.trim();
    bool bsendBill = checkedValue;
    Prefs.setString('bfName' + uName, bname);
    Prefs.setString('blMame' + uName, blast);
    Prefs.setString('billName' + uName, bname + " " + blast);
    Prefs.setString('billAdd' + uName, badd);
    Prefs.setString('billEmail' + uName, bemail);
    Prefs.setBool('bsendBill' + uName + '', bsendBill);
    Prefs.setString('bcardname' + uName, cardnamex);
    Prefs.setString('bcardid' + uName, cardidx);

    setState(() {
      Prefs.setBool('sound' + uName, sound);
      Prefs.setBool('alert' + uName, ring);
    });

    FirebaseMessaging.instance.requestPermission(
      alert: ring,
      sound: sound,
    );
  }

  _showDialog_deletecard_single(String title, String message) {
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
            // FlatButton(
            //   child: Text(
            //     'Cancel',
            //     style: TextStyle(color: Colors.white, fontSize: 18),
            //   ),
            //   onPressed: () {
            //     Navigator.of(context, rootNavigator: true).pop();
            //   },
            // ),
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

  _showDialog_Deletecard(String title, String message, String Token) {
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
                'Cancel',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                deleteusercardsingle(Token);
                // myCardFuture = getCard();
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        ),
      ),
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
                myCardFuture = getCard();
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  _messageDialog(String title, String message) {
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
                myCardFuture = getCard();
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  _showDialog(String title, String message) async {
    Navigator.of(context).push(new PageRouteBuilder(
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
        }));

    Prefs.load();
    String token = Prefs.getString('token');
    print(token);
    String linkpayment = '';
    String reference = '';
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + token
      };
      String url = ApiCon.baseurl() + '/users/currentUser/savedCards';
      final response = await http.post(url, headers: headers);
      print(json.decode(response.body));
      await Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
      if (response.statusCode == 200) {
        linkpayment = json.decode(response.body)['paymentLink'];
        reference = json.decode(response.body)['orderReference'];
        confirmDialog(title, message, linkpayment, reference);
      }
      setState(() {
        isActive = true;
        print(isActive);
      });
    } catch (e) {
      setState(() {
        isActive = true;
        print(isActive);
      });
      _showDialog1('DrinkLink', 'Please login first.');
    }
  }

  confirmDialog(
      String title, String message, String linkpayment, String reference) {
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
                      builder: (context) =>
                          SaveCardWeb(linkpayment.toString(), reference)),
                );

                if (result == 'Added') {
                  _showDialog1('DrinkLink', 'New card saved.');
                  myCardFuture = getCard();
                } else {
                  print(result);
                  _showDialog1('DrinkLink', 'Failed to save card.');
                  myCardFuture = getCard();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  showCardDetails() {
    if (myCardList.length <= 0) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Container(
        height: 60 * myCardList.length.toDouble(),
        child: FutureBuilder(
            future: myCardFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                // try {
                //   cardnamex = snapshot.data[0].cardholderName;
                //   cardidx = snapshot.data[0].cardid;
                // } catch (e) {
                //   cardnamex = '';
                //   cardidx = '';
                // }

                return ListView.builder(
                    itemCount: snapshot.data.length,
                    // physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                            padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                            color: Colors.transparent,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Container(
                                //   width: 200,
                                //   child: Column(
                                //     mainAxisAlignment: MainAxisAlignment.start,
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       CheckboxListTile(
                                //         title: Text(
                                //           snapshot.data[index].scheme,
                                //           style: TextStyle(color: Colors.white),
                                //         ),
                                //         value:
                                //             idCard == snapshot.data[index].cardid
                                //                 ? true
                                //                 : false,
                                //         onChanged: (newValue) {
                                //           setState(() {
                                //             if (idCard ==
                                //                 snapshot.data[index].cardid) {
                                //               idCard = '';
                                //               maskedPan = '';
                                //               expiry = '';
                                //               cardholderName = '';
                                //               scheme = '';
                                //               cardToken = '';
                                //             } else {
                                //               idCard =
                                //                   snapshot.data[index].cardid;
                                //               maskedPan =
                                //                   snapshot.data[index].maskedPan;
                                //               expiry =
                                //                   snapshot.data[index].expiry;
                                //               cardholderName = snapshot
                                //                   .data[index].cardholderName;
                                //               scheme =
                                //                   snapshot.data[index].scheme;
                                //               cardToken =
                                //                   snapshot.data[index].cardToken;
                                //             }
                                //           });
                                //         },
                                //         secondary: Icon(Icons.account_box,
                                //             color: Colors.white),
                                //         // controlAffinity: ListTileControlAffinity
                                //         //     .leading, //  <-- leading Checkbox
                                //       ),

                                //     ],
                                //   ),
                                // ),
                                Container(
                                  child: Text(
                                    snapshot.data[index].scheme,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),

                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data[index].cardholderName,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      Text(
                                        snapshot.data[index].showmask +
                                            "  " +
                                            snapshot.data[index].expiry,
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      cardnamex =
                                          snapshot.data[index].cardholderName;
                                      cardidx = snapshot.data[index].cardid;
                                      myCardList = [];
                                      myCardFuture = getCard();
                                    });
                                  },
                                ),

                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(80, 0, 0, 0),
                                    child: Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    cardnamex =
                                        snapshot.data[index].cardholderName;
                                    cardidx = snapshot.data[index].cardid;
                                    _showDialog_Deletecard(
                                        'Delete card',
                                        'Are you sure you want to delete this card?',
                                        snapshot.data[index].cardToken);
                                  }, //Delete card
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                if (checkedValue == true)
                                  Visibility(
                                    visible:
                                        cardidx == snapshot.data[index].cardid
                                            ? true
                                            : false,
                                    child: GestureDetector(
                                      child: Container(
                                        // padding: EdgeInsets.fromLTRB(80, 0, 0, 0),
                                        child: Icon(
                                          Icons.check_circle,
                                          color: Colors.deepOrange,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          cardnamex = snapshot
                                              .data[index].cardholderName;
                                          cardidx = snapshot.data[index].cardid;
                                          myCardList = [];
                                          myCardFuture = getCard();
                                        });
                                        // _showDialog_Deletecard(
                                        //     'Delete card',
                                        //     'Are you sure you want to delete this card?',
                                        //     snapshot.data[index].cardToken);
                                      }, //Delete card
                                    ),
                                  )

                                // Container(
                                //   padding: EdgeInsets.fromLTRB(63, 0, 0, 0),
                                //   child: FlatButton(
                                //     onPressed: () {},
                                //     child: Icon(
                                //       Icons.close,
                                //       color: Colors.white,
                                //     ),
                                //     height: 48,
                                //   ),
                                // )
                              ],
                            )),
                      );
                    });
              }
            }),
      );
    }
  }
}
