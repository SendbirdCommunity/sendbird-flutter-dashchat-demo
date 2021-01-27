import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
// import 'package:sendbirdsdk/sendbirdsdk.dart';
// import 'sendbird_state.dart';
import 'user_model.dart' as model;

class LoginView extends StatelessWidget {
  final model.User user;
  // final SendbirdSdk sendbird;
  final userIdController = TextEditingController();
  final nickNameController = TextEditingController();
  final imageUrlController = TextEditingController();

  LoginView({Key key, @required this.user}) : super(key: key);

  // LoginView({Key key, @required this.user, @required this.sendbird})
  //     : super(key: key);

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
      title: Text('Login View', style: TextStyle(color: Colors.black)),
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
          controller: userIdController,
          decoration: InputDecoration(
            icon: Icon(Icons.account_circle),
            labelText: 'user id',
          ),
        ),
        TextField(
          controller: nickNameController,
          decoration: InputDecoration(
            icon: Icon(Icons.account_circle),
            labelText: 'nickname',
          ),
        ),
        TextField(
          controller: imageUrlController,
          decoration: InputDecoration(
            icon: Icon(Icons.account_circle),
            labelText: 'profile image url',
          ),
        ),
        Center(
          // TODO: TextFields here
          child: FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.blueAccent,
            onPressed: () {
              // Login with Sendbird
              connectSendbird(userIdController.text).then((value) {
                if (value == null) {
                  // Failed connection or login
                  AlertDialog(
                    title: new Text("Login Error"),
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
                  return;
                }

                user.nickname = nickNameController.text;
                user.userId = userIdController.text;
                user.imageUrl = imageUrlController.text;
                Navigator.pushNamed(context, '/channel_list');
              });
            },
            child: Text(
              "Next",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        )
      ],
    );
  }

  Future<dynamic> connectSendbird(String userId) async {
    // return await sendbird.connect(userIdController.text);
    return null;
  }
}
