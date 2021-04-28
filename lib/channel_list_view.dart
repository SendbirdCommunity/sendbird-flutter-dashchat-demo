import 'package:flutter/material.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'group_channel_view.dart';

class ChannelListView extends StatefulWidget {
  @override
  _ChannelListViewState createState() => _ChannelListViewState();
}

class _ChannelListViewState extends State<ChannelListView>
    with ChannelEventHandler {
  Future<List<GroupChannel>> getGroupChannels() async {
    try {
      final query = GroupChannelListQuery()
        ..includeEmptyChannel = true
        ..order = GroupChannelListOrder.latestLastMessage
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
    SendbirdSdk().addChannelEventHandler('channel_list_view', this);
  }

  @override
  void dispose() {
    SendbirdSdk().removeChannelEventHandler("channel_list_view");
    super.dispose();
  }

  @override
  void onChannelChanged(BaseChannel channel) {
    setState(() {
      // Force the list future builder to rebuild.
    });
  }

  @override
  void onChannelDeleted(String channelUrl, ChannelType channelType) {
    setState(() {
      // Force the list future builder to rebuild.
    });
  }

  @override
  void onUserJoined(GroupChannel channel, User user) {
    setState(() {
      // Force the list future builder to rebuild.
    });
  }

  @override
  void onUserLeaved(GroupChannel channel, User user) {
    setState(() {
      // Force the list future builder to rebuild.
    });
    super.onUserLeaved(channel, user);
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
      automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: BackButton(color: Theme.of(context).primaryColor),
      title: Text(
        'Channels',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        Container(
          width: 60,
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create_channel');
              },
              child: Image.asset("assets/iconCreate@3x.png")),
        ),
      ],
    );
  }

  Widget body(BuildContext context) {
    return FutureBuilder(
      future: getGroupChannels(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false || snapshot.data == null) {
          // Nothing to display yet - good place for a loading indicator
          return Container();
        }
        List<GroupChannel> channels = snapshot.data;
        return ListView.builder(
            itemCount: channels.length,
            itemBuilder: (context, index) {
              GroupChannel channel = channels[index];
              return ListTile(
                // Display all channel members as the title
                title: Text(
                  [for (final member in channel.members) member.nickname]
                      .join(", "),
                ),
                // Display the last message presented
                subtitle: Text(channel?.lastMessage?.message ?? ''),
                onTap: () {
                  gotoChannel(channel.channelUrl);
                },
              );
            });
      },
    );
  }

  void gotoChannel(String channelUrl) {
    GroupChannel.getChannel(channelUrl).then((channel) {
      Navigator.pushNamed(context, '/channel_list');
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
