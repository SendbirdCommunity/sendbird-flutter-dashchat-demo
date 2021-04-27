import 'dart:async';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart' as sb;

class LoginView extends StatefulWidget {
  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final appIdController =
      TextEditingController(text: "YOUR_APPLICATION_ID_HERE");
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
      return TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
            foregroundColor:
                MaterialStateProperty.all<Color>(Colors.grey[300])),
        onPressed: () {},
        child: Text(
          "Sign In",
          style: TextStyle(fontSize: 20.0),
        ),
      );
    }
    return TextButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Theme.of(context).buttonColor),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15)),
                  actions: <Widget>[
                    new TextButton(
                      child: new Text("OK",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).buttonColor)),
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
