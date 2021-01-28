import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:sendbirdsdk/sendbirdsdk.dart';
import 'user_model.dart' as model;

class CreateChannelView extends StatelessWidget {
  final SendbirdSdk sendbird;

  CreateChannelView({Key key, @required this.sendbird}) : super(key: key);

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
      leading: BackButton(color: Color(0xff742DDD)),
      toolbarHeight: 65,
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading:
          UniversalPlatform.isAndroid == true ? false : true,
      title: Text('Create Channel View', style: TextStyle(color: Colors.black)),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert),
          color: Color(0xff742DDD),
          onPressed: () {},
        )
      ],
      centerTitle: true,
    );
  }

  Widget body(BuildContext context) {
    return Column(
      children: [
        // TODO: ListView here
        Center(
          child: FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.blueAccent,
            onPressed: () {
              Navigator.pushNamed(context, '/channel');
            },
            child: Text(
              "Create",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        )
      ],
    );
  }
}
