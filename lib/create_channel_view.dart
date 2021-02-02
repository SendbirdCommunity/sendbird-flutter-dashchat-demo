import 'package:flutter/material.dart';
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
      leading: BackButton(color: Theme.of(context).buttonColor),
      toolbarHeight: 65,
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading:
          UniversalPlatform.isAndroid == true ? false : true,
      title: Text('Create Channel View', style: TextStyle(color: Colors.black)),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert),
          color: Theme.of(context).buttonColor,
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
                  tileColor: Colors.white,
                  title: Text(
                      selection.user.nickname.isEmpty
                          ? selection.user.userId
                          : selection.user.nickname,
                      style: TextStyle(color: Colors.black)),
                  controlAffinity: ListTileControlAffinity.platform,
                  value: SendbirdSdk().getCurrentUser().userId ==
                          selection.user.userId ||
                      selection.isSelected,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (bool value) {
                    //Display chat view
                    setState(() {
                      selection.isSelected = !selection.isSelected;
                    });
                  },
                  // TODO: get placeholder outside of avatar
                  secondary: selection.user.profileUrl.isEmpty
                      ? CircleAvatar(
                          child: Text(
                          selection.user.nickname.isEmpty
                              ? selection.user.userId.substring(0, 1)
                              : selection.user.nickname.substring(0, 1),
                        ))
                      : CircleAvatar(
                          backgroundImage:
                              NetworkImage(selection.user.profileUrl),
                        ),
                );
              }),
        ),
        Center(
          child: FlatButton(
            color: Theme.of(context).buttonColor,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(8.0),
            splashColor: Theme.of(context).primaryColor,
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
