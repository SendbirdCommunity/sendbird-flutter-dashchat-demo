import 'dart:async';

import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:sendbirdsdk/sendbirdsdk.dart' as sb;

class LoginView extends StatelessWidget {
  final appIdController =
      TextEditingController(text: "7A493E5B-B92F-4D01-AD41-7F568AA2AECA");
  final userIdController = TextEditingController();

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
                width: 70,
                height: 70,
                child: Image(
                  image: AssetImage('assets/logoSendbird@3x.png'),
                  fit: BoxFit.scaleDown,
                )),
            Text('Sendbird Sample',
                style: Theme.of(context).textTheme.headline6),
            TextField(
              controller: appIdController,
              decoration: InputDecoration(
                  labelText: 'App Id',
                  suffixIcon: IconButton(
                    onPressed: () {
                      appIdController.clear();
                    },
                    icon: Icon(Icons.clear),
                  )),
            ),
            TextField(
              controller: userIdController,
              decoration: InputDecoration(
                  labelText: 'User Id',
                  suffixIcon: IconButton(
                    onPressed: () {
                      userIdController.clear();
                    },
                    icon: Icon(Icons.clear),
                  )),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: FlatButton(
                color: Theme.of(context).buttonColor,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                onPressed: () {
                  // Login with Sendbird
                  connect(appIdController.text, userIdController.text)
                      .then((user) {
                    Navigator.pushNamed(context, '/channel_list');
                  }).catchError((error) {
                    return showDialog<void>(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text("Login Error: $error"),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15)),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("Ok"),
                                textColor: Colors.greenAccent,
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
              ),
            )
          ],
        ));
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
