import 'package:firebase_auth/firebase_auth.dart';
import 'package:myflutter/models/user.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
// create user object
  User _userFromFirebaseUser(FirebaseUser user) {

    return user != null ? User(uid:  user.uid) : null;
  }
  //Sign in Anon

  Future signInAnon () async {
    try {
      AuthResult result =  await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);

    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //Sign in with email and password

  //register with email and pasword

  //sign out
}