import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_insta_clone/screens/dashboard/widgets/message_text_input.dart';
import 'package:my_insta_clone/services/firebase_storage_services.dart';
import 'package:my_insta_clone/services/firestore_services.dart';
import 'package:my_insta_clone/utils/colors.dart';

import '../../../utils/custom_messanger.dart';

class ChatScreen extends StatefulWidget {
  final String? username;
  final String? userImage;
  final String? userBio;
  final String? userId;
  const ChatScreen({Key? key, this.username, this.userImage, this.userBio, this.userId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msgController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  String docId = '';
  File? _selectedImage;
  String myId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    if (myId.hashCode > widget.userId.hashCode) {
      docId = myId + widget.userId!;
    } else {
      docId = widget.userId! + myId;
    }
    super.initState();
  }

  uploadImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null && pickedFile != _selectedImage) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.userImage!),
          ),
          title: Text(
            widget.username!,
            style: TextStyle(color: AppColors.PRIMARY_WHITE, fontSize: 14),
          ),
          subtitle: Text(
            widget.userBio!,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _selectedImage == null
                ? SizedBox()
                : Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50),
                        height: MediaQuery.of(context).size.height * 0.75,
                        width: double.infinity,
                        color: Colors.red,
                        child: ColorFiltered(
                            colorFilter: ColorFilter.mode(AppColors.PRIMARY_BLACK.withOpacity(0.5), BlendMode.srcATop),
                            child: Image.file(File(_selectedImage!.path), fit: BoxFit.cover)),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              String imageUrl = await storageServices().uploadPhoto(_selectedImage);
                              await fireStoreServices().userChat(
                                context: context,
                                myId: myId,
                                userId: widget.userId!,
                                docId: docId,
                                msg: msgController.text.isEmpty ? "" : msgController.text,
                                imageUrl: imageUrl.isEmpty ? "" : imageUrl,
                              );
                              setState(() {
                                isLoading = false;
                                _selectedImage = null;
                              });
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              showMessage(context, e.toString());
                            }
                          },
                          child: Container(
                            height: 35,
                            width: 100,
                            decoration: BoxDecoration(
                              color: AppColors.APP_CIRCULAR_RADIUS,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: isLoading
                                  ? Center(
                                      child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: CircularProgressIndicator(),
                                    ))
                                  : Text("send"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
            Container(
              height: MediaQuery.of(context).size.height * 0.72,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chat")
                    .doc(docId)
                    .collection("messages")
                    .orderBy("createdAt", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No Chat Found !!",
                        style: TextStyle(
                          color: Colors.blueGrey,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var userData = snapshot.data!.docs[index];
                      return Row(
                        mainAxisAlignment: userData['senderId'] == myId ? MainAxisAlignment.start : MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 05, horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: userData['senderId'] == myId ? Colors.teal.withOpacity(0.3) : Colors.blueGrey.withOpacity(0.4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: userData['msg'] == ""
                                  ? Container(
                                      height: MediaQuery.of(context).size.height * 0.2,
                                      width: MediaQuery.of(context).size.height * 0.2,
                                      child: Image.network(userData['image'], fit: BoxFit.cover))
                                  : Text(
                                      userData['msg'],
                                      style: TextStyle(
                                        color: AppColors.PRIMARY_WHITE,
                                        fontSize: 14,
                                      ),
                                    ),
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MessageTextInput(
                picSelectionTapped: () {
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
                                  uploadImage(ImageSource.gallery);
                                  Navigator.of(context).pop();
                                },
                                title: Text("Upload From Gallery"),
                                trailing: Icon(Icons.photo),
                              ),
                              Divider(thickness: 1, color: AppColors.PRIMARY_GREY),
                              ListTile(
                                onTap: () {
                                  uploadImage(ImageSource.camera);
                                  Navigator.of(context).pop();
                                },
                                title: Text("Upload From Camera"),
                                trailing: Icon(Icons.camera),
                              ),
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
                controller: msgController,
                onPressed: () async {
                  FocusScopeNode focus = FocusScope.of(context);
                  await fireStoreServices().userChat(
                    context: context,
                    myId: myId,
                    userId: widget.userId!,
                    docId: docId,
                    msg: msgController.text.isEmpty ? "" : msgController.text,
                    imageUrl: "",
                  );
                  setState(() {
                    msgController.clear();
                  });
                  if (!focus.hasPrimaryFocus) {
                    focus.unfocus();
                  }
                },
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
  //todo code Refactoring is Remain
}
