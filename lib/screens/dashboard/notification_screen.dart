import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_insta_clone/utils/colors.dart';
import 'package:my_insta_clone/utils/text_styles.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Notifications", style: AppTextStyle.MAIN_HEADING.copyWith(fontSize: 18)),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('notifications')
              .where('followUserId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No Notifications Found",
                  style: AppTextStyle.MAIN_HEADING.copyWith(
                    color: Colors.blueGrey,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(data['userImage']),
                      ),
                      title: Text(
                        data['text'],
                        style: TextStyle(
                          color: AppColors.PRIMARY_WHITE,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        timeago.format(data['createdAt'].toDate()),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Divider(thickness: 0.7, color: Colors.blueGrey),
                  ],
                );
              },
            );
          },
        ));
  }
}
