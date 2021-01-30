import 'dart:async';

import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:sendbirdsdk/sendbirdsdk.dart' as sb;

class LoginView extends StatelessWidget {
  final appIdController =
      TextEditingController(text: "7A493E5B-B92F-4D01-AD41-7F568AA2AECA");
  final userIdController = TextEditingController();
  final nicknameController = TextEditingController();
  final profileUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: navigationBar(),
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
      title: Text('Login', style: TextStyle(color: Colors.black)),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert),
          color: Colors.black,
          onPressed: () {},
        )
      ],
      centerTitle: true,
    );
  }

  Widget body(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: appIdController,
          decoration: InputDecoration(
            icon: Icon(Icons.account_circle),
            labelText: 'App Id',
          ),
        ),
        TextField(
          controller: userIdController,
          decoration: InputDecoration(
            icon: Icon(Icons.account_circle),
            labelText: 'User Id',
          ),
        ),
        TextField(
          controller: nicknameController,
          decoration: InputDecoration(
            icon: Icon(Icons.account_circle),
            labelText: 'Nickname',
          ),
        ),
        TextField(
          controller: profileUrlController,
          decoration: InputDecoration(
            icon: Icon(Icons.account_circle),
            labelText: 'Profile Image Url',
          ),
        ),
        Center(
          child: FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.blueAccent,
            onPressed: () {
              // Login with Sendbird
              connect(appIdController.text, userIdController.text,
                      nicknameController.text, profileUrlController.text)
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
              "Connect",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        )
      ],
    );
  }

  Future<dynamic> connect(
      String appId, String userId, String nickname, String profileUrl) async {
    try {
      final sendbird = sb.SendbirdSdk(appId: appId);
      final user = await sendbird.connect(userId);
      if (nickname != null && user.nickname != nickname) {
        final imageInfo = sb.ImageInfo.fromUrl(url: profileUrl);
        await sendbird.updateCurrentUserInfo(
            nickname: nickname, imageInfo: imageInfo, preferredLanguages: []);
      }
      return user;
    } catch (error) {
      print('login_view: connect: ERROR: $error');
      throw error;
    }
  }
}
