import 'package:flutter/material.dart';
import 'login_view.dart';
import 'channel_list_view.dart';
import 'create_channel_view.dart';
import 'channel_view.dart';
import 'user_model.dart' as model;
import 'package:sendbirdsdk/sendbirdsdk.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SendbirdSdk sendbird =
      SendbirdSdk(appId: "D56438AE-B4DB-4DC9-B440-E032D7B35CEB");

  String initialRoute() {
    // TODO: Switch initial view between login or channel list, depending on prior
    // login state.
    return "/login";
  }

  @override
  Widget build(BuildContext context) {
    final model.User currentUser = model.User();
    // final SendbirdSdk sendbird =
    //     SendbirdSdk(appId: "D56438AE-B4DB-4DC9-B440-E032D7B35CEB");

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: initialRoute(),
        routes: <String, WidgetBuilder>{
          // '/login': (context) => LoginView(user: currentUser),
          '/login': (context) =>
              LoginView(user: currentUser, sendbird: sendbird),
          '/channel_list': (context) => ChannelListView(user: currentUser),
          '/create_channel': (context) => CreateChannelView(),
          '/channel': (context) => ChannelView(),
        });
  }
}
