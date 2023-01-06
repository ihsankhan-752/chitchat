import 'package:flutter/material.dart';
import 'package:my_insta_clone/utils/colors.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerForDisplayVideo extends StatefulWidget {
  final String? path;
  const VideoPlayerForDisplayVideo({Key? key, this.path}) : super(key: key);

  @override
  State<VideoPlayerForDisplayVideo> createState() => _VideoPlayerForDisplayVideoState();
}

class _VideoPlayerForDisplayVideoState extends State<VideoPlayerForDisplayVideo> {
  VideoPlayerController? controller;
  Future<void>? initializeVideoPlayer;
  @override
  void initState() {
    controller = VideoPlayerController.network(widget.path!);
    initializeVideoPlayer = controller!.initialize();
    // controller!.play();
    // controller!.setLooping();
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
      child: Stack(
        children: [
          VideoPlayer(controller!),
          Center(
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      if (controller!.value.isPlaying) {
                        controller!.pause();
                      } else {
                        controller!.play();
                      }
                    });
                  },
                  // Icons.pause : Icons.play_arrow,
                  icon: controller!.value.isPlaying ? Icon(Icons.pause, size: 25) : Icon(Icons.play_arrow, size: 25),
                  color: AppColors.BTN_COLOR)),
        ],
      ),
    );
  }
}
