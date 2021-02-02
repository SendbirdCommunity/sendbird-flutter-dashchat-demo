import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:sendbirdsdk/sendbirdsdk.dart';
import 'group_channel_view.dart';

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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/create_channel');
          },
          child: Icon(Icons.add_circle),
          backgroundColor: Theme.of(context).buttonColor,
        ));
  }

  Widget navigationBar() {
    return AppBar(
      leading: BackButton(color: Theme.of(context).primaryColor),
      toolbarHeight: 65,
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading:
          UniversalPlatform.isAndroid == true ? false : true,
      title: Text('Channel List View', style: TextStyle(color: Colors.black)),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert),
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
        groupChannels.length != 0
            ? Expanded(
                child: ListView.builder(
                    itemCount: groupChannels.length,
                    itemBuilder: (context, index) {
                      GroupChannel channel = groupChannels[index];
                      String name = [
                        for (final member in channel.members) member.nickname
                      ].toString();
                      return ListTile(
                          tileColor: Colors.white,
                          title: Text(channel?.name ?? channel.channelUrl),
                          trailing: Text(channel.memberCount.toString()),
                          onTap: () {
                            gotoChannel(channel.channelUrl);
                          });
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
