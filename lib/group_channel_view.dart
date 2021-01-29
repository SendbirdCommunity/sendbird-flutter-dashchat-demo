import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:sendbirdsdk/sendbirdsdk.dart';
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';

class GroupChannelView extends StatefulWidget {
  GroupChannel groupChannel;

  GroupChannelView({Key key, @required this.groupChannel}) : super(key: key);

  @override
  _GroupChannelViewState createState() => _GroupChannelViewState();
}

class _GroupChannelViewState extends State<GroupChannelView>
    with ChannelEventHandler {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  List<BaseMessage> _messages = [];
  @override
  void initState() {
    super.initState();
    getMessages(widget.groupChannel);
    SendbirdSdk().addChannelHandler(widget.groupChannel.channelUrl, this);
  }

  // Sendbird Channel Event Handling
  @override
  onMessageReceived(channel, message) {
    setState(() {
      _messages.add(message);
    });
  }

  // TODO: Add other handler methods

  void onSend(ChatMessage message) async {
    widget.groupChannel.sendUserMessage(message.text);
    updateMessages();
  }

  Future<void> updateMessages() {
    getMessages(widget.groupChannel);
  }

  Future<void> getMessages(GroupChannel channel) async {
    try {
      List<BaseMessage> messages = await channel.getMessagesByTimestamp(
          DateTime.now().millisecondsSinceEpoch * 1000, MessageListParams());
      setState(() {
        _messages = messages;
      });
    } catch (e) {
      print('group_channel_view.dart: getMessages: ERROR: $e');
    }
  }

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
    // ChatUser user = ChatUser(name: "Alpha");
    ChatUser user = asDashChatUser(SendbirdSdk().getCurrentUser());
    return Column(children: [
      Expanded(
        child: DashChat(
          showUserAvatar: true,
          onPressAvatar: (ChatUser user) {
            // If wanting to trigger anything from here
          },
          key: Key(widget.groupChannel.channelUrl),
          onSend: (ChatMessage message) async {
            onSend(message);
          },
          sendOnEnter: true,
          textInputAction: TextInputAction.send,
          user: user,
          messages: asDashChatMessages(_messages),
          inputDecoration:
              InputDecoration.collapsed(hintText: "Type a message here..."),
        ),
      ),
      // Spacer for devices with no home button
      Container(
        height: 40,
      ),
    ]);
  }

  List<ChatMessage> asDashChatMessages(List<BaseMessage> messages) {
    List<ChatMessage> result = [];
    messages.forEach((message) {
      User user = message.sender;
      result.add(ChatMessage(
          text: message.message,
          user: ChatUser(
              name: user.nickname, uid: user.userId, avatar: user.profileUrl)));
    });
    return result;
  }

  ChatUser asDashChatUser(User user) {
    return ChatUser(
        name: user.nickname, uid: user.userId, avatar: user.profileUrl);
  }
}
