import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_insta_clone/utils/colors.dart';
import 'package:my_insta_clone/utils/text_styles.dart';

class ListOfFollowerScreen extends StatelessWidget {
  final List<dynamic> followerList;
  const ListOfFollowerScreen({Key? key, required this.followerList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Who Follow Me",
            style: AppTextStyle.MAIN_HEADING.copyWith(
              fontSize: 16,
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: followerList.length,
          itemBuilder: (context, index) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").doc(followerList[index]).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                Map<String, dynamic> userInfo = snapshot.data!.data() as Map<String, dynamic>;
                return ListTile(
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
                );
              },
            );
          },
        ));
  }
}
