import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/check_app_requirement/check_app_requirement_usermode_screen.dart';
import 'package:plo/firebase_options.dart';
import 'package:plo/views/log_in_screen/log_in_screen.dart';
import 'package:plo/views/sign_up_screen_view/sign_up_screen.dart';
import 'package:plo/views/splash_screen/splash_screen.dart';
import 'package:plo/views/welcome_screen/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSansKR',
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasError) {
            return const Scaffold(
                body: Center(child: Text("There has been an error")));
          }
          if (snapshot.hasData) {
            return const CheckEmailAndUsermodelScreen();
            // SignInScreen();
          }
          return const SignInScreen();
          // return const WelcomeScreen();
        },
      ),
    );
  }
}
