import 'dart:math';

import 'package:brew/models/user.dart';
import 'package:brew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user){
    return user!= null ?  new User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map(_userFromFirebase);
        //.map( (FirebaseUser user) => _userFromFirebase(user));
  }

  Future signIn(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      return _userFromFirebase(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signInAnon() async {
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebase(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  Future register(String email, String password) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      await DatabaseService(uid: user.uid).updateUserData('0', 'new crew member', 100);
      return _userFromFirebase(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
     return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
}
}