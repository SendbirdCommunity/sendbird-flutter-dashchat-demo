import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:sendbirdsdk/sendbirdsdk.dart';
import 'user_model.dart' as model;

class CreateChannelView extends StatefulWidget {
  final SendbirdSdk sendbird;

  CreateChannelView({Key key, @required this.sendbird}) : super(key: key);
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
                if (user == null) {
                  print('create_channel_view: body: selection: $selection');
                  return ListTile(title: Text('<User with no nickname>'));
                }
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
              // TODO:
              // Create channel with just selected users
              Navigator.pushNamed(context, '/channel');
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
