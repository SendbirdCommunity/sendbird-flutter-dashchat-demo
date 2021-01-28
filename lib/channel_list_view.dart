import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'user_model.dart' as model;
import 'package:sendbirdsdk/sendbirdsdk.dart';

class ChannelListView extends StatefulWidget {
  final model.User user;
  final SendbirdSdk sendbird;

  ChannelListView({Key key, @required this.user, @required this.sendbird})
      : super(key: key);

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
    print('channel_list_view: user: ${widget.user}');
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
          backgroundColor: Colors.green,
        ));
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
                      String channelName = channel.name != ""
                          ? channel.name
                          : "<unnamed_channel>";
                      return ListTile(
                          tileColor: Colors.purple,
                          title: Text(
                              "Name: $channelName Members:${channel.memberCount}",
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            //Display chat view
                            Navigator.pushNamed(context, '/channel');
                          });
                    }))
            : Center(child: CircularProgressIndicator())
      ],
    );
  }
}
