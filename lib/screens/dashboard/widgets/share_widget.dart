import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareWidget extends StatelessWidget {
  final dynamic data;
  const ShareWidget({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final box = context.findRenderObject() as RenderBox?;
        await Share.share(
          data['postImages'][0],
          subject: data['text'],
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
        );
      },
      child: Icon(Icons.send, color: Colors.white),
    );
  }
}
