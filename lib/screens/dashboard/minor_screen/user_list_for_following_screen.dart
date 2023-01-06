import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_insta_clone/utils/colors.dart';
import 'package:my_insta_clone/utils/text_styles.dart';

class ListOfFollowingScreen extends StatelessWidget {
  final List<dynamic> followingList;
  const ListOfFollowingScreen({Key? key, required this.followingList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Following List",
          style: AppTextStyle.MAIN_HEADING.copyWith(
            fontSize: 16,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: followingList.length,
        itemBuilder: (context, index) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").doc(followingList[index]).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              Map<String, dynamic> userInfo = snapshot.data!.data() as Map<String, dynamic>;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 05),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(userInfo['image']),
                  ),
                  title: Text(
                    userInfo['username'].toString().toUpperCase(),
                    style: TextStyle(
                      color: AppColors.PRIMARY_WHITE,
                    ),
                  ),
                  subtitle: Text(
                    userInfo['bio'],
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
