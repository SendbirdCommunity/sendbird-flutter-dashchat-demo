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
      appBar: navigationBar(widget.groupChannel),
      body: body(context),
    );
  }

  String titleFrom(GroupChannel channel, User currentUser) {
    String currentUserName = SendbirdSdk().getCurrentUser().nickname;
    List<String> namesList = [
      for (final member in channel.members) member.nickname
    ];
    namesList.remove(currentUserName);
    return namesList.join(", ");
  }

  // TODO: This returns a blank widget for some reason
  Widget avatarsFrom(GroupChannel channel, User currentUser) {
    // Generate a channel image from avatars of users, excluding current user
    return Container(
      width: 40,
      height: 40,
      child: RawMaterialButton(
        // fillColor: Colors.red,
        shape: CircleBorder(),
        clipBehavior: Clip.hardEdge,
        onPressed: () {},
        child: GridView.count(
            crossAxisCount: (channel.memberCount / 2).round(),
            children: [
              for (final member in channel.members)
                if (member.userId != currentUser.userId &&
                    member.profileUrl != null)
                  Image(
                    image: NetworkImage(member.profileUrl),
                    // errorBuilder: (context, e, st) {
                    //   print('group_channel_view: ERROR: $e, STACKTRACE: $st');
                    //   return Image.asset("assets/ios-marketing.png");
                    // },
                  )
            ]),
      ),
    );
  }

  Widget navigationBar(GroupChannel channel) {
    return AppBar(
      leading: BackButton(color: Theme.of(context).buttonColor),
      toolbarHeight: 65,
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading:
          UniversalPlatform.isAndroid == true ? false : true,
      title: ListTile(
        // leading: avatarsFrom(channel, SendbirdSdk().getCurrentUser()),
        tileColor: Colors.white,
        title: Text(titleFrom(channel, SendbirdSdk().getCurrentUser()),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      actions: [
        // TODO: Add a channel info page
        // IconButton(
        //   icon: Icon(Icons.info_outline_rounded),
        //   color: Theme.of(context).buttonColor,
        //   onPressed: () {},
        // )
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
          dateFormat: DateFormat("E, MMM d"),
          // timeFormat: DateFormat('HH:mm'),
          timeFormat: DateFormat.jm(),
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
          messageDecorationBuilder: (ChatMessage msg, bool isUser) {
            return BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: isUser
                  ? Theme.of(context).primaryColor
                  : Colors.grey[200], // example
            );
          },
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
          createdAt: DateTime.fromMillisecondsSinceEpoch(message.createdAt),
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
