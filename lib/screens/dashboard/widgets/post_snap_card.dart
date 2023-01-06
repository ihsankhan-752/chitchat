import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:my_insta_clone/screens/dashboard/minor_screen/comment_screen.dart';
import 'package:my_insta_clone/screens/dashboard/minor_screen/likes_screen.dart';
import 'package:my_insta_clone/screens/dashboard/widgets/video_player_for_display_video.dart';
import 'package:my_insta_clone/services/firestore_services.dart';
import 'package:my_insta_clone/utils/custom_messanger.dart';
import 'package:my_insta_clone/utils/screen_navigations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../utils/colors.dart';

class PostSnapCard extends StatefulWidget {
  final dynamic data;
  const PostSnapCard({Key? key, this.data}) : super(key: key);

  @override
  State<PostSnapCard> createState() => _PostSnapCardState();
}

class _PostSnapCardState extends State<PostSnapCard> {
  List<dynamic>? bookmarkList;
  bool isLoading = false;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      bookmarkList = doc['bookmarks'];
      isLoading = false;
      setState(() {});
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: SizedBox())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1, color: Colors.red),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.5),
                      child: CircleAvatar(
                        backgroundColor: AppColors.PRIMARY_BLACK,
                        radius: 40,
                        backgroundImage: NetworkImage(widget.data['userImage']),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    widget.data["username"],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  SizedBox(height: 05),
                  widget.data['uid'] == FirebaseAuth.instance.currentUser!.uid
                      ? IconButton(
                          icon: Icon(Icons.more_vert, color: AppColors.PRIMARY_WHITE),
                          onPressed: () {
                            widget.data['uid'] == FirebaseAuth.instance.currentUser!.uid
                                ? showDialog(
                                    context: context,
                                    builder: (_) {
                                      return CupertinoAlertDialog(
                                        actions: [
                                          CupertinoActionSheetAction(
                                              onPressed: () {
                                                Navigator.of(context, rootNavigator: true).pop();
                                                // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => BottomNavBar()));
                                              },
                                              child: Text(
                                                "No",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              )),
                                          CupertinoActionSheetAction(
                                              onPressed: () async {
                                                Navigator.of(context, rootNavigator: true).pop();
                                                await fireStoreServices().deletePost(context, widget.data['postId']);
                                              },
                                              child: Text("Yes")),
                                        ],
                                        title: Center(child: Text("Wait")),
                                        content: Text("Do you want to delete your post?"),
                                      );
                                    })
                                : showModalBottomSheet(
                                    context: context,
                                    builder: (_) {
                                      return Container(
                                        height: 300,
                                      );
                                    });
                          },
                        )
                      : SizedBox(),
                ],
              ),
              SizedBox(height: 05),
              widget.data['videoUrl'] == ""
                  ? Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: double.infinity,
                      child: Swiper(
                        controller: SwiperController(),
                        pagination: SwiperPagination(
                            builder: FractionPaginationBuilder(
                          color: Color(0xfffee715),
                          activeColor: Color(0xfffee715),
                          fontSize: 22,
                          activeFontSize: 22,
                        )),
                        itemCount: widget.data['postImages'].length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(widget.data['postImages'][index], fit: BoxFit.cover),
                                Positioned(
                                  bottom: -10,
                                  right: 10,
                                  child: IconButton(
                                    onPressed: () async {
                                      try {
                                        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update(
                                          {
                                            'bookmarks': FieldValue.arrayUnion([widget.data['postImages'][index]]),
                                          },
                                        );
                                      } catch (e) {
                                        showMessage(context, e.toString());
                                      }
                                    },
                                    icon: bookmarkList!.contains(widget.data['postImages'][index])
                                        ? SizedBox()
                                        : Icon(
                                            Icons.bookmark_border,
                                            color: Colors.red,
                                            size: 25,
                                          ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: VideoPlayerForDisplayVideo(
                        path: widget.data['videoUrl'],
                      ),
                    ),
              Row(
                children: [
                  IconButton(
                    icon: widget.data['likes'].contains(FirebaseAuth.instance.currentUser!.uid)
                        ? Icon(Icons.favorite, color: Colors.red)
                        : Icon(Icons.favorite_border, color: Colors.white),
                    onPressed: () async {
                      try {
                        if (widget.data['likes'].contains(FirebaseAuth.instance.currentUser!.uid)) {
                          await FirebaseFirestore.instance.collection("posts").doc(widget.data['postId']).update({
                            "likes": FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
                          });
                        } else {
                          await FirebaseFirestore.instance.collection("posts").doc(widget.data['postId']).update({
                            "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
                          });
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                  SizedBox(width: 15),
                  IconButton(
                      onPressed: () {
                        navigateToNext(
                          context,
                          CommentScreen(
                            postId: widget.data['postId'],
                          ),
                        );
                      },
                      icon: Icon(Icons.mode_comment_outlined, color: Colors.white)),
                  SizedBox(width: 15),
                  InkWell(
                      onTap: () async {
                        final box = context.findRenderObject() as RenderBox?;
                        await Share.share(
                          widget.data['postImages'][0],
                          subject: widget.data['text'],
                          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                        );
                      },
                      child: Icon(Icons.send, color: Colors.white)),
                  Spacer(),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: InkWell(
                  onTap: () {
                    widget.data['likes'].length == 0
                        ? showMessage(context, "No One Like This Post")
                        : navigateToNext(context, LikesScreen(likes: widget.data['likes']));
                  },
                  child: Text(
                    "${widget.data['likes'].length} likes",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: widget.data['username'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                    TextSpan(
                        text: " ${widget.data['text']}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        )),
                  ]),
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(left: 10),
                height: 20,
                width: double.infinity,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("posts").doc(widget.data['postId']).collection("comments").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return InkWell(
                        onTap: () {
                          navigateToNext(
                            context,
                            CommentScreen(
                              postId: widget.data['postId'],
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
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  (timeago.format(widget.data['createdAt'].toDate())),
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          );
  }
}
