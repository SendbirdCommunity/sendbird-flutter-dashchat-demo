import 'package:flutter/material.dart';
import 'login_view.dart';
import 'channel_list_view.dart';
import 'create_channel_view.dart';
import 'package:sendbirdsdk/sendbirdsdk.dart';

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
        },
        theme: ThemeData(
            fontFamily: "Gellix",
            primaryColor: Color(0xff742DDD),
            buttonColor: Color(0xff742DDD),
            textTheme: TextTheme(
                headline1:
                    TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                headline6:
                    TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold)),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Color(0xff732cdd),
              selectionHandleColor: Color(0xff732cdd),
              selectionColor: Color(0xffD1BAF4),
            )));
  }
}
