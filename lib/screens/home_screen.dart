import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/firebase_related/firebase_stuff.dart';
import 'package:skype_clone/utils/app_variables.dart';

import 'home_screen_pageviews/chat_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  FirebaseRepo _firebaseRepo = FirebaseRepo();

  PageController pageController;
  int _page = 0;

  @override
  initState() {
    super.initState();
    pageController = PageController();
  }

  void onPageChanged(newPageNum) {
    setState(() {
      _page = newPageNum;
    });
  }

  Widget build(BuildContext context) {
    double _labelFontSize = 10;
    return Scaffold(
      backgroundColor: AppVariables.blackColor,
      body: PageView(
        children: <Widget>[
         Container(child: ChatListScreen(),),
          Center(
            child: Text(
              "Call Logs",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Center(
            child: Text(
              "Contact Screen",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: CupertinoTabBar(
            backgroundColor: AppVariables.blackColor,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.chat,
                      color: _page == 0
                          ? AppVariables.lightBlueColor
                          : AppVariables.greyColor),
                  title: Text(
                    "Chat",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: _page == 0
                            ? AppVariables.lightBlueColor
                            : AppVariables.greyColor),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.call,
                      color: _page == 1
                          ? AppVariables.lightBlueColor
                          : AppVariables.greyColor),
                  title: Text(
                    "Calls",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: _page == 1
                            ? AppVariables.lightBlueColor
                            : AppVariables.greyColor),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.contact_phone,
                      color: _page == 2
                          ? AppVariables.lightBlueColor
                          : AppVariables.greyColor),
                  title: Text(
                    "Contacts",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: _page == 2
                            ? AppVariables.lightBlueColor
                            : AppVariables.greyColor),
                  ))
            ],
            currentIndex: _page,
            onTap: (int page) => pageController.jumpToPage(page),
          ),
        ),
      ),
    );
  }
}
