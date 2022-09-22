import 'dart:convert';
import 'dart:io';
import 'package:driklink/data/pref_manager.dart';
import 'package:driklink/pages/Api.dart';
import 'package:driklink/pages/home/menupage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:developer' as dev;

class WebPage extends StatefulWidget {
  String url;
  String reference;

  WebPage(this.url, this.reference);
  @override
  WebViewExampleState createState() =>
      WebViewExampleState(this.url, this.reference);
}

class WebViewExampleState extends State<WebPage> {
  String murl;
  String reference;

  WebViewExampleState(this.murl, this.reference);
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    final flutterWebviewPlugin = new FlutterWebviewPlugin();
    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      print("This is url: " + url);
      if (url != murl) {
        //Navigator.pop(context, url);
        Order(url);
      }
    });
  }

  checkUrlRes(String url) async {
    //https://paypage.sandbox.ngenius-payments.com/?code=56000e9c278ad09d
    // bool checkurl = url.contains('https://paypage.ngenius-payments.com/?outletId=');
    bool checkurl =
        url.contains('https://paypage.sandbox.ngenius-payments.com/?outletId=');

    print(checkurl);
    // if (checkurl == true) {
    bool suc = url.contains('SUCCESS');
    //if (suc == true) {
    var divurl = url.split('=');
    print(divurl[2].trim());
    String codena = divurl[2].trim();
    String mycode = codena.replaceAll('&paymentRef', '');
    print(mycode);

    // Navigator.pop(context, mycode);

    // }

    // Map<String, String> headers = {"Content-Type": "application/json; charset=utf-8"};
    // final response = await http.get(url,headers: headers);
    // var jsondata = json.decode(response.body);
    //
    // //print(jsondata.toString());
    // if(response.statusCode == 200){
    //   if(jsondata.toString() == '{backToCart: true}') {
    //     Navigator.of(context).pop();
    //     //Navigator.pop(context, url);
    //     //print(json.decode(response.body)['savedCard']['maskedPan']);
    //   }else {
    //     //print(jsondata['savedCard']);
    //     if(json.decode(response.body)['savedCard']['cardToken'] != '' || json.decode(response.body)['savedCard']['cardToken'] != null) {
    //       if (json.decode(response.body)['state'] != 'FAILED' ||
    //           json.decode(response.body)['state'] != null ||
    //           json.decode(response.body)['state'] != '') {
    //         //Navigator.of(context).pop();
    //         print(json.decode(response.body)['state']);
    //         Navigator.pop(context, url);
    //       }
    //     }
    //
    //
    //   }
    // }
  }

  Order(String url) async {
    Prefs.load();
    String token = Prefs.getString('token');

    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ' + token
    };

    // String url = ApiCon.baseurl() + '/orders/paid/?ref=' + reference;
    final response = await http.post(url, headers: headers);
    //var jsondata = json.decode(response.headers);
    dev.log(response.body.toString());
    String mystate =
        json.decode(response.body)['_embedded']['payment'][0]['state'];
    dev.log(mystate);
    if (mystate == 'AUTHORISED') {
      Navigator.pop(context, 'AUTHORISED');
    } else if (mystate == 'CANCELLED') {
      Navigator.pop(context, 'failed');
    }else {
      Navigator.pop(context, 'failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: murl,
      appBar: new AppBar(
        backgroundColor: Color(0xFF2b2b61),
        title: new Text(
          "Payment",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        //     actions: [
        //       Padding(
        //   padding: EdgeInsets.only(right: 20.0),
        //   child: GestureDetector(
        //     onTap: () {
        //       Order();
        //     },
        //     child: Icon(
        //       Icons.search,
        //       size: 26.0,
        //     ),
        //   )
        // ),
        //     ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context, 'failed');
          },
        ),
      ),
      initialChild: Container(
        color: Colors.white,
        child: const Center(
          child: Text('Waiting.....'),
        ),
      ),
    );
  }
}
