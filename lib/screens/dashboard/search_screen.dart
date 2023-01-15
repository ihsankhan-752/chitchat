import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:my_insta_clone/screens/dashboard/profile_screen.dart';
import 'package:my_insta_clone/screens/dashboard/widgets/video_player_for_display_video.dart';
import 'package:my_insta_clone/widgets/text_input.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../../utils/colors.dart';
import '../../utils/screen_navigations.dart';
import '../../utils/text_styles.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  bool isShowUser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextInputForSearch(
          controller: searchController,
          onChanged: (v) {
            setState(() {});
            FocusScopeNode focusScopeNode = FocusScope.of(context);
            if (focusScopeNode.hasPrimaryFocus) {
              focusScopeNode.unfocus();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            searchController.text.isNotEmpty
                ? DelayedDisplay(
                    delay: Duration(milliseconds: 600),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("users").snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return DelayedDisplay(
                              slidingCurve: Curves.decelerate,
                              slidingBeginOffset: Offset(0.0, 0.35),
                              fadingDuration: Duration(milliseconds: 0),
                              delay: Duration(seconds: 0),
                              child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var userInfo = snapshot.data!.docs[index];
                                  if (searchController.text.isEmpty) {
                                    return SizedBox();
                                  } else if (userInfo['username'].toString().toLowerCase().contains(searchController.text.toLowerCase())) {
                                    return ListTile(
                                      onTap: () {
                                        navigateToNext(
                                          context,
                                          ProfileScreen(
                                            uid: snapshot.data!.docs[index]['uid'],
                                          ),
                                        );
                                      },
                                      leading: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(userInfo['image']),
                                      ),
                                      title: Text(
                                        userInfo['username'],
                                        style: AppTextStyle.MAIN_HEADING.copyWith(fontSize: 18),
                                      ),
                                      subtitle: Text(
                                        userInfo['bio'],
                                        style: AppTextStyle.MAIN_HEADING.copyWith(fontSize: 16, color: Colors.grey),
                                      ),
                                    );
                                  }
                                  return SizedBox();
                                },
                              ),
                            );
                          } else if (snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Text(
                                'No Post Found',
                                style: TextStyle(
                                  color: AppColors.PRIMARY_WHITE,
                                ),
                              ),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("posts").snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text(
                              'No Post Found',
                              style: TextStyle(
                                color: AppColors.PRIMARY_WHITE,
                              ),
                            ),
                          );
                        }
                        return StaggeredGridView.countBuilder(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          itemCount: snapshot.data!.docs.length,
                          staggeredTileBuilder: (index) => StaggeredTile.count(
                            (index % 7 == 0) ? 2 : 1,
                            (index % 7 == 0) ? 2 : 1,
                          ),
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index];
                            return data['videoUrl'] == ""
                                ? Image.network(snapshot.data!.docs[index]['postImages'][0], fit: BoxFit.cover)
                                : Container(
                                    height: 200,
                                    child: VideoPlayerForDisplayVideo(
                                      path: data['videoUrl'],
                                    ),
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
