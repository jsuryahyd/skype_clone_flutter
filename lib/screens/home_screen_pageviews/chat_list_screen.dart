import 'package:flutter/material.dart';
import 'package:skype_clone/firebase_related/firebase_stuff.dart';
import 'package:skype_clone/utils/app_variables.dart';
import 'package:skype_clone/widgets/custom_appbar.dart';
import 'package:skype_clone/widgets/custom_tile.dart';

class ChatListScreen extends StatefulWidget {
  @override
  ChatListScreenState createState() {
    return ChatListScreenState();
  }
}

class ChatListScreenState extends State<ChatListScreen> {
  FirebaseRepo _firebaseRepo = FirebaseRepo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppVariables.blackColor,
        appBar: CustomAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            title: userCircleInTitle(),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  print("hello...");
                  Navigator.pushNamed(context, "/search_page");
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ]),
        floatingActionButton: newChatBtn(),
        body: ChatList());
  }

  userCircleInTitle() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppVariables.separatorColor),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              "JS",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppVariables.lightBlueColor,
                  fontSize: 13),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: AppVariables.blackColor),
                shape: BoxShape.circle,
                color: AppVariables.onlineDotColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  newChatBtn() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          gradient: AppVariables.fabGradient, shape: BoxShape.circle),
      child: Icon(Icons.edit),
    );
  }
}

class ChatList extends StatefulWidget {
  @override
  ChatListState createState() {
    return ChatListState();
  }
}

class ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
            return CustomTile(
              leading: leadingImage(
                  "https://yt3.ggpht.com/a/AGF-l7_zT8BuWwHTymaQaBptCy7WrsOD72gYGp-puw=s900-c-k-c0xffffffff-no-rj-mo"),
              title: Text("Jaya Surya",
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.white,
                  )),
              subTitle: Text("Hello,",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  )),
              isMini: false,
            );
          }),
    );
  }

  leadingImage(imgLink) {
    return Container(
      constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            maxRadius: 30,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(imgLink),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 13,
              width: 13,
              decoration: BoxDecoration(
                  color: AppVariables.onlineDotColor,
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: AppVariables.blackColor)),
            ),
          )
        ],
      ),
    );
  }
}
