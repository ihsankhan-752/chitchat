import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoLinkScreen extends StatefulWidget {
  const VideoLinkScreen({Key? key}) : super(key: key);

  @override
  State<VideoLinkScreen> createState() => _VideoLinkScreenState();
}

class _VideoLinkScreenState extends State<VideoLinkScreen> {
  String? url;
  File? pickedFile;

  Future selectFile() async {
    final result = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (result == null) return;
    setState(() {
      pickedFile = File(result.path);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          pickedFile == null
              ? Container(
                  height: 200,
                  color: Colors.red,
                  child: Center(
                    child: Text("No File Selected"),
                  ),
                )
              : Container(
                  height: 200,
                  color: Colors.red,
                  child: Center(
                    child: VideoPlayerWidget(
                      path: File(pickedFile!.path),
                    ),
                  ),
                ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              selectFile();
            },
            child: Container(
              height: 35,
              width: 300,
              color: Colors.orange,
              child: Center(
                child: Text("Pick"),
              ),
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () async {
              final ref = FirebaseStorage.instance.ref().child(DateTime.now().millisecondsSinceEpoch.toString());
              await ref.putFile(File(pickedFile!.path));
              url = await ref.getDownloadURL();
              await FirebaseFirestore.instance.collection("videos").add({
                "link": url,
              });
            },
            child: Container(
              height: 35,
              width: 100,
              color: Colors.red,
              child: Center(
                child: Text("Click"),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final File? path;
  const VideoPlayerWidget({Key? key, this.path}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? controller;
  Future<void>? initializeVideoPlayer;
  @override
  void initState() {
    controller = VideoPlayerController.file(widget.path!);
    initializeVideoPlayer = controller!.initialize();
    controller!.play();
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: VideoPlayer(
        controller!,
      ),
    );
  }
}
