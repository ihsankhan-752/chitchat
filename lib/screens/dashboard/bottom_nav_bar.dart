import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_insta_clone/screens/dashboard/add_post_screen.dart';
import 'package:my_insta_clone/screens/dashboard/home_screen.dart';
import 'package:my_insta_clone/screens/dashboard/notification_screen.dart';
import 'package:my_insta_clone/screens/dashboard/profile_screen.dart';
import 'package:my_insta_clone/screens/dashboard/search_screen.dart';
import 'package:my_insta_clone/utils/colors.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: 0,
        backgroundColor: AppColors.PRIMARY_BLACK,
        activeColor: AppColors.APP_CIRCULAR_RADIUS,
        items: [
          BottomNavigationBarItem(
            backgroundColor: AppColors.PRIMARY_BLACK,
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "",
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) => HomeScreen(),
            );
          case 1:
            return CupertinoTabView(
              builder: (context) {
                return SearchScreen();
              },
            );
          case 2:
            return CupertinoTabView(
              builder: (context) => AddPostScreen(),
            );
          case 3:
            return CupertinoTabView(
              builder: (context) => NotificationScreen(),
            );
          case 4:
            return CupertinoTabView(
              builder: (context) => ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
            );

          default:
            return SizedBox();
        }
        return SizedBox();
      },
    );
  }
}
