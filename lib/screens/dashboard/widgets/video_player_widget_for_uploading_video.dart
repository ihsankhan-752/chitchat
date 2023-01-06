import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
    controller!.setLooping(true);
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
      height: MediaQuery.of(context).size.height * 0.6,
      child: VideoPlayer(
        controller!,
      ),
    );
  }
}
