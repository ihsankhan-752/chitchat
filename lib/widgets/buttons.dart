import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String? title;
  final Function()? onPressed;
  final IconData? icon;
  final bool isIconReq;
  final Color? btnColor;
  final Color? iconColor;
  const PrimaryButton({
    Key? key,
    this.title,
    this.onPressed,
    this.icon,
    this.isIconReq = false,
    this.btnColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () {},
      child: Container(
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: btnColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isIconReq ? Icon(icon, color: iconColor) : SizedBox(),
            isIconReq ? SizedBox(width: 15) : SizedBox(width: 0),
            Text(
              title!,
              style: AppTextStyle.BUTTON_TEXT_STYLE,
            )
          ],
        ),
      ),
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  const SocialLoginButton({Key? key, this.icon, this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.PRIMARY_GREY,
      ),
      child: Center(
        child: Icon(icon, color: iconColor),
      ),
    );
  }
}

class ProfileScreenMainButton extends StatelessWidget {
  final Color? btnColor;
  final Color? borderColor;
  final Function()? onPressed;
  final String? title;
  const ProfileScreenMainButton({Key? key, this.btnColor, this.borderColor, this.onPressed, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      highlightColor: Colors.transparent,
      child: Container(
        height: 35,
        width: 100,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(08), color: btnColor, border: Border.all(color: borderColor!)),
        child: Center(
          child: Text(
            title!,
            style: TextStyle(
              color: AppColors.PRIMARY_WHITE,
            ),
          ),
        ),
      ),
    );
  }
}
