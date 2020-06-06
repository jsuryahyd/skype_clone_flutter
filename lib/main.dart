import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/firebase_related/firebase_stuff.dart';
import 'package:skype_clone/screens/home_screen.dart';
import 'package:skype_clone/screens/login_screen.dart';

import 'screens/search_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseRepo _firebaseRepo = new FirebaseRepo();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skype Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark
      ),
      initialRoute: "/",
      routes: {'/search_page': (context) => SearchScreen()},
      home: FutureBuilder(
          future: _firebaseRepo.getLoggedInUser(),
          builder:
              (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          }),
    );
  }
}
