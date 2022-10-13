<<<<<<< HEAD

=======
import 'dart:convert';
import 'package:driklink/pages/Api.dart';
import 'package:driklink/pages/home/home.dart';
import 'package:driklink/pages/login/signin.dart';
import 'package:http/http.dart' as http;
import 'package:driklink/pages/home/menupage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:driklink/pages/home/termPage.dart';
import 'package:driklink/data/pref_manager.dart';
import 'package:email_validator/email_validator.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class help extends StatefulWidget {
  @override
  _helpignPageState createState() => _helpignPageState();
}

class _helpignPageState extends State<help> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void initState() {}

  bool _validate() {
    String name = nameController.text;
    String email = emailController.text.replaceAll(' ', '');
    String message = messageController.text;
    if (name.isEmpty) {
      _messageDialog('Help Center', 'Please input your name.', '', 'Ok');
      return false;
    }
    if (email.isEmpty) {
      _messageDialog('Help Center', 'Please input your valid email.', '', 'Ok');
      return false;
    } else {
      String email = emailController.text.replaceAll(' ', '');
      final bool isValid = EmailValidator.validate(email);
      print(isValid);
      if (isValid == false) {
        _messageDialog(
            'Help Center', 'Please input your valid email.', '', 'Ok');
        return false;
      }
    }
    if (message.length <= 20) {
      _messageDialog('Help Center',
          'Please input message. Minimum of 20 characters.', '', 'Ok');
      return false;
    }
    return true;
  }

  main() async {
    // Note that using a username and password for gmail only works if
    // you have two-factor authentication enabled and created an App password.
    // Search for "gmail app password 2fa"
    // The alternative is to use oauth.
    String username = 'leepe@drinklinkph.com';
    String password = 'P@ssw0rd';

    final smtpServer =
        SmtpServer('plesk5600.is.cc', username: username, password: password);
    // final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    // final message = Message()
    //   ..from = Address(username, 'jo.leepeoutsourcing@gmail.com')
    //   ..recipients.add('jo.leepeoutsourcing@gmail.com')
    //   // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    //   // ..bccRecipients.add(Address('bccAddress@example.com'))
    //   ..subject = 'DrinkLink Help Center:: ${DateTime.now()}'
    //   ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    //   ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    final message = Message()
      ..from = Address(username, emailController.text)
      ..recipients.add(emailController.text)
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'DrinkLink@support : ${DateTime.now()}'
      // ..text = messageController.text;
      ..html = "<h1>" +
          nameController.text +
          "</h1>\n<p>" +
          messageController.text +
          "</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
    // DONE

    // Let's send another message using a slightly different syntax:
    //
    // Addresses without a name part can be set directly.
    // For instance `..recipients.add('destination@example.com')`
    // If you want to display a name part you have to create an
    // Address object: `new Address('destination@example.com', 'Display name part')`
    // Creating and adding an Address object without a name part
    // `new Address('destination@example.com')` is equivalent to
    // adding the mail address as `String`.
    // final equivalentMessage = Message()
    //   ..from = Address(username, 'Your name 😀')
    //   ..recipients.add(Address('destination@example.com'))
    //   ..ccRecipients
    //       .addAll([Address('destCc1@example.com'), 'destCc2@example.com'])
    //   ..bccRecipients.add('bccAddress@example.com')
    //   ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
    //   ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    //   ..html =
    //       '<h1>Test</h1>\n<p>Hey! Here is some HTML content</p><img src="cid:myimg@3.141"/>'
    //   ..attachments = [
    //     FileAttachment(File('exploits_of_a_mom.png'))
    //       ..location = Location.inline
    //       ..cid = '<myimg@3.141>'
    //   ];

    // final equivalentMessage = Message()
    //   ..from = Address(username, nameController.text + ' : support ')
    //   ..recipients.add(Address('jo.leepeoutsourcing@gmail.com'))
    //   // ..ccRecipients
    //   //     .addAll([Address('destCc1@example.com'), 'destCc2@example.com'])
    //   // ..bccRecipients.add('bccAddress@example.com')
    //   ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
    //   ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    //   ..html =
    //       '<h1>Test</h1>\n<p>Hey! Here is some HTML content</p><img src="cid:myimg@3.141"/>';

    final equivalentMessage = Message()
      ..from = Address(username, nameController.text + ' : support ')
      ..recipients.add(Address('jo.leepeoutsourcing@gmail.com.'))
      // ..ccRecipients
      //     .addAll([Address('destCc1@example.com'), 'destCc2@example.com'])
      // ..bccRecipients.add('bccAddress@example.com')
      ..subject = 'DrinkLink@support : ${DateTime.now()}'
      // ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>" +
          nameController.text +
          "</h1>\n<p>" +
          messageController.text +
          "</p>";
    final sendReport2 = await send(equivalentMessage, smtpServer);

    // Sending multiple messages with the same connection
    //
    // Create a smtp client that will persist the connection
    var connection = PersistentConnection(smtpServer);

    // Send the first message
    await connection.send(message);

    // send the equivalent message
    await connection.send(equivalentMessage);

    // close the connection
    await connection.close();
  }

  _sendMessage() async {
    if (_validate()) {
      main();
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
                      MaterialPageRoute(builder: (context) => HomePage()),
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
                    'Help Center',
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
                    'Please fill out the form below and we will get back to you as soon as possible.',
                    style: TextStyle(
                        wordSpacing: 3, color: Colors.white, fontSize: 16),
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: TextField(
                  controller: nameController,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  decoration: new InputDecoration(
                      hintText: "Name",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 18),
                      labelStyle:
                          new TextStyle(color: const Color(0xFF424242))),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: TextField(
                  controller: emailController,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  decoration: new InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 18),
                      labelStyle:
                          new TextStyle(color: const Color(0xFF424242))),
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: TextField(
                            controller: messageController,
                            maxLines: 14, //or null
                            decoration:
                                InputDecoration.collapsed(hintText: "Message"),
                          ),
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
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
                          setState(() {
                            _sendMessage();
                          });
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
                            Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              ' Submit',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )
                          ],
                        ),
                      ),
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

  _messageDialog(String title, String message, String a, String b) {
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
            if (a != '')
              FlatButton(
                child: Text(
                  a,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            if (b != '')
              FlatButton(
                child: Text(
                  b,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}
>>>>>>> 340291ce6f82d26fa8aaf62b6182b5834f96df5c
