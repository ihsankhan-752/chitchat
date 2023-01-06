import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? email;
  final String? username;
  final String? bio;
  final List? followers;
  final List? following;
  final String? uid;
  final String? imageUrl;

  UserModel({
    this.imageUrl,
    this.email,
    this.uid,
    this.following,
    this.followers,
    this.bio,
    this.username,
  });

  // Map<String, dynamic> toJson() {
  //   return {
  //     "uid": uid,
  //     "username": username,
  //     "email": email,
  //     "bio": bio,
  //     "followers": followers,
  //     "following": following,
  //     "imageUrl": imageUrl,
  //   };
  // }

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot snap) {
    return UserModel(
      uid: snap['uid'],
      username: snap['username'],
      email: snap['email'],
      bio: snap['bio'],
      followers: snap['followers'],
      following: snap['following'],
      imageUrl: snap['imageUrl'],
    );
  }
}
