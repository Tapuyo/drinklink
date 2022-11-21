import 'dart:async';
import 'dart:convert';

import 'package:driklink/data/pref_manager.dart';
import 'package:driklink/pages/Api.dart';
import 'package:driklink/pages/home/orderdetails.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MoreDetails extends StatefulWidget {
  String code, byw, outlet;
  MoreDetails(this.code, this.byw, this.outlet);
  @override
  _MoreDetailsState createState() =>
      _MoreDetailsState(this.code, this.byw, this.outlet);
}

class _MoreDetailsState extends State<MoreDetails> {
  String code, byw, outlet;
  _MoreDetailsState(this.code, this.byw, this.outlet);
  String state = '';
  Timer _timer;
  int _start = 10;
  String mins = '00';
  String secs = '00';
  List<MyItems> orderList = [];
  Future itemord;

  @override
  void initState() {
    super.initState();
    getOrders();
    itemord = getOrdersList();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  getOrders() async {
    Prefs.load();
    String token = Prefs.getString('token');
    print(token);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ' + token
    };
    final response = await http.get(
        Uri.parse(ApiCon.baseurl() + '/users/currentUser/orders?pageSize=1&pageNumber=1'),
        headers: headers);
    var jsondata = json.decode(response.body);

    for (var i = 0; i < jsondata.length; i++) {
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
      String cState = json.decode(response.body)[i]['currentState'].toString();
      setState(() {
        state = stt.toString();
      });

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
          String timeToCollect = json.decode(response.body)[i]['timeToCollectMins'];
          
          print('time to collect:' + timeToCollect);
          final format = DateFormat('hh:mm:ss');
          final dt = format.parse(timeToCollect, true);
          print(dt.toString());
          double sec = Duration(milliseconds: dt.millisecondsSinceEpoch).inMilliseconds / 1000;
        
          print('in seconds');
          print(sec.toString());
         
                       if (mounted) {
            _start = int.parse(sec.round().toString()) ?? 0;
          }
                    });
          stt = 'Ready';
      } else if (cState == '5') {
        _timer.cancel();
        stt = 'Collected';
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
      } else if (cState == '106') {
        stt = 'Payment Cancelled';
        _timer.cancel();
      }
    }
    if (_start > 0) {
      startTimer();
    }
  }

  void startTimer() {
    print('kjaskjdhakjsdhkjahsd');
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => OrderDetails()),
                          // );
                        },
                        child: Icon(
                          Icons.arrow_back_outlined,
                          color: Colors.white,
                          size: 30,
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      outlet,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'CODE:',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      code.substring(0, 1),
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 50),
                    ),
                    Text(
                      code.substring(
                        1,
                      ),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 50),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                color: Colors.deepOrange,
                thickness: 5,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'TIME LEFT TO',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          'COLLECT',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      mins.toString() + ':' + secs.toString(),
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'min',
                      style: TextStyle(color: Colors.deepOrange, fontSize: 30),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Prepared by:' + byw,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                color: Colors.deepOrange,
                thickness: 5,
              ),
              SizedBox(
                height: 5,
              ),
              mybodylist(),
            ],
          ),
        ),
      ),
    );
  }

  mybodylist() {
    return Container(
      //color: Colors.grey,
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder(
          future: itemord,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              children: [
                                Text(
                                  snapshot.data[index].itemsname,
                                  style: TextStyle(
                                      color: Colors.deepOrange, fontSize: 25),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  snapshot.data[index].volume,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                Spacer(),
                                Text(
                                  snapshot.data[index].itemsquantity,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                        Divider(
                          color: Colors.white,
                          thickness: 2,
                        )
                      ],
                    );
                  });
            }
          }),
    );
  }

  Future<List<MyItems>> getOrdersList() async {
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
        Uri.parse(ApiCon.baseurl() + '/users/currentUser/orders?pageSize=1&pageNumber=1'),
        headers: headers);
    var jsondata = json.decode(response.body);

    for (var i = 0; i < jsondata.length; i++) {
      var jsondata1 = await json.decode(response.body)[i]['items'];

      List<MyItems> newItem = [];
      for (var x in jsondata1) {
        String quat;
        if (int.parse(x['quantity'].toString()) < 10) {
          quat = '0' + x['quantity'].toString();
        } else {
          quat = x['quantity'].toString();
        }
        MyItems nt =
            new MyItems(x['drink']['name'], quat, x['drink']['volume']);

        orderList.add(nt);
      }
    }
    return orderList;
  }
}

class MyItems {
  final String itemsname;
  final String itemsquantity;
  final String volume;

  MyItems(this.itemsname, this.itemsquantity, this.volume);
}
