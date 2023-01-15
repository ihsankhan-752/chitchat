import 'package:flutter/material.dart';
import 'package:my_insta_clone/screens/auth/sign_up_screen.dart';

import '../../utils/colors.dart';
import '../../utils/screen_navigations.dart';
import '../../utils/text_styles.dart';
import '../../widgets/buttons.dart';
import '../auth/login_screen.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset("assets/images/logo.png")),
            SizedBox(height: 20),
            Text(
              "Let's You in",
              style: AppTextStyle.MAIN_HEADING.copyWith(color: AppColors.BTN_COLOR),
            ),
            SizedBox(height: 20),
            PrimaryButton(
              onPressed: () {
                navigateToNext(context, SignUpScreen());
              },
              isIconReq: true,
              title: "Register Yourself",
              icon: Icons.login,
              iconColor: AppColors.SKY,
              btnColor: AppColors.PRIMARY_GREY,
            ),
            SizedBox(height: 20),
            PrimaryButton(
              onPressed: () {
                navigateToNext(context, LoginScreen());
              },
              isIconReq: true,
              title: "Login With Email",
              icon: Icons.email,
              iconColor: Colors.red,
              btnColor: AppColors.PRIMARY_GREY,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
