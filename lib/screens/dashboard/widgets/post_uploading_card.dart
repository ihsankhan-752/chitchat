import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class PostUploadingCard extends StatelessWidget {
  final Function()? onTappedForGallery;
  final Function()? onTapForCamera;
  const PostUploadingCard({Key? key, this.onTappedForGallery, this.onTapForCamera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) {
                  return SimpleDialog(
                    title: Text("Create A Post"),
                    children: [
                      SimpleDialogOption(
                        onPressed: onTappedForGallery,
                        child: Text("Gallery"),
                      ),
                      Divider(),
                      SimpleDialogOption(
                        onPressed: onTapForCamera,
                        child: Text("Camera"),
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
          },
          icon: Icon(
            Icons.upload,
            size: 25,
            color: AppColors.PRIMARY_WHITE,
          ),
        ),
      ),
    );
  }
}
