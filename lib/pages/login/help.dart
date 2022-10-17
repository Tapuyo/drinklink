
import 'package:driklink/pages/home/home.dart';
import 'package:flutter/material.dart';
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
  bool progress = false;

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

  _clear() {
    // nameController.text = '';
    // emailController.text = '';
    messageController.text = '';
  }

  main() async {
<<<<<<< HEAD
    _loadPreview();

=======
    Navigator.of(context).push(
      new PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
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
    // Note that using a username and password for gmail only works if
    // you have two-factor authentication enabled and created an App password.
    // Search for "gmail app password 2fa"
    // The alternative is to use oauth.
>>>>>>> 1b55f0cdc28802c334dc4a683d8b45ac746b09a5
    String username = 'leepe@drinklinkph.com';
    String password = 'P@ssw0rd';

    final smtpServer =
        SmtpServer('plesk5600.is.cc', username: username, password: password);

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
      _showDialogSuccess('DrinkLink', 'Successfully sent message');
      
    } on MailerException catch (e) {
      _showDialog('DrinkLink', 'Something went wrong!');
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }

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
    // final sendReport2 = await send(equivalentMessage, smtpServer);

    var connection = PersistentConnection(smtpServer);

    // Send the first message
    final rsult = await connection.send(message);
    if (rsult.toString().contains('Message successfully sent')) {
      Navigator.of(context).pop();
      _messageDialog('Help Center', 'Your message was sent successfully!', '',
          'Send Again');
      _clear();
    } else {
      Navigator.of(context).pop();
      _messageDialog('Help Center', 'Failed to send message!', '', 'Ok');
    }

    // send the equivalent message
    // await connection.send(equivalentMessage);

    // close the connection
    await connection.close();
    Navigator.pop(context);
  }

  _showDialog(String title, String message) {
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
                'Close',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            )
          ],
        ),
      ),
    );
  }

  _showDialogSuccess(String title, String message) {
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
                'Close',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
              },
            )
          ],
        ),
      ),
    );
  }

  _sendMessage() async {
    if (_validate()) {
      main();
    }
  }

  _loadPreview() async {
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
