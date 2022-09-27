import 'dart:async';
import 'dart:convert';
import 'package:driklink/pages/home/ordermoredetailed.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:driklink/data/pref_manager.dart';
import 'package:driklink/pages/Api.dart';
import 'package:driklink/pages/home/home.dart';
import 'package:driklink/pages/home/menupage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../auth_provider.dart';
import 'dart:ffi';
import 'dart:math';

import 'package:driklink/pages/home/home.dart';
import 'package:driklink/pages/home/orderPage.dart';
import 'package:driklink/pages/home/orderdetails.dart';
import 'package:driklink/pages/home/settingPage.dart';
import 'package:driklink/pages/home/termPage.dart';
import 'package:driklink/pages/home/webpage.dart';
import 'package:driklink/pages/login/signin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanoid/nanoid.dart';

//import 'package:nanoid/non_secure.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:driklink/pages/Api.dart';
import 'package:driklink/data/pref_manager.dart';
import 'package:uuid/uuid.dart';
import 'package:driklink/provider/payment_provider.dart';
import 'package:collection/equality.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:driklink/auth_provider.dart';
import 'package:provider/provider.dart';

import 'dart:core';
import 'package:email_validator/email_validator.dart';
class OrderDetails extends StatefulWidget {
  String id;
  OrderDetails(this.id);
  @override
  _OrderDetailsState createState() => _OrderDetailsState(this.id);
}

class _OrderDetailsState extends State<OrderDetails> {
  String id;
  _OrderDetailsState(this.id);
  List<Order> orderList = [];
  Future ord;
  String outletid = '';
  String outletName = '';
  String outletDesciption = '';
  String outletTime = '';
  String outletOnline = '';
  int timeToCollect = 0;
  String mins = '00';
  String secs = '00';
  String hours = '';

  String barid = '';
  String state = '';
  String sttn = '';
  String outlet = '';
  String itemcount = '';
  String price = '';
  String code = '';
  String byw = '';

  int dtofdy = 0;
  String wk = '';
  bool isWorkingDay = false;
  Timer _timer;
  int _start = 10;
int tipid = 0;
  String idCard = '0';
  String discountID = '';
  String discountPerc = '';
  int lengtofsub = 0;
  String iconid = '';
  bool saveCard = false;
  var uuid = Uuid();
  String token = '';
  String uName = '';

  String stoken;
  int orderlenght = 0;
  String choosetb = "Choose Table";
  double fee = 0;
  List jorder = [];
  String selectedmenu = '';
  String selectedmenu1 = '';
  int subbodybool = 0;

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future subMenu;
  Future myStore;
  Future myTempCart;
  Future myCartFuture;
  Future myCardFuture;
  List<CardDetails> myCardList = [];
  List<TempOrder> temporder = [];
  List<SubMenu> myMenu = [];
  List<Drinks> myDrinks = [];
  List<Order> myOrder = [];
  List<Discount> mydicount = [];
  PanelController _pc = new PanelController();
  bool _pcb = false;
  int order1 = 0;
  int order2 = 0;
  String ord1 = '00';
  String ord2 = '00';
  bool btnaddcolor = false;
  String ord3 = '00';
  bool pickdine = true;
  bool checkedValue = false;
  String sub = '';
  String dri = '';
  String drisub = '';
  double finaltotwithdiscount = 0;
  double finaltot = 0;
  double vip = 0;
  double timecol = 0;
  bool vipcharge = false;
  String mdicount = '';
  double discountitempercentage = 0;
  String mtip = '0';
  double discount = 0;
  double tip = 0;
  double charge = 0;
  int selectedIndex = 0;
  String cname = '';
  TextEditingController billname = new TextEditingController();
  TextEditingController billadd = new TextEditingController();
  TextEditingController billemail = new TextEditingController();
  bool addICe;

  String maskedPan = '';
  String expiry = '';
  String cardholderName = '';
  String scheme = '';
  String cardToken = '';
  Color contColor = Colors.green;

  bool isloading;
  int totalqty = 0;

