import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_insta_clone/screens/dashboard/minor_screen/user_list_for_chat_screen.dart';
import 'package:my_insta_clone/screens/dashboard/widgets/post_snap_card.dart';
import 'package:my_insta_clone/screens/dashboard/widgets/story_card.dart';
import 'package:my_insta_clone/services/notification_services.dart';
import 'package:my_insta_clone/utils/colors.dart';
import 'package:my_insta_clone/utils/screen_navigations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = '';
  String userImage = '';
  TextEditingController storyController = TextEditingController();

  @override
  void initState() {
    NotificationServices().getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(username);
    return Scaffold(
      appBar: AppBar(
        title: Text("Chit Chat",
            style: GoogleFonts.pacifico(
              fontSize: 22,
              color: AppColors.PRIMARY_WHITE,
            )),
        actions: [
          IconButton(
            icon: Icon(Icons.send, color: AppColors.PRIMARY_WHITE),
            onPressed: () {
              navigateToNext(context, UserListForChatScreen());
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StoryCard(),
            Divider(thickness: 0.1, color: Colors.grey),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("posts").orderBy("createdAt", descending: true).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No Posts Found!",
                        style: TextStyle(
                          color: AppColors.PRIMARY_WHITE,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return PostSnapCard(
                        data: snapshot.data!.docs[index],
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
