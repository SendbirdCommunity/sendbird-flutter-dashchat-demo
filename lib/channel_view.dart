import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:sendbirdsdk/sendbirdsdk.dart';
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';

class ChannelView extends StatefulWidget {
  final SendbirdSdk sendbird = SendbirdSdk();

  ChannelView({Key key}) : super(key: key);

  @override
  _ChannelViewState createState() => _ChannelViewState();
}

class _ChannelViewState extends State<ChannelView> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  @override
  void initState() {
    super.initState();
  }

  void onSend(ChatMessage message) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      title: Text('Channel List View', style: TextStyle(color: Colors.black)),
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
    // TODO: Call Dash chat here
    return Column(
      children: [],
    );
  }
}
