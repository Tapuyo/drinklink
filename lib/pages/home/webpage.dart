import 'dart:convert';
import 'dart:io';
import 'package:driklink/data/pref_manager.dart';
import 'package:driklink/pages/Api.dart';
import 'package:driklink/pages/home/menupage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:rflutter_alert/rflutter_alert.dart';




class WebPage extends StatefulWidget {
  String url;



  WebPage(this.url);
  @override
  WebViewExampleState createState() => WebViewExampleState(this.url);
}

class WebViewExampleState extends State<WebPage> {
  String murl;

  WebViewExampleState(this.murl);
  final flutterWebViewPlugin = FlutterWebviewPlugin();


  @override
  void initState() {
    super.initState();
    final flutterWebviewPlugin = new FlutterWebviewPlugin();
    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      print("This is url: "+ url);
      if(url != murl){
        //Navigator.pop(context, url);
        checkUrlRes(url);
      }
    });
  }

  checkUrlRes(String url)async {
    bool checkurl = url.contains('https://paypage.ngenius-payments.com/?outletId=');

    if(checkurl == true){
      bool suc = url.contains('SUCCESS');
      if(suc == true) {
        var divurl = url.split('=');
        print(divurl[2].trim());
        String codena = divurl[2].trim();
        String mycode = codena.replaceAll('&paymentRef', '');
        print(mycode);
        Navigator.pop(context, mycode);
      }else{
        Navigator.pop(context, 'failed');
      }
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

  Order() async{
    Prefs.load();
    String token = Prefs.getString('token');
    int facility = Prefs.getInt('Facility');
    //drinkCatId
    int drinkCatId = Prefs.getInt('drinkCatId');
    int drinkId = Prefs.getInt('drinkId');
    int quant = Prefs.getInt('Quant');
    double price = Prefs.getDouble('Price');
    print(token);
    print(facility);
    print(price);
    print(drinkCatId);
    print(drinkId);
    Map<String, String> headers = {"Content-Type": "application/json", 'Authorization': 'Bearer ' + token};
    Map map = {
      "facilityId": facility,
      "barId": 1,
      'items': [
        {
          "drink":
          {
            "id": drinkId,
            "drinkCategoryId": drinkCatId,
            "price": 35.0
          },
          "quantity": 2,
          "price": 70.0
        }
      ],
      "tip": 0,
      "originalPrice": 70.0,
      "finalPrice": 70.0
    };
    var body = json.encode(map);
    String url = ApiCon.baseurl + '/orders';
    final response = await http.post(url,headers: headers, body: body);
    //var jsondata = json.decode(response.headers);
    print(response.body.toString());
    if(response.statusCode == 200){
      print('200');
    }else{
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(

      url: murl,
      appBar: new AppBar(
        backgroundColor: Color(0xFF2b2b61),
        title: new Text("Payment",style: TextStyle(fontSize: 20, color: Colors.white),),
        leading:  IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
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

