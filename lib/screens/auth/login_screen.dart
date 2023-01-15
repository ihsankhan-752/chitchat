import 'package:flutter/material.dart';
import 'package:my_insta_clone/screens/auth/widgets/footer_and_google_sign_in.dart';

import '../../services/auth_services.dart';
import '../../utils/colors.dart';
import '../../utils/custom_messanger.dart';
import '../../utils/text_styles.dart';
import '../../widgets/buttons.dart';
import '../../widgets/text_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isVisible = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showMessage(context, "All Filed are Required");
    } else {
      setState(() {
        isLoading = true;
      });
      String res = await AuthServices().signIn(context, _emailController.text, _passwordController.text);
      setState(() {
        isLoading = false;
      });
      if (res == 'success') {
        showMessage(context, res);
      } else {
        showMessage(context, res);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text("Login to Your\nAccount", style: AppTextStyle.MAIN_HEADING),
              SizedBox(height: 30),
              TextInputField(controller: _emailController, hintText: "email", prefixIcon: Icons.email),
              SizedBox(height: 20),
              TextInputField(
                controller: _passwordController,
                hintText: "password",
                prefixIcon: Icons.lock,
                isTextSecure: isVisible,
                suffixChild: IconButton(
                  icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot Password?",
                  style: AppTextStyle.BUTTON_TEXT_STYLE.copyWith(color: AppColors.BTN_COLOR),
                ),
              ),
              SizedBox(height: 20),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    )
                  : PrimaryButton(
                      onPressed: () {
                        signIn();
                      },
                      title: "Sign In",
                      btnColor: AppColors.BTN_COLOR,
                    ),
              SizedBox(height: 80),
              Center(
                child: Text(
                  "or continue with",
                  style: AppTextStyle.BUTTON_TEXT_STYLE.copyWith(
                    color: AppColors.PRIMARY_WHITE,
                  ),
                ),
              ),
              FooterAndGoogleSignUpWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
