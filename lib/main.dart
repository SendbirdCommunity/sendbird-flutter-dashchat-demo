import 'package:flutter/material.dart';
import 'login_view.dart';
import 'channel_list_view.dart';
import 'create_channel_view.dart';
import 'channel_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String initialRoute() {
    // TODO: Switch initial view between login or channel list, depending on prior
    // login state.
    return "/login";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: initialRoute(),
        routes: <String, WidgetBuilder>{
          '/login': (context) => LoginView(),
          '/channel_list': (context) => ChannelListView(),
          '/create_channel': (context) => CreateChannelView(),
          '/channel': (context) => ChannelView(),
        });
  }
}
