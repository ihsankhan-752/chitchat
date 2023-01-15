import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_insta_clone/screens/dashboard/minor_screen/comment_screen.dart';
import 'package:my_insta_clone/screens/dashboard/minor_screen/likes_screen.dart';
import 'package:my_insta_clone/screens/dashboard/widgets/delete_post_dialog_box.dart';
import 'package:my_insta_clone/screens/dashboard/widgets/share_widget.dart';
import 'package:my_insta_clone/screens/dashboard/widgets/show_post_image_widget.dart';
import 'package:my_insta_clone/screens/dashboard/widgets/video_player_for_display_video.dart';
import 'package:my_insta_clone/services/firestore_services.dart';
import 'package:my_insta_clone/utils/custom_messanger.dart';
import 'package:my_insta_clone/utils/screen_navigations.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../utils/colors.dart';
import 'moving_to_comment_screen_icon_widget.dart';

class PostSnapCard extends StatefulWidget {
  final dynamic data;
  const PostSnapCard({Key? key, this.data}) : super(key: key);

  @override
  State<PostSnapCard> createState() => _PostSnapCardState();
}

class _PostSnapCardState extends State<PostSnapCard> {
  bool isLoading = false;
  @override
  void initState() {
    // getUserData();
    super.initState();
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
                            deletePostDialogBox(context: context, postId: widget.data['postId']);
                          },
                        )
                      : SizedBox(),
                ],
              ),
              SizedBox(height: 05),
              widget.data['videoUrl'] == ""
                  ? ShowPostImagesWidget(data: widget.data)
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
                      await fireStoreServices().likeAndDislikePost(context: context, data: widget.data);
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
                  ShareWidget(data: widget.data),
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
              MovingToCommentScreenIconWidget(data: widget.data),
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
