import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_insta_clone/utils/colors.dart';
import 'package:my_insta_clone/utils/screen_navigations.dart';
import 'package:my_insta_clone/utils/text_styles.dart';
import 'package:my_insta_clone/widgets/text_input.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'chat_screen.dart';

class UserListForChatScreen extends StatefulWidget {
  const UserListForChatScreen({Key? key}) : super(key: key);

  @override
  State<UserListForChatScreen> createState() => _UserListForChatScreenState();
}

class _UserListForChatScreenState extends State<UserListForChatScreen> {
  TextEditingController _searchController = TextEditingController();
  String username = "";
  var userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("users").doc(userId).get();
    username = snap['username'];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(username),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextInputForSearch(
                controller: _searchController,
                onChanged: (v) {
                  setState(() {});
                },
              ),
              SizedBox(height: 10),
              Text(
                "Messages",
                style: AppTextStyle.MAIN_HEADING.copyWith(fontSize: 18),
              ),
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chat")
                      .where('userIds', arrayContains: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text("You Have No Chat Yet"),
                      );
                    }
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          getUserById() {
                            List<dynamic> users = snapshot.data!.docs[index]['userIds'];
                            if (users[0] == FirebaseAuth.instance.currentUser!.uid) {
                              return users[1];
                            } else {
                              return users[0];
                            }
                          }

                          return Container(
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance.collection("users").doc(getUserById()).snapshots(),
                              builder: (context, userSnap) {
                                if (userSnap.hasData) {
                                  Map<String, dynamic> snap = userSnap.data!.data() as Map<String, dynamic>;

                                  if (_searchController.text.isEmpty) {
                                    return ListTile(
                                      onTap: () {
                                        navigateToNext(
                                            context,
                                            ChatScreen(
                                              userBio: snap['bio'],
                                              userId: snap['uid'],
                                              userImage: snap['image'],
                                              username: snap['username'],
                                            ));
                                      },
                                      contentPadding: EdgeInsets.only(right: 20),
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(snap['image']),
                                      ),
                                      title: Text(
                                        snap['username'].toString().toUpperCase(),
                                        style: TextStyle(
                                          color: AppColors.PRIMARY_WHITE,
                                          fontSize: 18,
                                        ),
                                      ),
                                      subtitle: Row(
                                        children: [
                                          snapshot.data!.docs[index]['lastMsg'] == ""
                                              ? Text(
                                                  "send an Image",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              : Text(
                                                  snapshot.data!.docs[index]['lastMsg'],
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                  ),
                                                )
                                        ],
                                      ),
                                      trailing: Text(
                                        timeago.format(
                                          snapshot.data!.docs[index]['createdAt'].toDate(),
                                        ),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                    );
                                  } else if (snap['username'].toString().toLowerCase().contains(_searchController.text.toLowerCase())) {
                                    return ListTile(
                                      onTap: () {
                                        navigateToNext(
                                            context,
                                            ChatScreen(
                                              userBio: snap['bio'],
                                              userId: snap['uid'],
                                              userImage: snap['image'],
                                              username: snap['username'],
                                            ));
                                      },
                                      contentPadding: EdgeInsets.only(right: 20),
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(snap['image']),
                                      ),
                                      title: Text(
                                        snap['username'].toString().toUpperCase(),
                                        style: TextStyle(
                                          color: AppColors.PRIMARY_WHITE,
                                          fontSize: 18,
                                        ),
                                      ),
                                      subtitle: Row(
                                        children: [
                                          snapshot.data!.docs[index]['lastMsg'] == ""
                                              ? Text(
                                                  "send an Image",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              : Text(
                                                  snapshot.data!.docs[index]['lastMsg'],
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                  ),
                                                )
                                        ],
                                      ),
                                      trailing: Text(
                                        timeago.format(
                                          snapshot.data!.docs[index]['createdAt'].toDate(),
                                        ),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                    );
                                  }
                                  return SizedBox();
                                }
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
