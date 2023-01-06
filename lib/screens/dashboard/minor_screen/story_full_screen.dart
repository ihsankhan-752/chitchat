import 'package:flutter/material.dart';
import 'package:my_insta_clone/utils/colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class StoryFullScreen extends StatelessWidget {
  final dynamic data;
  const StoryFullScreen({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(data['storyImage']),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(AppColors.PRIMARY_BLACK.withOpacity(0.7), BlendMode.srcATop),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back, color: AppColors.PRIMARY_WHITE)),
                SizedBox(width: 10),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(data['userImage']),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['username'],
                      style: TextStyle(
                        color: AppColors.PRIMARY_WHITE,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 05),
                    Text(
                      timeago.format(
                        data['createdAt'].toDate(),
                      ),
                      style: TextStyle(
                        color: AppColors.PRIMARY_WHITE,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, color: AppColors.PRIMARY_WHITE))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            height: MediaQuery.of(context).size.height * 0.7,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                    data['storyImage'],
                  ),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  data['text'] == '' ? "" : data['text'],
                  style: TextStyle(
                    color: AppColors.PRIMARY_WHITE,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
