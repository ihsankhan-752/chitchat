import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_insta_clone/screens/dashboard/widgets/video_player_widget_for_uploading_video.dart';
import 'package:my_insta_clone/services/firestore_services.dart';
import 'package:my_insta_clone/utils/colors.dart';
import 'package:uuid/uuid.dart';

import '../../utils/custom_messanger.dart';
import 'bottom_nav_bar.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  String? url;
  int currentIndex = 0;
  TextEditingController _postController = TextEditingController();
  String username = '';
  String userImage = '';
  List<XFile>? _imageFileList = [];
  List<String> imageUrlList = [];
  bool isLoading = false;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  File? pickedFile;

  Future selectFile() async {
    final result = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
      maxDuration: Duration(seconds: 20),
    );
    if (result == null) return;
    setState(() {
      pickedFile = File(result.path);
    });
  }

  getUserData() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
    setState(() {
      username = snap['username'];
      userImage = snap['image'];
    });
  }

  uploadPost() async {
    String postId = Uuid().v1();
    setState(() {
      isLoading = true;
    });
    try {
      for (var image in _imageFileList!) {
        FirebaseStorage firebaseStorage = FirebaseStorage.instance;
        Reference ref = await firebaseStorage.ref().child(DateTime.now().millisecondsSinceEpoch.toString());
        await ref.putFile(File(image.path));
        await ref.getDownloadURL();
        imageUrlList.add(await ref.getDownloadURL());
      }

      await fireStoreServices().uploadPost(
        userImage: userImage,
        username: username,
        postId: postId,
        postImages: imageUrlList,
        controller: _postController,
        videoUrl: "",
      );
      setState(() {
        isLoading = false;
      });
      Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => BottomNavBar()));
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showMessage(context, e.toString());
    }
  }

  uploadPostImages() async {
    final pickedFile = await ImagePicker().pickMultiImage();

    setState(() {
      _imageFileList = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return currentIndex == 0
        ? _imageFileList!.isEmpty
            ? Scaffold(
                body: Center(
                  child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                          ),
                          context: context,
                          builder: (_) {
                            return Container(
                              height: 200,
                              child: Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      uploadPostImages();
                                      Navigator.of(context).pop();
                                      setState(() {
                                        currentIndex = 0;
                                      });
                                    },
                                    title: Text("Upload From Gallery"),
                                    trailing: Icon(Icons.photo),
                                  ),
                                  Divider(thickness: 1, color: AppColors.PRIMARY_GREY),
                                  ListTile(
                                    onTap: () {
                                      // uploadImage(ImageSource.camera);
                                      print(currentIndex);
                                      setState(() {
                                        currentIndex = 1;
                                      });
                                      Navigator.of(context).pop();
                                      selectFile();
                                    },
                                    title: Text("Upload Video"),
                                    trailing: Icon(Icons.video_call),
                                  ),
                                  Divider(thickness: 1, color: AppColors.PRIMARY_GREY),
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    title: Text("Cancel"),
                                    trailing: Icon(Icons.cancel),
                                  )
                                ],
                              ),
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
              )
            : Scaffold(
                appBar: AppBar(
                  leading: Icon(Icons.arrow_back, color: AppColors.PRIMARY_WHITE),
                  title: Text("Post to"),
                  actions: [
                    InkWell(
                      onTap: () {
                        uploadPost();
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Text(
                            "Post",
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.SKY,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                body: Column(
                  children: [
                    isLoading
                        ? LinearProgressIndicator(
                            color: AppColors.APP_CIRCULAR_RADIUS,
                          )
                        : SizedBox(),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(userImage),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: TextField(
                            controller: _postController,
                            style: TextStyle(color: Colors.grey),
                            decoration: InputDecoration(
                              hintText: "write a post",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Container(
                            height: 100,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _imageFileList!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(_imageFileList![index].path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ))
                      ],
                    )
                  ],
                ),
              )
        : Scaffold(
            appBar: AppBar(
              title: IconButton(
                icon: Icon(Icons.close, color: AppColors.PRIMARY_WHITE),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              actions: [
                Center(
                  child: Text(
                    "Post To",
                    style: TextStyle(
                      color: AppColors.SKY,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                IconButton(
                    onPressed: () async {
                      String postId = Uuid().v1();
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        final ref = FirebaseStorage.instance.ref().child(DateTime.now().millisecondsSinceEpoch.toString());
                        await ref.putFile(File(pickedFile!.path));
                        url = await ref.getDownloadURL();

                        await fireStoreServices().uploadPost(
                          userImage: userImage,
                          username: username,
                          postId: postId,
                          postImages: [],
                          controller: _postController,
                          videoUrl: url,
                        );
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => BottomNavBar()));
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        showMessage(context, e.toString());
                      }
                    },
                    icon: Icon(Icons.arrow_forward),
                    color: AppColors.PRIMARY_WHITE),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LinearProgressIndicator(color: AppColors.APP_CIRCULAR_RADIUS),
                      )
                    : SizedBox(),
                pickedFile == null
                    ? Container(
                        height: 200,
                        child: Center(
                          child: Text("No File Selected"),
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Center(
                          child: VideoPlayerWidget(
                            path: File(pickedFile!.path),
                          ),
                        ),
                      ),
                SizedBox(height: 20),
              ],
            ),
          );
  }
}
