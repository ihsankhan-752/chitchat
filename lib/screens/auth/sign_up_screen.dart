import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_insta_clone/screens/auth/widgets/image_picking_dialog_box.dart';

import '../../services/auth_services.dart';
import '../../utils/colors.dart';
import '../../utils/custom_messanger.dart';
import '../../utils/screen_navigations.dart';
import '../../utils/text_styles.dart';
import '../../widgets/buttons.dart';
import '../../widgets/text_input.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isVisible = true;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  File? image;
  ImagePicker picker = ImagePicker();
  pickImage(ImageSource source) async {
    XFile? pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    bioController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signUp() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        image == null ||
        usernameController.text.isEmpty ||
        bioController.text.isEmpty) {
      showMessage(context, "All Fields are required");
    } else {
      setState(() {
        isLoading = true;
      });
      String res = await AuthServices().signUp(
        context: context,
        email: emailController.text,
        password: passwordController.text,
        file: image!,
        bio: bioController.text,
        username: usernameController.text,
      );
      setState(() {
        image = null;
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
      appBar: AppBar(
        centerTitle: true,
        title: Text("Create Your Account", style: AppTextStyle.MAIN_HEADING.copyWith(fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  child: Stack(
                    children: [
                      Center(
                        child: image == null
                            ? CircleAvatar(radius: 55, backgroundColor: Colors.grey, backgroundImage: AssetImage("assets/images/guest.png"))
                            : CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.grey,
                                backgroundImage: FileImage(image!),
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppColors.BTN_COLOR,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.BTN_COLOR),
                          ),
                          child: InkWell(
                            onTap: () {
                              imagePickingDialogBox(
                                  context: context,
                                  cameraTapped: () {
                                    Navigator.of(context).pop();
                                    pickImage(ImageSource.camera);
                                  },
                                  galleryTapped: () {
                                    Navigator.of(context).pop();
                                    pickImage(ImageSource.gallery);
                                  });
                            },
                            child: Icon(Icons.image, color: AppColors.PRIMARY_WHITE, size: 20),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextInputField(
                controller: usernameController,
                hintText: "username",
                prefixIcon: Icons.person,
              ),
              SizedBox(height: 20),
              TextInputField(
                controller: emailController,
                hintText: "email",
                prefixIcon: Icons.email,
              ),
              SizedBox(height: 20),
              TextInputField(
                controller: passwordController,
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
              TextInputField(
                controller: bioController,
                hintText: "bio",
                prefixIcon: Icons.edit,
              ),
              SizedBox(height: 30),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    )
                  : PrimaryButton(
                      onPressed: () {
                        signUp();
                      },
                      title: "Sign Up",
                      btnColor: AppColors.BTN_COLOR,
                    ),
              SizedBox(height: 40),
              InkWell(
                highlightColor: AppColors.PRIMARY_BLACK,
                onTap: () {
                  navigateToNext(context, LoginScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an Account?",
                      style: AppTextStyle.BUTTON_TEXT_STYLE.copyWith(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      " Sign In",
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
      ),
    );
  }
}
