import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_insta_clone/utils/custom_messanger.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

import '../../../services/firestore_services.dart';
import '../../../utils/colors.dart';

class CommentSnapCard extends StatefulWidget {
  final dynamic data;
  final String postId;
  const CommentSnapCard({Key? key, this.data, required this.postId}) : super(key: key);

  @override
  State<CommentSnapCard> createState() => _CommentSnapCardState();
}

class _CommentSnapCardState extends State<CommentSnapCard> {
  bool isShowReply = false;
  TextEditingController replyController = TextEditingController();
  bool isDisplay = false;
  final replyId = Uuid().v1();
  @override
  Widget build(BuildContext context) {
    List likesList = widget.data['likes'];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.data['userImage']),
              ),
              SizedBox(width: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: widget.data['username'],
                          style: TextStyle(
                            color: AppColors.PRIMARY_WHITE,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text: " ${widget.data['comment']}",
                          style: TextStyle(
                            color: AppColors.PRIMARY_WHITE,
                            fontSize: 13,
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          (timeago.format(
                            widget.data['createdAt'].toDate(),
                          )),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          "${widget.data['likes'].length} likes",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                                ),
                                context: context,
                                builder: (_) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height * 0.4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: replyController,
                                            maxLength: 50,
                                            decoration: InputDecoration(
                                                hintText: 'write a reply.....',
                                                suffixIcon: IconButton(
                                                  onPressed: () async {
                                                    DocumentSnapshot doc = await FirebaseFirestore.instance
                                                        .collection("users")
                                                        .doc(FirebaseAuth.instance.currentUser!.uid)
                                                        .get();
                                                    try {
                                                      await FirebaseFirestore.instance
                                                          .collection("posts")
                                                          .doc(widget.postId)
                                                          .collection("comments")
                                                          .doc(widget.data['commentId'])
                                                          .collection("commentReply")
                                                          .doc(replyId)
                                                          .set({
                                                        "replyId": replyId,
                                                        "username": doc['username'],
                                                        "userImage": doc['image'],
                                                        "createdAt": DateTime.now(),
                                                        "text": replyController.text,
                                                        "likes": [],
                                                      });
                                                      Navigator.pop(context);
                                                      replyController.clear();
                                                    } catch (e) {
                                                      showMessage(context, e.toString());
                                                    }
                                                  },
                                                  icon: Icon(Icons.send),
                                                )),
                                          ),
                                          SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Text(
                            "Reply",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 08),
                    Container(
                      height: 20,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.postId)
                            .collection('comments')
                            .doc(widget.data['commentId'])
                            .collection('commentReply')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Text(''),
                            );
                          } else if (snapshot.data!.docs.isEmpty) {
                            return SizedBox();
                          }
                          return Column(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 3, right: 15),
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          backgroundColor: AppColors.PRIMARY_WHITE,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                                          ),
                                          context: context,
                                          builder: (_) {
                                            return Container(
                                              height: 400,
                                              child: ListView.builder(
                                                itemCount: snapshot.data!.docs.length,
                                                itemBuilder: (context, index) {
                                                  var data = snapshot.data!.docs[index];
                                                  return Column(
                                                    children: [
                                                      ListTile(
                                                        leading: CircleAvatar(
                                                          radius: 20,
                                                          backgroundImage: NetworkImage(data['userImage']),
                                                        ),
                                                        title: Text(
                                                          data['username'],
                                                          style: TextStyle(
                                                            color: AppColors.PRIMARY_BLACK,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          data['text'],
                                                          style: TextStyle(
                                                            color: Colors.blueGrey,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        trailing: Text(
                                                          timeago.format(data['createdAt'].toDate()),
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                },
                                              ),
                                            );
                                          });
                                    },
                                    child: Text(
                                      "------view all ${snapshot.data!.docs.length} reply",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Spacer(),
              Container(
                width: 20,
                height: 20,
                margin: EdgeInsets.only(right: 5),
                child: IconButton(
                  icon: likesList.contains(FirebaseAuth.instance.currentUser!.uid)
                      ? Icon(Icons.favorite, color: Colors.red, size: 15)
                      : Icon(Icons.favorite_border, color: Colors.grey, size: 15),
                  onPressed: () async {
                    String commentId = widget.data['commentId'];
                    await fireStoreServices().likeComment(context, widget.postId, commentId, likesList);
                  },
                ),
              )
            ],
          ),
        ),
        Divider(thickness: 0.7),
      ],
    );
  }
}
