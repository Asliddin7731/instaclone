
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:instaclone/router/app_router.dart';

class AuthService{
  static final _auth = FirebaseAuth.instance;

  static bool isLoggedIn() {
    final User? firebaseUser = _auth.currentUser;
    return firebaseUser != null;
  }

  static String currentUserId() {
    final User? firebaseUser = _auth.currentUser;
    return firebaseUser!.uid;
  }

  static Future<User?> signInUser(String email, String password)async{
    var authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final User? firebaseUser = authResult.user;
    return firebaseUser;
  }

  static Future<User?> signUpUser(String email, String password)async{
    var authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = authResult.user;
    return user;
  }

  static void signOutUser(BuildContext context){
    _auth.signOut();
    context.pushReplacement(RouteNames.signIn);
  }

}