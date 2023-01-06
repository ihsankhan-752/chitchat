import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_insta_clone/screens/dashboard/widgets/comment_snap_card.dart';
import 'package:my_insta_clone/services/firestore_services.dart';

import '../../../utils/colors.dart';

class CommentScreen extends StatefulWidget {
  final String? postId;
  const CommentScreen({Key? key, this.postId}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController _commentController = TextEditingController();
  String username = '';
  String userImage = '';
  bool isLoading = false;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();

    setState(() {
      username = snap['username'];
      userImage = snap['image'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("posts")
                    .doc(widget.postId)
                    .collection("comments")
                    .orderBy("createdAt", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No One Comment This Post Yet",
                        style: TextStyle(
                          color: AppColors.PRIMARY_WHITE,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      // List likesList = snapshot.data!.docs[index]['likes'];
                      return CommentSnapCard(
                        data: data,
                        postId: widget.postId!,
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              height: 40,
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(left: 05, top: 05, right: 5),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(userImage),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: TextField(
                        controller: _commentController,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                        decoration: InputDecoration(
                            hintText: "comment as ${username}",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            )),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });

                            await fireStoreServices().addingComment(
                              username: username,
                              userImage: userImage,
                              comment: _commentController.text,
                              postId: widget.postId!,
                            );
                            setState(() {
                              isLoading = false;
                            });
                            _commentController.clear();
                            FocusScope.of(context).unfocus();
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            print(e);
                          }
                        },
                        child: isLoading
                            ? Center(child: CircularProgressIndicator(color: AppColors.BTN_COLOR))
                            : Text(
                                "Post",
                                style: TextStyle(
                                  color: AppColors.SKY,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
