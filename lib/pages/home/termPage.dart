import 'dart:convert';
import 'dart:io';
import 'package:driklink/data/pref_manager.dart';
import 'package:driklink/pages/home/home.dart';
import 'package:driklink/pages/login/signup.dart';
import 'package:driklink/pages/home/menupage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class termPage extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class termsSign extends StatefulWidget {
  @override
  WebViewExampleState1 createState() => WebViewExampleState1();
}

class WebViewExampleState extends State<termPage> {
  String murl =
      'https://drinklink.ae/oathygow/2020/12/Terms-of-Service-DrinkLink.pdf';
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    final flutterWebviewPlugin = new FlutterWebviewPlugin();
    flutterWebViewPlugin.onUrlChanged.listen((String url) {});
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: murl,
      appBar: new AppBar(
        backgroundColor: Color(0xFF2b2b61),
        title: new Text(
          "Terms of Service",
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
      initialChild: Container(
        color: Colors.white,
        child: const Center(
          child: Text('Waiting.....'),
        ),
      ),
    );
  }
}

class WebViewExampleState1 extends State<termsSign> {
  String murl =
      'https://drinklink.ae/oathygow/2020/12/Terms-of-Service-DrinkLink.pdf';
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    final flutterWebviewPlugin = new FlutterWebviewPlugin();
    flutterWebViewPlugin.onUrlChanged.listen((String url) {});
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: murl,
      appBar: new AppBar(
        backgroundColor: Color(0xFF2b2b61),
        title: new Text(
          "Terms of Service",
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
              MaterialPageRoute(builder: (context) => SignUp()),
            );
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
