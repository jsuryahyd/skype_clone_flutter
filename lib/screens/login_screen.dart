import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skype_clone/firebase_related/firebase_stuff.dart';
import 'package:skype_clone/screens/home_screen.dart';
import 'package:skype_clone/utils/app_variables.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  FirebaseRepo _fb = new FirebaseRepo();

  bool isLoginProgress = false;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppVariables.blackColor,
      body: Center(child: loginButton(context)),
    );
  }

  Widget loginButton(context) {
    return Shimmer.fromColors(
     baseColor: Colors.white,
      highlightColor: AppVariables.senderColor,
      child: FlatButton(
        
        padding: EdgeInsets.all(35),
        child: Text(
         isLoginProgress ? "LOGGING IN" : "LOGIN",
          style: TextStyle(
              fontSize:isLoginProgress ? 28: 35, fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
        onPressed: () => tryLogin(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),);
  }

  tryLogin(BuildContext context) {
    setState(() {
      isLoginProgress = true;
    });
    _fb.signIn().then((user) {
      if (user != null) {
        authenticateUser(user, context);
      } else {
        print("user is null *****");
      }
    });
  }

  authenticateUser(FirebaseUser user, BuildContext context) {
    _fb.authenticateUser(user).then((isNew) {
      if (isNew) {
        _fb.addUserToDb(user).then((val) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }
}
