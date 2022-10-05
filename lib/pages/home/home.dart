import 'package:driklink/auth_provider.dart';
import 'package:driklink/data/pref_manager.dart';
import 'package:driklink/pages/home/menupage.dart';
import 'package:driklink/pages/home/orderPage.dart';
import 'package:driklink/pages/home/orderdetails.dart';
import 'package:driklink/pages/home/settingPage.dart';
import 'package:driklink/pages/home/termPage.dart';
import 'package:driklink/pages/login/signin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:driklink/auth_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:driklink/pages/Api.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController seedit = new TextEditingController();
  Future myStore;
  int dtofdy = 0;
  String token;
  String stoken;
  List<Order> orderList = [];
  Future ord;
  bool _ontap;
  String uName = '';

  @override
  setNotif(String ftoken) async {
    try {
      Prefs.load();
      String token = Prefs.getString('token');
      String email = Prefs.getString('email');
      print("my token: " + token);
      String myt = "'" + ftoken + "'";
      final bod = jsonEncode({'token': ftoken, 'clientAppPlatform': 'ios'});
      Map<String, String> headers = {
        'Authorization': 'Bearer ' + token,
        'Content-Type': 'application/json',
        'api-version': '1.1'
      };
      String url =
          ApiCon.baseurl() + '/auth/users/currentUser/notificationToken';

      final response = await http.patch(url, headers: headers, body: bod);
      print(response.body);
      print(response.statusCode);
      print('set notif \n \n ');
    } catch (e) {}
  }
  final _focusNode = FocusNode();
  bool isSearching = false;

  void initState() {
    Prefs.load();
    super.initState();
    _ontap = true;
    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");
      isSearching = _focusNode.hasFocus;
    });
    // myList = [];
    // myStore = getStore();

    getDayofweek();
    getToke();
    bool snd = true;
    bool art = true;
    String firsttime = Prefs.getString('first');
    if (firsttime == null) {
      Prefs.setBool('sound', true);
      Prefs.setBool('alert', true);
      Prefs.setString('first', 'install');
    } else {
      print('First:' + firsttime);
      print(Prefs.getBool('sound'));
    }

    try {
      if (Prefs.getBool('sound') != null) {
        snd = Prefs.getBool('sound');
        //art = Prefs.getBool('alert');
      } else {
        Prefs.setBool('sound', true);
        //Prefs.setBool('alert', true);
        snd = true;
        art = true;
      }
    } catch (e) {
      Prefs.setBool('sound', true);
      //Prefs.setBool('alert', true);
      snd = true;
      //art = true;
    }

    try {
      if (Prefs.getBool('alert') != null) {
        //snd = Prefs.getBool('sound');
        art = Prefs.getBool('alert');
      } else {
        //Prefs.setBool('sound', true);
        Prefs.setBool('alert', true);
        //snd = true;
        art = true;
      }
    } catch (e) {
      //Prefs.setBool('sound', true);
      Prefs.setBool('alert', true);
      //snd = true;
      art = true;
    }
    print(Prefs.getBool('sound'));
    FirebaseMessaging.instance.requestPermission(
      alert: art,
      sound: snd,
    );

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      // if (message != null) {
      //   Navigator.pushNamed(context, '/message',
      //       arguments: MessageArguments(message, true));
      // }
      print(message);
    });

    FirebaseMessaging.instance
        .getToken(
            vapidKey:
                'BGpdLRsMJKvFDD9odfPk92uBg-JbQbyoiZdah0XlUyrjG4SDgUsE1iC_kdRgt4Kn0CO7K3RTswPZt61NNuO0XoA')
        .then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);

    FirebaseMessaging.instance.getToken().then((value) {
      print("This is the token" + value);

      setNotif(value);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification.body);
      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: Text("Notification"),
      //         content: Text(event.notification.body),
      //         actions: [
      //           TextButton(
      //             child: Text("Ok"),
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //           )
      //         ],
      //       );
      //     });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    orderList = [];
    ord = getOrders();
  }

  Future<List<Order>> getOrders() async {
    setState(() {
      orderList = [];
    });
    Prefs.load();
    String mytoken = Prefs.getString('token');
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + mytoken
      };
      final response = await http.get(
          ApiCon.baseurl() +
              '/users/currentUser/orders?pageSize=5&pageNumber=1',
          headers: headers);
      var jsondata = json.decode(response.body);

      for (var i = 0; i < jsondata.length; i++) {
        String cState =
            json.decode(response.body)[i]['currentState'].toString();
        //if(cState == '1' || cState == '2' || cState == '3' || cState == '4'){
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
        // String cState = json.decode(response.body)[i]['currentState'].toString();
        if (cState == '0') {
          stt = 'Order Created';
        } else if (cState == '1') {
          stt = 'Pending';
        } else if (cState == '2') {
          stt = 'Accepted';
        } else if (cState == '3') {
          stt = 'Payment Processed';
        } else if (cState == '4') {
          stt = 'Ready';
        } else if (cState == '5') {
          stt = 'Completed';
        } else if (cState == '101') {
          stt = 'Failed';
        } else if (cState == '102') {
          stt = 'Canceled';
        } else if (cState == '103') {
          stt = 'Rejected';
        } else if (cState == '104') {
          stt = 'Not Collected';
        } else if (cState == '105') {
          stt = 'Payment Failed';
        }

        String outletname = await getFacilityInfo(
            json.decode(response.body)[i]['facilityId'].toString());
        print("OUTLET NAME: " + outletname);
        setState(() {
          Order myorder = new Order(dt.toString(), newItem, bar, stt, cState,
              outletname, newItem.length.toString(), mprice);

          orderList.add(myorder);
        });
        // }

      }
      return orderList;
    } catch (e) {
      return null;
    }
  }

  Future<String> getFacilityInfo(String id) async {
    String name = '';
    print('Getting outlet info');
    print(id);
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
        return u['name'];
      }
    }
    return '';
  }

  String _token;
  Stream<String> _tokenStream;

  void setToken(String token) {
    print('FCM Token: $token');
    setState(() {
      _token = token;
      Prefs.setString('notifToken', _token);
    });
  }

  getToke() {
    try {
      token = Prefs.getString('token');
      String em = Prefs.getString('email');
      print(token);
      print('Your email ' + em);
    } catch (e) {
      token = '';
    }
  }

  getDayofweek() {
    DateTime date = DateTime.now();
    String dateFormat = DateFormat('EEEE').format(date);
    print(dateFormat);
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

  Future<List<Store>> getStore() async {
    String setext = seedit.text.toLowerCase();

    List<Store> myList = [];
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    String url = ApiCon.baseurl() + ApiCon.storeUrl;
    final response = await http.get(url, headers: headers);
    //print(response.body.toString());
    var jsondata = json.decode(response.body);

    for (var u in jsondata) {
      if (setext == '') {
        print(u['name']);
        String id,
            name,
            address,
            description,
            delivery,
            pickup,
            area,
            city,
            image;

        id = u['id'].toString();

        if (u['name'] == null) {
          name = '';
        } else {
          name = u['name'];
        }
        if (u['address'] == null) {
          address = '';
        } else {
          address = u['address'];
        }
        // if(u['description'] == null){
        //   description = '';
        // }else{
        //   description = u['description'];
        // }
        if (u['isTableDeliveryEnabled'] == null) {
          delivery = '';
        } else {
          delivery = u['isTableDeliveryEnabled'].toString();
        }
        if (u['isPickupEnabled'] == null) {
          pickup = '';
        } else {
          pickup = u['isPickupEnabled'].toString();
        }
        if (u['area'] == null) {
          area = '';
        } else {
          area = u['area'];
        }
        if (u['city'] == null) {
          city = '';
        } else {
          city = u['city'];
        }
        if (u['coverImagePath'] == null) {
          image = '';
        } else {
          image = u['coverImagePath'];
        }
        Store store = Store(id, name, address, 'description', delivery, pickup,
            area, city, image);

        myList.add(store);
      } else {
        String storename = u['name'].toString().toLowerCase();
        if (storename.contains(setext)) {
          print(u['name']);
          String id,
              name,
              address,
              description,
              delivery,
              pickup,
              area,
              city,
              image;

          id = u['id'].toString();

          if (u['name'] == null) {
            name = '';
          } else {
            name = u['name'];
          }
          if (u['address'] == null) {
            address = '';
          } else {
            address = u['address'];
          }
          // if(u['description'] == null){
          //   description = '';
          // }else{
          //   description = u['description'];
          // }
          if (u['isTableDeliveryEnabled'] == null) {
            delivery = '';
          } else {
            delivery = u['isTableDeliveryEnabled'].toString();
          }
          if (u['isPickupEnabled'] == null) {
            pickup = '';
          } else {
            pickup = u['isPickupEnabled'].toString();
          }
          if (u['area'] == null) {
            area = '';
          } else {
            area = u['area'];
          }
          if (u['city'] == null) {
            city = '';
          } else {
            city = u['city'];
          }
          if (u['coverImagePath'] == null) {
            image = '';
          } else {
            image = u['coverImagePath'];
          }
          Store store = Store(id, name, address, 'description', delivery,
              pickup, area, city, image);

          myList.add(store);
        }
      }
    }

    print(myList.length);

    return myList;
  }

  toggleDrawer() async {
    if (_scaffoldKey.currentState.isDrawerOpen) {
      _scaffoldKey.currentState.openDrawer();
    } else {
      _scaffoldKey.currentState.openEndDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    String _token = context.read<AuthProvider>().token;
    String token = Prefs.getString('token');
    uName = Prefs.getString('uname') ?? '';
    if (_token.isNotEmpty) {
      stoken = _token;
    } else {
      stoken = token;
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          setState(() {
            _ontap = true;
          });

          return false;
        },
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
              seedit.clear();
              _ontap = true;
            }
          },
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bkgdefault.png"),
                    fit: BoxFit.cover)),
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: 35,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      orderList = [];
                      ord = getOrders();
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                  )
                ],
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
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
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
                              MaterialPageRoute(
                                  builder: (context) => setPage()),
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
                              MaterialPageRoute(
                                  builder: (context) => termPage()),
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
                            //Navigator.of(context).popAndPushNamed('/home');
                            if (stoken == '' ||
                                stoken == null ||
                                stoken.isEmpty) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn()),
                              );
                            } else {
                              _showDialogout("Drinklink", "Proceed logout?");
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
                                new Expanded(
                                  flex: 1,
                                  child: new SingleChildScrollView(
                                    scrollDirection:
                                        Axis.horizontal, //.horizontal
                                    child: new Text(
                                      stoken == '' ||
                                              stoken == null ||
                                              stoken.isEmpty
                                          ? "Sign In / Register"
                                          : "Sign Out (" + uName + ")",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Spacer(),
                        Row(children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 50, 10, 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                    visible:
                                        orderList.length > 0 ? true : false,
                                    child: Text(
                                      'Most recent orders',
                                      style: TextStyle(color: Colors.white),
                                    )),
                                mybodyRec(),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                        ]),
                      ],
                    )),
              ),
              backgroundColor: Colors.transparent,
              body: Container(
                height: MediaQuery.of(context).size.height - 80,
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Home',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Choose featured places or search',
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 60, 0, 30),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 320,
                          child: mybody(),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(14.0), topRight: Radius.circular(14.0)),
                              color: isSearching ? Colors.grey[900].withOpacity(.8):Colors.transparent
                              
                            ),
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 100),
                        child: TextField(
                          focusNode: _focusNode,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white70,
                            height: 1,
                          ),
                          onTap: () {
                            setState(() {
                              _ontap = false;
                            });
                          },
                          onSubmitted: (value) {
                            _ontap = true;
                          },
                          onChanged: (value) {
                            setState(() {
                              getStore();
                            });
                          },
                          controller: seedit,
                          decoration: new InputDecoration(
                              filled: true,
                              hintStyle: new TextStyle(
                                  color: Colors.white70, fontSize: 20),
                              hintText: "Enter name, area or address",
                              fillColor: Colors.transparent),
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
                              child: FlatButton(
                                height: 50,
                                minWidth: double.infinity,
                                color: Colors.deepOrange,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                onPressed: () {
                                  //getOrders();
                                  getStore();
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
                                      'SEARCH',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  mybodyRec() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
      height: 250,
      child: FutureBuilder(
          future: ord,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                    //child: CircularProgressIndicator(),
                    ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderDetails('')),
                        );
                      },
                      child: Container(
                          height: 500,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFF2b2b61).withOpacity(.5),
                          ),
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data[index].outlet,
                                    style: TextStyle(
                                        color: Colors.deepOrange, fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 20,
                                    width:
                                        MediaQuery.of(context).size.width / 2 +
                                            30,
                                    child: Row(
                                      children: [
                                        Text(
                                          'Order (' +
                                              snapshot.data[index].itemcount +
                                              ' item):',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                        Spacer(),
                                        Text(
                                          snapshot.data[index].price + ' AED):',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 20,
                                    width:
                                        MediaQuery.of(context).size.width / 2 +
                                            30,
                                    child: Row(
                                      children: [
                                        Text(
                                          'Collect before:',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                        Spacer(),
                                        Text(
                                          snapshot.data[index].itemcount +
                                              ' AED):',
                                          style: TextStyle(
                                              color: Colors.deepOrange,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 20,
                                    width:
                                        MediaQuery.of(context).size.width / 2 +
                                            30,
                                    child: Row(
                                      children: [
                                        Text(
                                          'Status:',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                        Spacer(),
                                        Text(
                                          snapshot.data[index].cState,
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 20,
                                    width:
                                        MediaQuery.of(context).size.width / 2 +
                                            30,
                                    child: Row(
                                      children: [
                                        Text(
                                          'Created:',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                        Spacer(),
                                        Text(
                                          snapshot.data[index].timestamp,
                                          style: TextStyle(
                                              color: Colors.deepOrange,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          )),
                    );
                  });
            }
          }),
    );
  }
  _showDialogout(String title, String message) {
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
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
               context.read<AuthProvider>().setToken('');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                              );
                              setState(() {
                                setState(() {
                                  Prefs.load();
                                  Prefs.setString('token', '');
                                  Prefs.setString('uname', 'none');
                                  Prefs.setString('bfNamenone', '');
                                  Prefs.setString('blMamenone', '');
                                  Prefs.setString('billNamenone', '');
                                  Prefs.setString('billAddnone', '');
                                  Prefs.setString('billEmailnone', '');
                                });
                              });
              },
            )
          ],
        ),
      ),
    );
  }

  mybody() {
    return Container(
      child: FutureBuilder(
          future: getStore(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  // physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if(StoreID == ''){
                          StoreID = snapshot.data[index].id;
                          myOrder = [];
                          Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MenuPage(
                                  snapshot.data[index].id,
                                  snapshot.data[index].name,
                                  snapshot.data[index].address)),
                        );
                        }else{
                          if(StoreID == snapshot.data[index].id){
                            Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MenuPage(
                                  snapshot.data[index].id,
                                  snapshot.data[index].name,
                                  snapshot.data[index].address)));
                          }else{
                            StoreID = snapshot.data[index].id;
                          myOrder = [];
                          Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MenuPage(
                                  snapshot.data[index].id,
                                  snapshot.data[index].name,
                                  snapshot.data[index].address)));
                          }
                        }
                      
                      },
                      child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          color: Colors.transparent,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: Colors.transparent,
                                width: 60,
                                height: 60,
                                //this will load the image
                                // child: Image.network(ApiCon.baseurl() +
                                //     snapshot.data[index].image)
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data[index].name,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  Text(
                                    snapshot.data[index].address,
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14),
                                  ),
                                ],
                              )
                            ],
                          )),
                    );
                  });
            }
          }),
    );
  }
}

class Store {
  final String id;
  final String name;
  final String address;
  final String description;
  final String delivery;
  final String pickup;
  final String area;
  final String city;
  final String image;

  Store(this.id, this.name, this.address, this.description, this.delivery,
      this.pickup, this.area, this.city, this.image);
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
