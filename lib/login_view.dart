import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

class LoginView extends StatefulWidget {
  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final _appIdController =
      TextEditingController(text: "D56438AE-B4DB-4DC9-B440-E032D7B35CEB");
  // final _appIdController =
  //     TextEditingController(text: "YOUR_APPLICATION_ID_HERE");
  final _userIdController = TextEditingController();
  bool _enableSignInButton = false;

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
      // Disable the back button for Android deployments
      automaticallyImplyLeading: true,
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
              controller: _appIdController,
              onChanged: (value) {
                setState(() {
                  _enableSignInButton = _shouldEnableSignInButton();
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'App Id',
                  filled: true,
                  fillColor: Colors.grey[200],
                  suffixIcon: IconButton(
                    onPressed: () {
                      _appIdController.clear();
                    },
                    icon: Icon(Icons.clear),
                  )),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _userIdController,
              onChanged: (value) {
                setState(() {
                  _enableSignInButton = _shouldEnableSignInButton();
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'User Id',
                  filled: true,
                  fillColor: Colors.grey[200],
                  suffixIcon: IconButton(
                    onPressed: () {
                      _userIdController.clear();
                    },
                    icon: Icon(Icons.clear),
                  )),
            ),
            SizedBox(height: 30),
            FractionallySizedBox(
              widthFactor: 1,
              child: _signInButton(context, _enableSignInButton),
            )
          ],
        ));
  }

  bool _shouldEnableSignInButton() {
    if (_appIdController.text.isEmpty) {
      return false;
    }
    if (_userIdController.text.isEmpty) {
      return false;
    }
    return true;
  }

  Widget _signInButton(BuildContext context, bool enabled) {
    if (enabled == false) {
      // Disable the sign in button if required data not entered
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
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xff742DDD)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
      onPressed: () {
        // Login with Sendbird
        connect(_appIdController.text, _userIdController.text).then((user) {
          Navigator.pushNamed(context, '/channel_list');
        }).catchError((error) {
          print('login_view: _signInButton: ERROR: $error');
        });
      },
      child: Text(
        "Sign In",
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Future<User> connect(String appId, String userId) async {
    // Init Sendbird SDK and connect with current user id
    try {
      final sendbird = SendbirdSdk(appId: appId);
      final user = await sendbird.connect(userId);
      return user;
    } catch (e) {
      print('login_view: connect: ERROR: $e');
      throw e;
    }
  }
}
