import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:skype_clone/firebase_related/firebase_stuff.dart';
import 'package:skype_clone/models/User.dart';
import 'package:skype_clone/models/thread.dart';
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
  FirebaseUser currentUser;
  List<User> userList;
  List<Thread> threads;
  String _searchQuery = "";
  @override
  void initState() {
    super.initState();
    _firebaseRepo.getLoggedInUser().then((FirebaseUser loggedInUser) {
      currentUser = loggedInUser;
      _firebaseRepo.fetchAllUsers(loggedInUser.uid).then((value) {
        userList = value;

        _firebaseRepo.fetchUserThreads(loggedInUser.uid).then((val) {
          print("value here!!");
          print(val);

          threads = val.length == 0 ? [] : val;
          threads.forEach((Thread thread) {
            thread.users = thread.userUids
                .where((uid) => uid != loggedInUser.uid)
                .toList()
                .map((uid) {
              return userList.firstWhere((user) => user.uid == uid,
                  orElse: () => null);
            }).toList();
          });
        });
      });
    });
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

  getFilteredThreads(searchInput) {
    if (this.userList == null) return [];
    // var users = this.userList.where((User user) {
    //   var userName = user.userName.toLowerCase();
    //   var name = user.name.toLowerCase();
    //   bool matches =
    //       userName.contains(searchInput) || name.contains(searchInput);

    //   return matches;
    // }).toList();
    var users = [];
    for (var u in userList) {
      var userName = u.userName.toLowerCase();
      var name = u.name.toLowerCase();
      bool matches =
          userName.contains(searchInput) || name.contains(searchInput);

      if (matches) users.add(u);
    }
    var suggestions = [];
    //users not one-one
    var usersWithoutThread =
        threads.length == 0 ? users : []; //if no threads=>no looping. so,

    var userIdsWithThread = new Set();
    //threads
    suggestions = suggestions +
        threads.where((element) {
          if (element.type != null) {
            return false;
          }
          for (var i in users) {
            if (element.hasUserWithId(i.uid)) {
              userIdsWithThread.add(i.uid);
              return true;
            }
          }
          return false;
        }).toList();

    //one-one
    suggestions = suggestions +
        threads.where((element) {
          if (element.type != "one-to-one") {
            return false;
          }
          for (var i in users) {
            if (element.hasUserWithId(i.uid)) {
              userIdsWithThread.add(i.uid);
              return true;
            }
          }
          return false;
        }).toList();

    for (var us in users) {
      if (userIdsWithThread.firstWhere((element) => element == us.uid,
              orElse: () => null) ==
          null) {
        usersWithoutThread.add(us);
      }
    }
    suggestions = suggestions + usersWithoutThread;
    return suggestions;
  }

  searchResults(String searchInput) {
    if (userList == null) return Container();
    var suggestions =
        searchInput.isEmpty ? [] : getFilteredThreads(searchInput);
    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          var suggestion = suggestions[index];
          String email;
          var userName;
          var profilePicUrl;
          if (suggestion is User) {
            email = suggestion.email;

            userName = resultTitle(suggestion);

            profilePicUrl = suggestion.profilePhoto;
          } else if (suggestion is Thread && suggestion.type == "one-to-one") {
            var threadReceiver =
                suggestion.getOtherUserInOneOneThread(currentUser.uid);
            email = suggestion.users
                .map((User user) => user.email)
                .toList()
                .join(", ");
            userName = resultTitle(suggestion);
            profilePicUrl = threadReceiver.profilePhoto;
          } else {
            email = "";
            userName = resultTitle(suggestion);
            profilePicUrl = "";
          }

          return CustomTile(
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return ChatScreen(
                      suggestions[index] is User ? null : suggestions[index],
                      receiver: suggestions[index] is User
                          ? suggestions[index]
                          : null);
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

  resultTitle(suggestion) {
    User user;
    if (suggestion is User) {
      user = suggestion;
    }

    if (suggestion is Thread && suggestion.type == "one-to-one") {
      user = suggestion.getOtherUserInOneOneThread(currentUser.uid);
    } else if (suggestion is Thread && suggestion.type != "one-to-one") {
      return suggestion.userNames().join(",");
    }

    if (user == null)
      return "";
    else
      return user.userName + (user.name != null ? " (" + user.name + ")" : "");
  }
}
