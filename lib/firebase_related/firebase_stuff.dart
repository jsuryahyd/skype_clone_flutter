import 'package:firebase_auth/firebase_auth.dart';
import 'package:skype_clone/firebase_related/firebase_auth_methods.dart';
import 'package:skype_clone/models/User.dart';

class FirebaseRepo {
  FirebaseMethods _methods = new FirebaseMethods();

  Future<FirebaseUser> getLoggedInUser() async {
    return _methods.getLoggedInUser();
  }

  Future<FirebaseUser> signIn() async {
    return _methods.signIn();
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    return _methods.authenticateUser(user);
  }

  Future<void> addUserToDb(FirebaseUser fUser) async {
    _methods.addUserToDb(fUser);
  }

  Future<void> signOut()async{
    return _methods.signOut();
  }

  Future<List<User>> fetchAllUsers(String selfId)async{
      return _methods.fetchAllUsers(selfId);
  }
}

