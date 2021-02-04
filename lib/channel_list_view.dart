import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:sendbirdsdk/sendbirdsdk.dart';
import 'group_channel_view.dart';
import 'package:intl/intl.dart';

class ChannelListView extends StatefulWidget {
  @override
  _ChannelListViewState createState() => _ChannelListViewState();
}

class _ChannelListViewState extends State<ChannelListView> {
  List<GroupChannel> groupChannels = [];

  Future<void> updateGroupChannels() async {
    List<GroupChannel> newChannels = await getGroupChannels();
    if (newChannels == this.groupChannels) {
      return;
    }
    setState(() {
      this.groupChannels = newChannels;
    });
  }

  Future<List<GroupChannel>> getGroupChannels() async {
    try {
      final query = GroupChannelListQuery()
        // ..includeEmptyChannel = true
        // ..memberStateFilter = MemberStateFilter.joined
        // ..order = GroupChannelListOrder.latestLastMessage
        ..limit = 15;
      return await query.loadNext();
    } catch (e) {
      print('channel_list_view: getGroupChannel: ERROR: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    updateGroupChannels();
  }

  @override
  Widget build(BuildContext context) {
    print('channel_list_view: groupChannels: $groupChannels');
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: navigationBar(),
      body: body(context),
    );
  }

  Widget navigationBar() {
    return AppBar(
      leading: BackButton(color: Theme.of(context).primaryColor),
      toolbarHeight: 65,
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading:
          UniversalPlatform.isAndroid == true ? false : true,
      title: Text('Channels', style: TextStyle(color: Colors.black)),
      actions: [
        RawMaterialButton(
            padding: EdgeInsets.all(18.0),
            onPressed: () {
              Navigator.pushNamed(context, '/create_channel');
            },
            shape: CircleBorder(),
            child: Image.asset("assets/iconCreate@3x.png")),
      ],
      centerTitle: true,
    );
  }

  String titleFrom(GroupChannel channel, User currentUser) {
    // List of channel member names, excluding the current user
    List<String> namesList = [
      for (final member in channel.members)
        if (member.userId != currentUser.userId) member.nickname
    ];
    return namesList.join(", ");
  }

  Widget avatarsFrom(GroupChannel channel, User currentUser) {
    // Generate a channel image from avatars of users, excluding current user
    return Container(
      width: 40,
      height: 40,
      child: RawMaterialButton(
        shape: CircleBorder(),
        clipBehavior: Clip.hardEdge,
        onPressed: () {},
        child: GridView.count(
            crossAxisCount: (channel.memberCount / 2).round(),
            children: [
              for (final member in channel.members)
                if (member.userId != currentUser.userId &&
                    member.profileUrl != null)
                  Image(image: NetworkImage(member.profileUrl))
            ]),
      ),
    );
  }

  Widget body(BuildContext context) {
    return Column(
      children: [
        // TODO: ListView here
        groupChannels.length != 0
            ? Expanded(
                child: ListView.builder(
                    itemCount: groupChannels.length,
                    itemBuilder: (context, index) {
                      GroupChannel channel = groupChannels[index];
                      DateTime lastMessageDate =
                          DateTime.fromMillisecondsSinceEpoch(
                              channel?.lastMessage?.createdAt ?? 0);
                      String lastMessageDateString =
                          DateFormat("E").format(lastMessageDate);
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                        child: ListTile(
                          leading: avatarsFrom(
                              channel, SendbirdSdk().getCurrentUser()),
                          tileColor: Colors.white,
                          title: Text(
                              titleFrom(
                                  channel, SendbirdSdk().getCurrentUser()),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text(channel?.lastMessage?.message ?? ''),
                          onTap: () {
                            gotoChannel(channel.channelUrl);
                          },
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(lastMessageDateString),
                              ConstrainedBox(
                                constraints:
                                    BoxConstraints(maxHeight: 20, maxWidth: 40),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  enabled: false,
                                  enableInteractiveSelection: false,
                                  decoration: channel.unreadMessageCount == 0
                                      ? null
                                      : new InputDecoration(
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(20.0),
                                            ),
                                          ),
                                          filled: true,
                                          hintStyle: new TextStyle(
                                              color: Colors.white, fontSize: 8),
                                          hintText:
                                              "${channel.unreadMessageCount}",
                                          fillColor: Color(0xff742DDD)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }))
            : Center(child: CircularProgressIndicator())
      ],
    );
  }

  void gotoChannel(String channelUrl) {
    GroupChannel.getChannel(channelUrl).then((channel) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GroupChannelView(groupChannel: channel),
        ),
      );
    }).catchError((e) {
      //handle error
      print('channel_list_view: gotoChannel: ERROR: $e');
    });
  }
}
