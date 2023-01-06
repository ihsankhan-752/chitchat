import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_insta_clone/utils/custom_messanger.dart';
import 'package:uuid/uuid.dart';

import 'firebase_storage_services.dart';
import 'notification_services.dart';

class fireStoreServices {
  uploadPost({
    String? postId,
    String? username,
    String? userImage,
    List<String>? postImages,
    TextEditingController? controller,
    String? videoUrl,
  }) async {
    await FirebaseFirestore.instance.collection("posts").doc(postId).set({
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "postId": postId,
      "username": username,
      "userImage": userImage,
      "postImages": postImages,
      "text": controller!.text,
      "videoUrl": videoUrl,
      "createdAt": DateTime.now(),
      "likes": [],
    });
  }

  followAndUnfollowUser(BuildContext context, String myUid, String otherUserUid) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("users").doc(otherUserUid).get();
      List followers = (snapshot.data()! as dynamic)['followers'];
      if (followers.contains(FirebaseAuth.instance.currentUser!.uid)) {
        await FirebaseFirestore.instance.collection("users").doc(otherUserUid).update({
          "followers": FieldValue.arrayRemove([myUid]),
        });
        await FirebaseFirestore.instance.collection("users").doc(myUid).update({
          "following": FieldValue.arrayRemove([otherUserUid]),
        });
      } else {
        await FirebaseFirestore.instance.collection("users").doc(otherUserUid).update({
          "followers": FieldValue.arrayUnion([myUid]),
        });
        await FirebaseFirestore.instance.collection("users").doc(myUid).update({
          "following": FieldValue.arrayUnion([otherUserUid]),
        });
      }
    } catch (e) {
      showMessage(context, e.toString());
    }
  }

  userChat({
    BuildContext? context,
    String? myId,
    String? userId,
    String? docId,
    String? msg,
    String? imageUrl,
  }) async {
    DocumentSnapshot userSnap = await FirebaseFirestore.instance.collection("users").doc(myId).get();
    try {
      // String imageUrl = await storageServices().uploadPhoto(image);
      DocumentSnapshot snap = await FirebaseFirestore.instance.collection("chat").doc(docId).get();
      if (snap.exists) {
        await FirebaseFirestore.instance.collection("chat").doc(docId).update({
          "lastMsg": msg,
          "createdAt": DateTime.now(),
        });
      } else {
        await FirebaseFirestore.instance.collection("chat").doc(docId).set({
          "lastMsg": msg,
          "userIds": [myId, userId],
          "createdAt": DateTime.now(),
        });
      }
      await FirebaseFirestore.instance.collection("chat").doc(docId).collection("messages").add({
        "msg": msg,
        "senderId": myId,
        "userImage": userSnap['image'],
        "username": userSnap['username'],
        "createdAt": DateTime.now(),
        "image": imageUrl,
      });
    } catch (e) {
      showMessage(context!, e.toString());
    }
  }

  addingComment({String? username, String? userImage, String? comment, String? postId}) async {
    String commentId = Uuid().v1();
    await FirebaseFirestore.instance.collection("posts").doc(postId).collection("comments").doc(commentId).set({
      "username": username,
      "commentId": commentId,
      "userImage": userImage,
      "comment": comment,
      "createdAt": DateTime.now(),
      "likes": [],
    });
  }

  likeComment(BuildContext context, String postId, String commentId, List<dynamic> snap) async {
    if (snap.contains(FirebaseAuth.instance.currentUser!.uid)) {
      try {
        await FirebaseFirestore.instance.collection("posts").doc(postId).collection("comments").doc(commentId).update({
          "likes": FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
        });
      } catch (e) {
        showMessage(context, e.toString());
      }
    } else {
      try {
        await FirebaseFirestore.instance.collection("posts").doc(postId).collection("comments").doc(commentId).update({
          "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
        });
      } catch (e) {
        showMessage(context, e.toString());
      }
    }
  }

  deletePost(BuildContext context, String postId) async {
    try {
      await FirebaseFirestore.instance.collection("posts").doc(postId).delete();
    } catch (e) {
      showMessage(context, e.toString());
    }
  }

  uploadStory(BuildContext context, String story, File image) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();

    String imageUrl = await storageServices().uploadPhoto(image);

    await FirebaseFirestore.instance.collection("stories").add({
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "storyImage": imageUrl,
      "text": story,
      "createdAt": DateTime.now(),
      "username": snap['username'],
      "userImage": snap['image'],
    });
  }

  sendNotificationForWhenFollowUser(String followUid) async {
    var myUid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("tokens").doc(followUid).get();
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("users").doc(myUid).get();
    String token = snap['token'];
    NotificationServices().sendPushNotification(token, "Great!!", "${data['username']} start following you");
    await FirebaseFirestore.instance.collection("notifications").add({
      "followUserId": followUid,
      "text": "${data['username']} start following you",
      "userImage": data['image'],
      "createdAt": DateTime.now(),
    });
  }
}
