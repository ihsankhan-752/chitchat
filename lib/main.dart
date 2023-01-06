import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:my_insta_clone/providers/image_controller.dart';
import 'package:my_insta_clone/screens/splash/splash_screen.dart';
import 'package:my_insta_clone/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: AppColors.PRIMARY_BLACK,
            backgroundColor: AppColors.PRIMARY_BLACK,
            scaffoldBackgroundColor: AppColors.PRIMARY_BLACK,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.PRIMARY_BLACK,
            )),

        // home: VideoLinkScreen(),
        home: SplashScreen(),
      ),
    );
  }
}
