import 'package:flutter/material.dart';

Future imagePickingDialogBox({BuildContext? context, Function()? cameraTapped, Function()? galleryTapped}) async {
  return showDialog(
      context: context!,
      builder: (_) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
              onPressed: cameraTapped,
              child: Text("From Camera"),
            ),
            Divider(),
            SimpleDialogOption(
              onPressed: galleryTapped,
              child: Text("From Gallery"),
            ),
            Divider(),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      });
}