  counteraddord1(String addminus) {
    if (addminus == 'add') {
      setState(() {
        order1 = order1 + 1;
        if (order1 < 10) {
          ord1 = '0' + order1.toString();
        } else {
          ord1 = order1.toString();
        }
      });
    } else {
      setState(() {
        order1 = order1 - 1;
        if (order1 < 0) {
          order1 = 0;
          ord1 = '00';
        } else {
          if (order1 < 10) {
            ord1 = '0' + order1.toString();
          } else {
            ord1 = order1.toString();
          }
        }
      });
    }
    if (order1 > 0 || order2 > 0) {
      setState(() {
        btnaddcolor = true;
      });
    } else {
      setState(() {
        btnaddcolor = false;
      });
    }
  }

  counteraddord2(String addminus) {
    if (addminus == 'add') {
      //setState(() {
      order2 = order2 + 1;
      if (order2 < 10) {
        ord2 = '0' + order2.toString();
      } else {
        ord2 = order2.toString();
      }
      //});
    } else {
      //setState(() {
      order2 = order2 - 1;
      if (order2 < 0) {
        order2 = 0;
        ord2 = '00';
      } else {
        if (order2 < 10 || order2 > 0) {
          ord2 = '0' + order2.toString();
        } else {
          ord2 = order1.toString();
        }
      }
      //});
    }
    if (order2 > 0) {
      //setState(() {
      btnaddcolor = true;
      //});
    } else {
      //setState(() {
      btnaddcolor = false;
      //});
    }
  }

  getToke() {
    try {
      Prefs.load();
      token = Prefs.getString('token');
      uName = Prefs.getString('uname');
    } catch (e) {
      token = '';
    }
  }

