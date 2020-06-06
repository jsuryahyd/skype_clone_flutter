import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:skype_clone/firebase_related/firebase_stuff.dart';
import 'package:skype_clone/models/User.dart';
import 'package:skype_clone/utils/app_variables.dart';
import 'package:skype_clone/widgets/custom_tile.dart';

import 'chat_screens/ChatScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  SearchScreenState createState() {
    return SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen> {
  TextEditingController searchFieldController = TextEditingController();

  FirebaseRepo _firebaseRepo = FirebaseRepo();
  List<User> userList;

  String _searchQuery = "";
  @override
  void initState() {
    super.initState();
    _firebaseRepo.getLoggedInUser().then((FirebaseUser user) =>
        _firebaseRepo.fetchAllUsers(user.uid).then((value) => setState(() {
              userList = value;
            })));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppVariables.blackColor,
        appBar: _appBar(),
        body: searchResults(_searchQuery));
  }

  _appBar() {
    return GradientAppBar(
      gradient: LinearGradient(
        colors: [
          AppVariables.gradientColorStart,
          AppVariables.gradientColorEnd
        ],
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchFieldController,
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            cursorColor: AppVariables.blackColor,
            autofocus: true,
            style: TextStyle(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    color: Colors.white,
                    onPressed: () {
                      searchFieldController.clear();
                    }),
                hintText: "Search",
                hintStyle: TextStyle(
                  color: Color(0x88ffffff),
                  fontWeight: FontWeight.w500,
                  // fontSize
                )),
          ),
        ),
      ),
    );
  }

  searchResults(String searchInput) {
    if (userList == null) return Container();
    List suggestions = searchInput.isEmpty
        ? []
        : userList.where((User user) {
            var userName = user.userName.toLowerCase();
            var name = user.name.toLowerCase();
            bool matches =
                userName.contains(searchInput) || name.contains(searchInput);
           
            return matches;
          }).toList();
    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          var email = suggestions[index].email;
          var userName = suggestions[index].userName +
              (suggestions[index].name != null
                  ? " (" + suggestions[index].name + ")"
                  : "");
          var profilePicUrl = suggestions[index].profilePhoto;

          return CustomTile(
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return ChatScreen(suggestions[index]);
                }));
              },
              isMini: false,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(profilePicUrl),
                backgroundColor: Colors.greenAccent,
              ),
              title: Text(
                userName,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subTitle: Text(
                email,
                style: TextStyle(color: AppVariables.greyColor),
              ));
        });
  }
}
