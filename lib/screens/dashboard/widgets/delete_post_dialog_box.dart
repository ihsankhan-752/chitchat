import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../services/firestore_services.dart';

Future deletePostDialogBox({BuildContext? context, String? postId}) {
  return showDialog(
      context: context!,
      builder: (_) {
        return CupertinoAlertDialog(
          actions: [
            CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
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
                  await fireStoreServices().deletePost(context, postId!);
                },
                child: Text("Yes")),
          ],
          title: Center(child: Text("Wait")),
          content: Text("Do you want to delete your post?"),
        );
      });
}