  loadBill() async {
    Prefs.load();

    // if (token.isEmpty && userName.isEmpty) {
    //   billname.text = '';
    //   billadd.text = '';
    //   billemail.text = '';
    // } else {
    uName = Prefs.getString('uname');
    billname.text = Prefs.getString('billName' + uName);
    billadd.text = Prefs.getString('billAdd' + uName);
    billemail.text = Prefs.getString('billEmail' + uName);
    // }
  }
  @override
  void initState() {
    super.initState();
    getDayofweek();
    getOrders();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      getOrders();
    });
    //
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      getOrders();
    });

    //
    //
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      getOrders();
    });
  }

  Future<List<Order>> getOrders() async {
    setState(() {
      orderList = [];
    });
    Prefs.load();
    String token = Prefs.getString('token');
    print(token);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ' + token
    };
    final response = await http.get(
        ApiCon.baseurl() + '/users/currentUser/orders?pageSize=1&pageNumber=1',
        headers: headers);
    var jsondata = json.decode(response.body);
    print(response.body);

    for (var i = 0; i < jsondata.length; i++) {
      if (id == '') {
        var jsondata1 = await json.decode(response.body)[i]['items'];

        List<MyItems> newItem = [];
        for (var x in jsondata1) {
          MyItems nt =
              new MyItems(x['drink']['name'], x['quantity'].toString());

          newItem.add(nt);
        }
        String st = json.decode(response.body)[i]['timestamp'].toString();
        String mprice = json.decode(response.body)[i]['finalPrice'].toString();

        String dt = '';
        String stt = '';
        final toDayDate = DateTime.now();
        var different = toDayDate.difference(DateTime.parse(st)).inMinutes;
        if (different < 60) {
          dt = toDayDate.difference(DateTime.parse(st)).inMinutes.toString() +
              ' mins';
        } else if (different > 60 && different < 1440) {
          dt = toDayDate.difference(DateTime.parse(st)).inHours.toString() +
              ' hours';
        } else {
          dt = toDayDate.difference(DateTime.parse(st)).inDays.toString() +
              ' days';
        }
        String bar = json.decode(response.body)[i]['tableId'].toString();
        String cState =
            json.decode(response.body)[i]['currentState'].toString();
        String mcode = json.decode(response.body)[i]['code'].toString();
        String byww = json.decode(response.body)[i]['bartender'].toString();

        getFacilityInfo(json.decode(response.body)[i]['facilityId'].toString());
        getSched(json.decode(response.body)[i]['facilityId'].toString());

        if (cState == '0') {
          stt = 'Order Created';
        } else if (cState == '1') {
          stt = 'Pending';
        } else if (cState == '2') {
          stt = 'Accepted';
        } else if (cState == '3') {
          stt = 'Payment Processed';
        } else if (cState == '4') {
          setState(() {
            String mdate =
                json.decode(response.body)[i]['timeToCollect'].toString();
            DateTime parseDate =
                new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(mdate);
            var inputDate = DateTime.parse(parseDate.toString());
            setState(() {
              int mmint = inputDate.minute * 60;
              int msec = inputDate.second;

              _start = mmint + msec;
            });
            if (_start > 0) {
              startTimer();
            }
          });
          stt = 'Ready';
        } else if (cState == '5') {
          _timer.cancel();
          stt = 'Completed';
        } else if (cState == '101') {
          _timer.cancel();
          stt = 'Failed';
        } else if (cState == '102') {
          stt = 'Canceled';
          _timer.cancel();
        } else if (cState == '103') {
          _timer.cancel();
          stt = 'Rejected';
        } else if (cState == '104') {
          stt = 'Not Collected';
          _timer.cancel();
        } else if (cState == '105') {
          stt = 'Payment Failed';
          _timer.cancel();
        }

        setState(() {
          barid = bar.toString();
          state = stt.toString();
          //state =  json.decode(response.body)[i]['currentState'].toString();
          sttn = cState;
          itemcount = newItem.length.toString();
          price = mprice;
          code = mcode;
          byw = byww;
          //outletDesciption = json.decode(response.body)[i]['currentState'].toString();
        });
      } else {
        if (id == json.decode(response.body)[i]['id'].toString()) {
          var jsondata1 = await json.decode(response.body)[i]['items'];

          List<MyItems> newItem = [];
          for (var x in jsondata1) {
            MyItems nt =
                new MyItems(x['drink']['name'], x['quantity'].toString());

            newItem.add(nt);
          }
          String st = json.decode(response.body)[i]['timestamp'].toString();
          String mprice =
              json.decode(response.body)[i]['finalPrice'].toString();

          String dt = '';
          String stt = '';
          final toDayDate = DateTime.now();
          var different = toDayDate.difference(DateTime.parse(st)).inMinutes;
          if (different < 60) {
            dt = toDayDate.difference(DateTime.parse(st)).inMinutes.toString() +
                ' mins';
          } else if (different > 60 && different < 1440) {
            dt = toDayDate.difference(DateTime.parse(st)).inHours.toString() +
                ' hours';
          } else {
            dt = toDayDate.difference(DateTime.parse(st)).inDays.toString() +
                ' days';
          }
          String bar = json.decode(response.body)[i]['tableId'].toString();
          String cState =
              json.decode(response.body)[i]['currentState'].toString();
          String mcode = json.decode(response.body)[i]['code'].toString();
          String byww = json.decode(response.body)[i]['bartender'].toString();

          getFacilityInfo(
              json.decode(response.body)[i]['facilityId'].toString());
          getSched(json.decode(response.body)[i]['facilityId'].toString());

          if (cState == '0') {
            stt = 'Order Created';
          } else if (cState == '1') {
            stt = 'Pending';
          } else if (cState == '2') {
            stt = 'Accepted';
          } else if (cState == '3') {
            stt = 'Payment Processed';
          } else if (cState == '4') {
            setState(() {
              String mdate =
                  json.decode(response.body)[i]['timeToCollect'].toString();
              DateTime parseDate =
                  new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(mdate);
              var inputDate = DateTime.parse(parseDate.toString());
              setState(() {
                int mmint = inputDate.minute * 60;
                int msec = inputDate.second;

                _start = mmint + msec;
              });
              if (_start > 0) {
                startTimer();
              }
            });
            stt = 'Ready';
          } else if (cState == '5') {
            _timer.cancel();
            stt = 'Completed';
          } else if (cState == '101') {
            _timer.cancel();
            stt = 'Failed';
          } else if (cState == '102') {
            stt = 'Canceled';
            _timer.cancel();
          } else if (cState == '103') {
            _timer.cancel();
            stt = 'Rejected';
          } else if (cState == '104') {
            stt = 'Not Collected';
            _timer.cancel();
          } else if (cState == '105') {
            stt = 'Payment Failed';
            _timer.cancel();
          }

          setState(() {
            barid = bar.toString();
            state = stt.toString();
            //state =  json.decode(response.body)[i]['currentState'].toString();
            sttn = cState;
            itemcount = newItem.length.toString();
            price = mprice;
            code = mcode;
            byw = byww;
            //outletDesciption = json.decode(response.body)[i]['currentState'].toString();
          });
        }
      }
    }
    return orderList;
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start <= 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
            if (_start > 60) {
              double val = _start / 60 - 1;
              mins = val.ceil().toStringAsFixed(0);
              int rem = _start % 60;
              if (rem < 10) {
                secs = '0' + rem.toString();
              } else {
                secs = rem.toString();
              }
            } else {
              hours = '';
              mins = '00';
              if (_start < 10) {
                secs = '0' + _start.toString();
              } else {
                secs = _start.toString();
              }
            }
          });
          //checkORder();
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  getFacilityInfo(String id) async {
    String name = '';
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    String url = ApiCon.baseurl() + '/places/';
    final response = await http.get(url, headers: headers);
    //print(response.body.toString());
    var jsondata = json.decode(response.body);

    for (var u in jsondata) {
      if (u['id'].toString() == id) {
        print(u['name']);
        setState(() {
          outletid = u['id'].toString();
          outletName = u['name'];
          outletDesciption = u['address'];
        });
      }
    }
  }

  getDayofweek() {
    DateTime date = DateTime.now();
    String dateFormat = DateFormat('EEEE').format(date);
    if (dateFormat == 'Monday') {
      dtofdy = 1;
    } else if (dateFormat == 'Tuesday') {
      dtofdy = 2;
    } else if (dateFormat == 'Wednesday') {
      dtofdy = 3;
    } else if (dateFormat == 'Thursday') {
      dtofdy = 4;
    } else if (dateFormat == 'Friday') {
      dtofdy = 5;
    } else if (dateFormat == 'Saturday') {
      dtofdy = 6;
    } else if (dateFormat == 'Sunday') {
      dtofdy = 0;
    } else {
      dtofdy = 0;
    }
  }

  getSched(String id) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    String url = ApiCon.baseurl() + '/places/' + id.toString();
    final response = await http.get(url, headers: headers);
    var jsondata = json.decode(response.body)['workHours'];

    for (var u in jsondata) {
      if (u['dayOfWeek'] == dtofdy) {
        String st = '2020-07-20T' + u['startTime'];
        String et = '2020-07-20T' + u['endTime'];
        String nst = DateFormat.jm().format(DateTime.parse(st));
        String net = DateFormat.jm().format(DateTime.parse(et));
        setState(() {
          wk = "Working hours " + nst + " - " + net;
          isWorkingDay = u['isWorkingDay'];
        });
      }
    }
    //for (var x in jsondata1){
    //   setState(() {
    //     if(state != '4' || state != '5' || state != '101' || state != '102' || state != '103' || state != '104' || state != '105') {
    //       timeToCollect = json.decode(response.body)['timeToCollect'];
    //       mins = json.decode(response.body)['timeToCollect'].toString();
    //       _start = int.parse(mins) * 60;
    //     }
    //   });

    //}
  }

  @override
  Widget build(BuildContext context) {
     String _token = context.read<AuthProvider>().token;
    String token = Prefs.getString('token');
    if (_token.isNotEmpty) {
      stoken = _token;
    } else {
      stoken = token;
    }
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bkgdefault.png"),
              fit: BoxFit.cover)),
      child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              //automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 35,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (subbodybool == 1) {
                    setState(() {
                      subbodybool = 0;
                    });
                  } else if (subbodybool == 2) {
                    setState(() {
                      subbodybool = 1;
                    });
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }
                },
              ),
              // actions: [
              //   IconButton(
              //     icon: Icon(Icons.menu, size: 35, color: Colors.white,),
              //     onPressed: () {
              //       _scaffoldKey.currentState.openEndDrawer();
              //     },
              //   )
              // ],
            ),
            endDrawer: Drawer(
              child: Container(
                  padding: EdgeInsets.fromLTRB(10, 50, 0, 0),
                  color: Colors.black,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (_scaffoldKey.currentState.isEndDrawerOpen) {
                            _scaffoldKey.currentState.openDrawer();
                          } else {
                            _scaffoldKey.currentState.openEndDrawer();
                          }
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.home,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "Home",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (_scaffoldKey.currentState.isEndDrawerOpen) {
                            _scaffoldKey.currentState.openDrawer();
                          } else {
                            _scaffoldKey.currentState.openEndDrawer();
                          }
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => orderPage()),
                          );
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.wine_bar_sharp,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "My Orders",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (_scaffoldKey.currentState.isEndDrawerOpen) {
                            _scaffoldKey.currentState.openDrawer();
                          } else {
                            _scaffoldKey.currentState.openEndDrawer();
                          }
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => setPage()),
                          );
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.settings,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Settings v1.0.122",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (_scaffoldKey.currentState.isEndDrawerOpen) {
                            _scaffoldKey.currentState.openDrawer();
                          } else {
                            _scaffoldKey.currentState.openEndDrawer();
                          }
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => termPage()),
                          );
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                FontAwesome.angle_double_up,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Terms of Service",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (_scaffoldKey.currentState.isEndDrawerOpen) {
                            _scaffoldKey.currentState.openDrawer();
                          } else {
                            _scaffoldKey.currentState.openEndDrawer();
                          }
                          setState(() {
                            setState(() {
                              stoken = '';

                              Prefs.setString('token', '');
                              Prefs.setString('uname', 'none');
                              Prefs.setString('bfNamenone', '');
                              Prefs.setString('blMamenone', '');
                              Prefs.setString('billNamenone', '');
                              Prefs.setString('billAddnone', '');
                              Prefs.setString('billEmailnone', '');
                              context.read<AuthProvider>().setToken('');
                            });
                          });
                          //Navigator.of(context).popAndPushNamed('/home');
                          if (stoken == '' ||
                              stoken == null ||
                              stoken.isEmpty) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => SignIn()),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          }
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                MaterialCommunityIcons.human,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                stoken == '' || stoken == null || stoken.isEmpty
                                    ? "Sign In / Register"
                                    : "Sign Out",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      // Container(
                      //   padding: EdgeInsets.fromLTRB(0, 0, 10, 50),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Visibility(
                      //           visible: orderList.length > 0 ? true:false,
                      //           child: Text('Most recent orders', style: TextStyle(color: Colors.white),)),
                      //       mybodyRec(),
                      //       SizedBox(height: 20,)
                      //     ],
                      //   ),
                      // )
                    ],
                  )),
            ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height -75,
              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.end,
                        //     children: [
                        //       GestureDetector(
                        //         onTap: (){
                        //           getOrders();
                        //         },
                        //           //padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        //           child: Icon(Icons.refresh,color: Colors.white,),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Text(
                              outletDesciption,
                              style: TextStyle(
                                color: Colors.deepOrange,
                                fontSize: 16,
                              ),
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Text(
                              outletName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            )),
                        Container(
                          height: 30,
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Visibility(
                                visible: isWorkingDay,
                                child: Container(
                                    child: Text(
                                  wk,
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                              Spacer(),
                              Container(
                                  padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                                  color: isWorkingDay == true
                                      ? Colors.green
                                      : Colors.red,
                                  child: Text(
                                    isWorkingDay == true ? 'online' : 'offline',
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          color: Colors.deepOrange,
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(50, 0, 20, 0),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Row(
                            children: [
                              Icon(
                                sttn != '101' ||
                                        sttn != '102' ||
                                        sttn != '103' ||
                                        sttn != '104' ||
                                        sttn != '105'
                                    ? Icons.check_circle
                                    : Icons.access_time_rounded,
                                size: 40,
                                color: sttn != '101' ||
                                        sttn != '102' ||
                                        sttn != '103' ||
                                        sttn != '104' ||
                                        sttn != '105'
                                    ? Colors.green
                                    : Colors.deepOrange,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Order on Hold',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Spacer(),
                              Visibility(
                                //visible: sttn == '1' ? true:false,
                                child: GestureDetector(
                                  onTap: () async {
                                    Prefs.load();
                                    String token = Prefs.getString('token');
                                    String myt = "'{'newState': 'Canceled'}'";
                                    Map<String, String> headers = {
                                      'Authorization': 'Bearer ' + token,
                                      'Content-Type': 'application/json'
                                    };
                                    Map<String, String> body = {
                                      'newState': 'Canceled'
                                    };
                                    String url =
                                        ApiCon.baseurl() + '/Orders/' + id;

                                    final response = await http.patch(url,
                                        headers: headers, body: myt);
                                    print(response.body);
                                  },
                                  child: Container(
                                      width: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.transparent,
                                        border: Border.all(
                                          color: Colors
                                              .white, //                   <--- border color
                                          width: 2.0,
                                        ),
                                      ),
                                      padding:
                                          EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      child: Center(
                                          child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ))),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.fromLTRB(50, 0, 20, 0),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Row(
                            children: [
                              Icon(
                                sttn == '2' ||
                                        sttn == '3' ||
                                        sttn == '4' ||
                                        sttn == '5'
                                    ? Icons.check_circle
                                    : Icons.access_time_rounded,
                                size: 40,
                                color: sttn == '2' ||
                                        sttn == '3' ||
                                        sttn == '4' ||
                                        sttn == '5'
                                    ? Colors.green
                                    : Colors.deepOrange,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Order Accepted',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(50, 0, 20, 0),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Row(
                            children: [
                              Icon(
                                sttn == '2' ||
                                        sttn == '3' ||
                                        sttn == '4' ||
                                        sttn == '5'
                                    ? Icons.check_circle
                                    : Icons.access_time_rounded,
                                size: 40,
                                color: sttn == '2' ||
                                        sttn == '3' ||
                                        sttn == '4' ||
                                        sttn == '5'
                                    ? Colors.green
                                    : Colors.deepOrange,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Order Process',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(50, 0, 20, 0),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Row(
                            children: [
                              Icon(
                                sttn == '2' ||
                                        sttn == '3' ||
                                        sttn == '4' ||
                                        sttn == '5'
                                    ? Icons.check_circle
                                    : Icons.access_time_rounded,
                                size: 40,
                                color: sttn == '2' ||
                                        sttn == '3' ||
                                        sttn == '4' ||
                                        sttn == '5'
                                    ? Colors.green
                                    : Colors.deepOrange,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Preparing Order',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(50, 0, 20, 0),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Row(
                            children: [
                              Icon(
                                sttn == '4' || sttn == '5'
                                    ? Icons.check_circle
                                    : Icons.access_time_rounded,
                                size: 40,
                                color: sttn == '4' || sttn == '5'
                                    ? Colors.green
                                    : Colors.deepOrange,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Collect Order',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        //Spacer(),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: sttn == '5' ? true : false,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(50, 0, 20, 0),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Row(
                              children: [
                                Icon(Icons.check_circle,
                                    size: 40, color: Colors.green),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Complete',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: sttn == '101' ||
                                  sttn == '102' ||
                                  sttn == '103' ||
                                  sttn == '104' ||
                                  sttn == '105'
                              ? true
                              : false,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(50, 0, 20, 0),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 40,
                                  color: Colors.deepOrange,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  state,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black12,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey.withOpacity(.5),
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time will start when your order is ready',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'TIME LEFT TO',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    Text(
                                      'COLLECT',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Text(
                                  mins.toString() + ':' + secs.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'min',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 100),
                      child: Row(
                        children: [
                          Expanded(
                            child: FlatButton(
                                height: 50,
                                minWidth: double.infinity,
                                color: Colors.deepOrange,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {
                                  if (sttn == '2' ||
                                      sttn == '3' ||
                                      sttn == '4' ||
                                      sttn == '5') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MoreDetails(
                                              code, byw, outletName)),
                                    );
                                  }
                                },
                                child: Container(
                                  height: 70,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Image.asset(
                                      //   'assets/images/applelogo.png',
                                      //   height: 30.0,
                                      //   width: 30.0,
                                      // ),
                                      //SizedBox(width: 10,),
                                      Text(
                                        'View Order',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      Text(
                                        '(click at collection point)',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MenuPage(outletid,
                                          outletName, outletDesciption)),
                                );
                              },
                              child: Container(
                                  width: 90,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: Colors
                                          .white, //                   <--- border color
                                      width: 2.0,
                                    ),
                                  ),
                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Center(
                                      child: Text(
                                    'NEW ORDER',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}

class Order {
  final String timestamp;
  final List<MyItems> itemslist;
  final String barid;
  final String cState;
  final String sttn;
  final String outlet;
  final String itemcount;
  final String price;

  Order(this.timestamp, this.itemslist, this.barid, this.cState, this.sttn,
      this.outlet, this.itemcount, this.price);
}

class MyItems {
  final String itemsname;
  final String itemsquantity;

  MyItems(this.itemsname, this.itemsquantity);
}
