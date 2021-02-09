import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:sendbirdsdk/sendbirdsdk.dart';
import 'dart:async';
import 'package:intl/intl.dart';

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
    // SendbirdSdk()
    //     .messageReceiveStream(widget.groupChannel.channelUrl)
    //     .listen((message) {
    //   _messages.add(message);
    // });
    SendbirdSdk().addChannelHandler(widget.groupChannel.channelUrl, this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SendbirdSdk().removeChannelHandler(widget.groupChannel.channelUrl);
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
    widget.groupChannel.sendUserMessageWithText(message.text).then((msg) {
      setState(() {
        _messages.add(msg);
      });
    }).catchError((e) {});
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
    int crossAxisCount = 1;
    if (channel.memberCount > 3) {
      crossAxisCount = 2;
    } else {
      (channel.memberCount / 2).round();
    }
    List<String> imageUrls = [
      for (final member in channel.members) member.profileUrl
    ];
    imageUrls.remove(currentUser.profileUrl);
    return RawMaterialButton(
      shape: CircleBorder(),
      clipBehavior: Clip.hardEdge,
      onPressed: () {},
      child: Container(
        width: 60,
        height: 60,
        child: GridView.count(
            reverse: true,
            crossAxisCount: crossAxisCount,
            physics: NeverScrollableScrollPhysics(),
            children: [
              for (final imageUrl in imageUrls)
                Image(image: NetworkImage(imageUrl), fit: BoxFit.cover)
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
      title: Row(
        children: [
          avatarsFrom(channel, SendbirdSdk().getCurrentUser()),
          Container(
            width: 250,
            child: Text(
              titleFrom(channel, SendbirdSdk().getCurrentUser()),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
        ],
      ),
      // actions: [
      // TODO: Add a channel info page
      // IconButton(
      //   icon: Icon(Icons.info_outline_rounded),
      //   color: Theme.of(context).buttonColor,
      //   onPressed: () {},
      // )
      // ],
      centerTitle: false,
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
    if (messages != null) {
      messages.forEach((message) {
        User user = message.sender;
        result.add(
          ChatMessage(
            createdAt: DateTime.fromMillisecondsSinceEpoch(message.createdAt),
            text: message.message,
            user: ChatUser(
              name: user.nickname,
              uid: user.userId,
              avatar: user.profileUrl,
            ),
          ),
        );
      });
    }
    return result;
  }

  ChatUser asDashChatUser(User user) {
    return ChatUser(
        name: user.nickname, uid: user.userId, avatar: user.profileUrl);
  }
}
