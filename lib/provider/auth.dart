import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:pepoll/core/utils.dart';
import 'package:pepoll/provider/firestore.dart';

class Auth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> signInWithGoogle(BuildContext context) async {
    GoogleSignInAccount googleUser;
    GoogleSignInAuthentication googleAuth;

    if(_googleSignIn.currentUser != null || await _googleSignIn.isSignedIn()) {
      try{
        await _googleSignIn.disconnect();
      } catch(e) {
        throw Exception(e);
      }
    }

    googleUser = await GoogleSignIn().signIn();

    googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      if(userCredential.additionalUserInfo.isNewUser){
        addUser(userCredential.user);
        addMember(userCredential.user);
      }
      return FirebaseAuth.instance.currentUser;
    } catch (e) {
      throw Exception(e);
    }

  }

  Future<bool> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    }on FirebaseAuthException catch(e) {
      if(e.code == 'invalid-email') {
        Utils().showErrorMessage(context, 'Invalid Email');
      }
      if(e.code == 'wrong-password') {
        Utils().showErrorMessage(context, 'Wrong password');
      }
      if(e.code == 'user-not-found') {
        Utils().showErrorMessage(context, 'Account not found');
      }
      return false;
    }
  }

  Future<bool> signUpWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      if(credential.additionalUserInfo.isNewUser){
        addUser(credential.user);
        addMember(credential.user);
      }
      return true;
    }on FirebaseAuthException catch(e) {
      Navigator.pop(context);
      if(e.code == 'invalid-email') {
        Utils().showErrorMessage(context, 'Invalid Email');
      }
      if(e.code == 'email-already-in-use') {
        Utils().showErrorMessage(context, 'Email already in use!');
      }
      return false;
    }
  }

  Future signOut() async{
    try{
      await GoogleSignIn().signOut();
    } catch (e){
      debugPrint(e);
    }

    try {
      FirebaseAuth.instance.signOut();
    }catch (e) {
      debugPrint(e);
    }
  }
}

