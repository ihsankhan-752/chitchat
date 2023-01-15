import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/auth_services.dart';
import '../../../utils/colors.dart';
import '../../../utils/screen_navigations.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/buttons.dart';
import '../sign_up_screen.dart';

class FooterAndGoogleSignUpWidget extends StatelessWidget {
  const FooterAndGoogleSignUpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  AuthServices().signInWithGoogle(context);
                },
                child: SocialLoginButton(icon: FontAwesomeIcons.google, iconColor: Colors.red),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        InkWell(
          highlightColor: AppColors.PRIMARY_BLACK,
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
    );
  }
}
