import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
              style: AppTextStyle.MAIN_HEADING,
            ),
            SizedBox(height: 20),
            PrimaryButton(
              isIconReq: true,
              title: "Continue With Facebook",
              icon: FontAwesomeIcons.facebook,
              iconColor: AppColors.SKY,
              btnColor: AppColors.PRIMARY_GREY,
            ),
            SizedBox(height: 20),
            PrimaryButton(
              isIconReq: true,
              title: "Continue With Google",
              icon: FontAwesomeIcons.google,
              iconColor: Colors.red,
              btnColor: AppColors.PRIMARY_GREY,
            ),
            SizedBox(height: 20),
            PrimaryButton(
              isIconReq: true,
              title: "Continue With Apple",
              icon: FontAwesomeIcons.apple,
              iconColor: AppColors.PRIMARY_WHITE,
              btnColor: AppColors.PRIMARY_GREY,
            ),
            SizedBox(height: 30),
            Center(child: Text("Or", style: AppTextStyle.BUTTON_TEXT_STYLE)),
            SizedBox(height: 30),
            PrimaryButton(
              onPressed: () {
                navigateToNext(context, LoginScreen());
              },
              title: "Sign in with Password",
              btnColor: AppColors.BTN_COLOR,
            ),
            SizedBox(height: 30),
            InkWell(
              onTap: () {
                navigateToNext(context, SignUpScreen());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an Account?",
                    style: AppTextStyle.BUTTON_TEXT_STYLE.copyWith(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    " Sign Up",
                    style: AppTextStyle.BUTTON_TEXT_STYLE.copyWith(
                      fontSize: 12,
                      color: AppColors.APP_CIRCULAR_RADIUS,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
