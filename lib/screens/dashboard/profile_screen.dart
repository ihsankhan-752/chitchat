import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_insta_clone/models/user_model.dart';
import 'package:my_insta_clone/screens/dashboard/minor_screen/user_list_for_following_screen.dart';
import 'package:my_insta_clone/screens/dashboard/widgets/user_profile_custom_card.dart';
import 'package:my_insta_clone/services/auth_services.dart';
import 'package:my_insta_clone/services/firestore_services.dart';
import 'package:my_insta_clone/utils/colors.dart';
import 'package:my_insta_clone/utils/screen_navigations.dart';
import 'package:my_insta_clone/utils/text_styles.dart';
import 'package:my_insta_clone/widgets/buttons.dart';

import '../../utils/custom_messanger.dart';
import 'minor_screen/chat_screen.dart';
import 'minor_screen/list_of_followers_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String? uid;
  const ProfileScreen({Key? key, this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var myUid = FirebaseAuth.instance.currentUser!.uid;
  UserModel userModel = UserModel();

  int followers = 0;
  int following = 0;
  int postsLength = 0;
  String username = '';
  String userImage = "";
  String bio = '';
  bool isLoading = false;
  bool isFollowing = false;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

//todo i will use provider for this to handle it
  getUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot userSnap = await FirebaseFirestore.instance.collection("users").doc(widget.uid).get();
      var postSnap = await FirebaseFirestore.instance.collection("posts").where("uid", isEqualTo: widget.uid).get();
      username = userSnap['username'];
      userImage = userSnap['image'];
      bio = userSnap["bio"];
      postsLength = postSnap.docs.length;
      isLoading = false;
      setState(() {});
    } catch (e) {
      showMessage(context, e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.uid);
    return isLoading
        ? Center(child: CircularProgressIndicator(color: Colors.red))
        : Scaffold(
            appBar: AppBar(
              title: Text(
                username,
                style: AppTextStyle.MAIN_HEADING.copyWith(
                  fontSize: 18,
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 180,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("users").doc(widget.uid).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(userImage),
                              ),
                              SizedBox(width: 25),
                              UserProfileCustomCard(value: postsLength, title: "Posts"),
                              UserProfileCustomCard(
                                onPressed: () {
                                  navigateToNext(
                                      context,
                                      ListOfFollowerScreen(
                                        followerList: userData['followers'],
                                      ));
                                },
                                value: userData['followers'].length,
                                title: "Followers",
                              ),
                              UserProfileCustomCard(
                                onPressed: () {
                                  navigateToNext(context, ListOfFollowingScreen(followingList: userData['following']));
                                },
                                value: userData['following'].length,
                                title: "Following",
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Text(
                              bio,
                              style: TextStyle(color: AppColors.PRIMARY_WHITE),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              widget.uid == FirebaseAuth.instance.currentUser!.uid
                                  ? ProfileScreenMainButton(
                                      onPressed: () async {
                                        await AuthServices().logOutUser(context);
                                      },
                                      btnColor: AppColors.PRIMARY_GREY.withOpacity(0.3),
                                      borderColor: AppColors.PRIMARY_GREY,
                                      title: "Sign Out",
                                    )
                                  : Row(
                                      children: [
                                        userData['followers'].contains(FirebaseAuth.instance.currentUser!.uid)
                                            ? ProfileScreenMainButton(
                                                onPressed: () async {
                                                  await fireStoreServices().followAndUnfollowUser(context, myUid, widget.uid!);
                                                },
                                                btnColor: AppColors.SKY,
                                                borderColor: AppColors.PRIMARY_GREY,
                                                title: "Unfollow",
                                              )
                                            : ProfileScreenMainButton(
                                                onPressed: () async {
                                                  await fireStoreServices().followAndUnfollowUser(context, myUid, widget.uid!);
                                                  await fireStoreServices().sendNotificationForWhenFollowUser(widget.uid!);
                                                },
                                                btnColor: AppColors.SKY,
                                                borderColor: AppColors.PRIMARY_GREY,
                                                title: "Follow",
                                              ),
                                        SizedBox(width: 20),
                                        ProfileScreenMainButton(
                                          onPressed: () {
                                            navigateToNext(
                                              context,
                                              ChatScreen(
                                                userId: widget.uid,
                                                username: username,
                                                userImage: userImage,
                                                userBio: bio,
                                              ),
                                            );
                                          },
                                          btnColor: AppColors.PRIMARY_GREY.withOpacity(0.3),
                                          borderColor: AppColors.PRIMARY_GREY,
                                          title: "Message",
                                        ),
                                      ],
                                    )
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: AppColors.PRIMARY_GREY.withOpacity(0.3),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: double.infinity,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("posts").where("uid", isEqualTo: widget.uid).snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            "No Post Available",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
                      return GridView.builder(
                          itemCount: snapshot.data!.docs.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(top: 0, bottom: 10, left: 10, right: 10),
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Image.network(snapshot.data!.docs[index]['postImages'][0], fit: BoxFit.cover),
                            );
                          });
                    },
                  ),
                )
              ],
            ),
          );
  }
}
