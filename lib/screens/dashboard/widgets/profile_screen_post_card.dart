import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_insta_clone/screens/dashboard/widgets/video_player_for_display_video.dart';

class ProfileScreenPostCard extends StatelessWidget {
  final String uid;
  const ProfileScreenPostCard({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      width: double.infinity,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("posts").where("uid", isEqualTo: uid).snapshots(),
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
                var data = snapshot.data!.docs[index];
                return Container(
                    margin: EdgeInsets.only(top: 0, bottom: 10, left: 10, right: 10),
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: data['videoUrl'] == ""
                        ? Image.network(
                            data['postImages'][0],
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 200,
                            child: VideoPlayerForDisplayVideo(
                              path: data['videoUrl'],
                            ),
                          ));
              });
        },
      ),
    );
  }
}
