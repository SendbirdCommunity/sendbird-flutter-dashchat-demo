import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:sendbirdsdk/sendbirdsdk.dart';

class ChannelListView extends StatelessWidget {
  final SendbirdSdk sendbird = SendbirdSdk();

  Future<void> test() async {
    try {
      final query = GroupChannelListQuery()
        ..includeEmptyChannel = true
        ..memberStateFilter = MemberStateFilter.joined
        ..order = GroupChannelListOrder.latestLastMessage
        ..limit = 15;
      final result = await query.loadNext();
      print('channel_list_view: test: result: $result');
    } catch (e) {
      print('channel_list_view: ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('channel_list_view: user: $user');
    test();
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
      ],
    );
  }
}
