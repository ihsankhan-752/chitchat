import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_insta_clone/utils/screen_navigations.dart';

import '../screens/auth/login_screen.dart';
import '../screens/dashboard/bottom_nav_bar.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUp({
    BuildContext? context,
    String? email,
    String? password,
    File? file,
    String? username,
    String? bio,
  }) async {
    String res = "Some Error Occurred";
    try {
      await _auth.createUserWithEmailAndPassword(email: email!, password: password!);
      FirebaseStorage fs = FirebaseStorage.instance;
      Reference ref = await fs.ref().child(DateTime.now().millisecondsSinceEpoch.toString());
      await ref.putFile(file!);
      String imageUrl = await ref.getDownloadURL();
      await _firestore.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set({
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "username": username,
        "email": email,
        "bio": bio,
        "image": imageUrl,
        'bookmarks': [],
        "followers": [],
        "following": [],
      });
      res = 'success';

      navigateToNext(context!, BottomNavBar());
    } on FirebaseAuthException catch (e) {
      res = e.message!;
      print(e);
    }
    return res;
  }

  Future<String> signIn(BuildContext context, String email, String password) async {
    String res = "Some Error Occurred";
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = 'success';
      navigateToNext(context, BottomNavBar());
    } on FirebaseAuthException catch (e) {
      res = e.message!;
    }
    return res;
  }

  logOutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth!.idToken,
      accessToken: googleAuth.accessToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential).whenComplete(() async {
      await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set({
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "username": googleUser.displayName,
        "email": googleUser.email,
        "bio": '',
        "image": googleUser.photoUrl,
        'bookmarks': [],
        "followers": [],
        "following": [],
      });
      navigateToNext(context, BottomNavBar());
    });
  }
}
