import 'dart:convert';
import 'dart:io';
import 'package:driklink/data/pref_manager.dart';
import 'package:driklink/pages/home/menupage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:developer' as dev;
import '../Api.dart';

class SaveCardWeb extends StatefulWidget {
  String url;
   String reference;

  SaveCardWeb(this.url,this.reference);
  @override
  WebViewExampleState createState() => WebViewExampleState(this.url,this.reference);
}

class WebViewExampleState extends State<SaveCardWeb> {
  String murl;
   String reference;

  WebViewExampleState(this.murl,this.reference);
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    final flutterWebviewPlugin = new FlutterWebviewPlugin();
    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      print("This is url: " + url);
      if (url != murl) {
        //Navigator.pop(context, url);
        AddCard(url);
      }
    });
  }

  checkUrlRes(String url) async {
    bool checkurl = url.contains('paidCard');
    bool checkurl1 = url.contains('UnpaidCard');

    if (checkurl == true && checkurl1 == false) {
      // var divurl = url.split('=');
      // print(divurl[2].trim());
      // String codena = divurl[2].trim();
      // String mycode = codena.replaceAll('&paymentRef', '');
      // print(mycode);
      Navigator.pop(context, 'Added');
    } else if (checkurl == true && checkurl1 == true) {
      //  Navigator.pop(context, 'Failed');
    } else {
      // Navigator.pop(context, 'Failed');
    }

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
  AddCard(String url) async {
    Prefs.load();
    String token = Prefs.getString('token');

    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ' + token
    };

    // String url = ApiCon.baseurl() + '/users/paidCard/?ref=' + reference;
    final response = await http.post(url, headers: headers);
    //var jsondata = json.decode(response.headers);
    dev.log(response.body.toString());
    String mystate =
        json.decode(response.body)['_embedded']['payment'][0]['state'];
    dev.log(mystate);
    if (mystate == 'REVERSED') {
      Navigator.pop(context, 'Added');
    } else if (mystate == 'SUCCESS') {
      Navigator.pop(context,'Added');
    }else if (mystate == 'AUTHORISED') {
      Navigator.pop(context,'Added');
    }else if (mystate == 'CANCELLED') {
      Navigator.pop(context, 'failed');
    }else if (mystate == '3DS') {
      Navigator.pop(context, 'failed');
    }  else if (mystate == 'FAILED') {
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
          "Save Card",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
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
