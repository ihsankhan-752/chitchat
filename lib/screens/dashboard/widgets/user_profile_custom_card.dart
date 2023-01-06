import 'package:flutter/material.dart';
import 'package:my_insta_clone/utils/colors.dart';

class UserProfileCustomCard extends StatelessWidget {
  final int? value;
  final String? title;
  final Function()? onPressed;
  const UserProfileCustomCard({Key? key, this.value, this.title, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: onPressed ?? () {},
        child: Column(
          children: [
            Text(
              value.toString(),
              style: TextStyle(color: AppColors.PRIMARY_WHITE),
            ),
            SizedBox(height: 5),
            Text(
              title!,
              style: TextStyle(
                color: AppColors.PRIMARY_WHITE,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
