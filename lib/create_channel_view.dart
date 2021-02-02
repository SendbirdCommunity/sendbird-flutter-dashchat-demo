import 'package:flutter/material.dart';
import 'package:flutter_demo/group_channel_view.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:sendbirdsdk/sendbirdsdk.dart';

class CreateChannelView extends StatefulWidget {
  @override
  _CreateChannelViewState createState() => _CreateChannelViewState();
}

class UserSelection {
  bool isSelected = false;
  User user;
  UserSelection(this.user);
  @override
  String toString() {
    return "UserSelection: {isSelected: $isSelected, user: $user}";
  }
}

List<UserSelection> selectedUsersFrom(List<User> users) {
  List<UserSelection> result = [];
  users.forEach((user) {
    result.add(new UserSelection(user));
  });
  return result;
}

class _CreateChannelViewState extends State<CreateChannelView> {
  // List<User> users = [];
  List<UserSelection> selections = [];

  Future<void> updateUsers() async {
    List<UserSelection> newSelections = await getUsers();
    if (newSelections == this.selections) {
      return;
    }
    setState(() {
      this.selections = newSelections;
    });
  }

  Future<List<UserSelection>> getUsers() async {
    try {
      final query = ApplicationUserListQuery();
      List<User> users = await query.loadNext();
      return selectedUsersFrom(users);
    } catch (e) {
      print('create_channel_view: getUsers: ERROR: $e');
      return [];
    }
  }

  Future<GroupChannel> createChannel() async {
    try {
      final userIds = this
          .selections
          .where((selection) => selection.isSelected)
          .map((selection) {
        return selection.user.userId;
      }).toList();
      final params = GroupChannelParams()..userIds = userIds;
      final channel = await GroupChannel.createChannel(params);
      return channel;
    } catch (e) {
      print('create_channel_view: createChannel: ERROR: $e');
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();
    updateUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
      title: Text('Create Channel View', style: TextStyle(color: Colors.black)),
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
    return Column(
      children: [
        // TODO: ListView here
        Expanded(
          child: ListView.builder(
              itemCount: selections.length,
              itemBuilder: (context, index) {
                UserSelection selection = selections[index];
                User user = selection.user;

                return CheckboxListTile(
                    tileColor: Colors.purple,
                    title: Text("${selection.user.nickname}",
                        style: TextStyle(color: Colors.white)),
                    controlAffinity: ListTileControlAffinity.platform,
                    value: selection.isSelected,
                    onChanged: (bool value) {
                      //Display chat view
                      setState(() {
                        selection.isSelected = !selection.isSelected;
                      });
                    });
              }),
        ),
        Center(
          child: FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.blueAccent,
            onPressed: () {
              createChannel().then((channel) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GroupChannelView(groupChannel: channel),
                  ),
                );
              }).catchError((error) {
                return showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: new Text("Channel Creation Error: $error"),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15)),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("Ok"),
                            textColor: Colors.greenAccent,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              });
            },
            child: Text(
              "Create",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        )
      ],
    );
  }
}
