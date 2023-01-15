import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../utils/screen_navigations.dart';
import '../minor_screen/comment_screen.dart';

class MovingToCommentScreenIconWidget extends StatelessWidget {
  final dynamic data;
  const MovingToCommentScreenIconWidget({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      height: 20,
      width: double.infinity,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("posts").doc(data['postId']).collection("comments").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return InkWell(
              onTap: () {
                navigateToNext(
                  context,
                  CommentScreen(
                    postId: data['postId'],
                  ),
                );
              },
              child: Text(
                "View all ${snapshot.data!.docs.length} comments",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
