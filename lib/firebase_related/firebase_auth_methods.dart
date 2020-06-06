import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skype_clone/models/User.dart';

class FirebaseMethods {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore _firestore = Firestore.instance;

  Future<FirebaseUser> getLoggedInUser() async {
    FirebaseUser currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuth =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _signInAuth.idToken, accessToken: _signInAuth.accessToken);

    AuthResult result = await _auth.signInWithCredential(credential);
    FirebaseUser user = result.user;
    return user;
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await _firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .getDocuments();

    return result.documents.length == 0 ? true : false;
  }

  Future<void> addUserToDb(FirebaseUser fUser) {
    User user = User(
        uid: fUser.uid,
        email: fUser.email,
        name: fUser.displayName,
        profilePhoto: fUser.photoUrl,
        userName: fUser.displayName == null ? fUser.email : fUser.displayName);

    _firestore.collection("users").document(user.uid).setData(user.toMap());
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<List<User>> fetchAllUsers(String selfId) async {
    QuerySnapshot result = await _firestore.collection("users").getDocuments();

    List<User> userList = result.documents
        .where((i) => i.documentID != selfId)
        .toList()
        .map((i) => User.fromMap(i))
        .toList();

    return userList;
  }
}
