import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/colors.dart';

class CustomUserStatus extends StatefulWidget {
  const CustomUserStatus({Key? key}) : super(key: key);

  @override
  State<CustomUserStatus> createState() => _CustomUserStatusState();
}

class _CustomUserStatusState extends State<CustomUserStatus> {
  File? selectedImage;
  uploadPicForStory() async {
    XFile? currentPic = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(currentPic!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return selectedImage == null
        ? Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 1, color: Colors.red),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.5),
                      child: CircleAvatar(
                        backgroundColor: AppColors.PRIMARY_BLACK,
                        radius: 40,
                        backgroundImage: AssetImage("assets/images/guest.png"),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          uploadPicForStory();
                        },
                        child: Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.PRIMARY_BLACK),
                            color: AppColors.SKY,
                          ),
                          child: Icon(Icons.add, size: 15, color: AppColors.PRIMARY_WHITE),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 05),
              Text(
                "Your Story",
                style: TextStyle(
                  color: AppColors.PRIMARY_WHITE,
                ),
              )
            ],
          )
        : Container();
  }
}
