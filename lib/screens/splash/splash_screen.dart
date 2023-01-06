import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_insta_clone/screens/dashboard/bottom_nav_bar.dart';
import 'package:my_insta_clone/screens/splash/first_screen.dart';
import 'package:my_insta_clone/utils/screen_navigations.dart';

import '../../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 4), () {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        navigateToNext(context, FirstScreen());
      } else {
        navigateToNext(context, BottomNavBar());
      }
    });
    super.initState();
  }

  isUserLogin() async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset("assets/images/logo.png")),
          SizedBox(height: 50),
          SpinKitSpinningLines(
            color: AppColors.APP_CIRCULAR_RADIUS,
          ),
        ],
      ),
    );
  }
}
