import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LikesScreen extends StatelessWidget {
  final List<dynamic>? likes;
  const LikesScreen({Key? key, this.likes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(likes!.length);
    return Scaffold(
      appBar: AppBar(
        title: Text("Likes"),
      ),
      body: ListView.builder(
        itemCount: likes!.length,
        itemBuilder: (context, index) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").doc(likes![index]).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                Map<String, dynamic> userSnap = snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(userSnap['image']),
                      ),
                      title: Text(
                        userSnap['email'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        userSnap['username'],
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Divider(endIndent: 20, thickness: 0.5, color: Colors.grey, indent: 20),
                  ],
                );
              });
        },
      ),
    );
  }
}
