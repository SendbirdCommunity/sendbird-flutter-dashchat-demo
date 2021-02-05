import 'dart:async';

import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:sendbirdsdk/sendbirdsdk.dart' as sb;

class LoginView extends StatefulWidget {
  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final appIdController =
      TextEditingController(text: "D56438AE-B4DB-4DC9-B440-E032D7B35CEB");
  final userIdController = TextEditingController();
  bool enableSignInButton = false;

  bool shouldEnableSignInButton() {
    if (appIdController.text == null || appIdController.text == "") {
      return false;
    }
    if (userIdController.text == null || userIdController.text == "") {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: body(context),
    );
  }

  Widget navigationBar() {
    return AppBar(
      toolbarHeight: 65,
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading:
          UniversalPlatform.isAndroid == true ? false : true,
      title: Text('Sendbird Sample', style: TextStyle(color: Colors.black)),
      actions: [],
      centerTitle: true,
    );
  }

  Widget body(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 100),
        child: Column(
          children: [
            Container(
                width: 50,
                height: 50,
                child: Image(
                  image: AssetImage('assets/logoSendbird@3x.png'),
                  fit: BoxFit.scaleDown,
                )),
            SizedBox(height: 20),
            Text('Sendbird Sample',
                style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 40),
            TextField(
              controller: appIdController,
              onChanged: (value) {
                setState(() {
                  enableSignInButton = shouldEnableSignInButton();
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'App Id',
                  filled: true,
                  fillColor: Colors.grey[200],
                  suffixIcon: IconButton(
                    onPressed: () {
                      appIdController.clear();
                    },
                    icon: Icon(Icons.clear),
                  )),
            ),
            SizedBox(height: 10),
            TextField(
              controller: userIdController,
              onChanged: (value) {
                setState(() {
                  print('app id field changed state to: $value');
                  enableSignInButton = shouldEnableSignInButton();
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'User Id',
                  filled: true,
                  fillColor: Colors.grey[200],
                  suffixIcon: IconButton(
                    onPressed: () {
                      userIdController.clear();
                    },
                    icon: Icon(Icons.clear),
                  )),
            ),
            SizedBox(height: 30),
            FractionallySizedBox(
              widthFactor: 1,
              child: _signInButton(context, enableSignInButton),
            )
          ],
        ));
  }

  Widget _signInButton(BuildContext context, bool enabled) {
    if (enabled == false) {
      return FlatButton(
        height: 50,
        color: Colors.grey,
        textColor: Colors.white,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        onPressed: () {},
        child: Text(
          "Sign In",
          style: TextStyle(fontSize: 20.0),
        ),
      );
    }
    return FlatButton(
      height: 50,
      color: Theme.of(context).buttonColor,
      textColor: Colors.white,
      disabledColor: Colors.grey,
      disabledTextColor: Colors.black,
      onPressed: () {
        // Login with Sendbird
        connect(appIdController.text, userIdController.text).then((user) {
          Navigator.pushNamed(context, '/channel_list');
        }).catchError((error) {
          print('login_view.dart: _signInButton: ERROR: $error');
          return showDialog<void>(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: RichText(
                    textAlign: TextAlign.left,
                    softWrap: true,
                    text: TextSpan(
                      text: 'Login Failed:  ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Check connectivity and App Id',
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)),
                      ],
                    ),
                  ),
                  // title: new Text("Login Failed: Check connectivity and App Id",
                  //     style: TextStyle(fontSize: 18)),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15)),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("OK",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      textColor: Theme.of(context).buttonColor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
        });
      },
      child: Text(
        "Sign In",
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Future<sb.User> connect(String appId, String userId) async {
    try {
      final sendbird = sb.SendbirdSdk(appId: appId);
      final user = await sendbird.connect(userId);
      return user;
    } catch (e) {
      print('login_view: connect: ERROR: $e');
      throw e;
    }
  }
}
