import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/widgets/custom_screen.dart';
import 'package:plo/model/types/enum_type.dart';
import 'package:plo/views/forgot_password/forgot_password_screen.dart';
import 'package:plo/views/home_screen/home_screen.dart';
import 'package:plo/views/log_in_screen/log_in_controller.dart';
import 'package:plo/views/log_in_screen/widgets/log_in_textfield.dart';
import 'package:plo/views/settings_screen/provider/non_login_provider.dart';
import 'package:plo/views/sign_up_screen_view/sign_up_screen.dart';

import '../../common/providers/login_verification_provider.dart';
import '../../common/utils/log_util.dart';
import '../../common/widgets/custom_alert_box.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final snackbar = const SnackBar(content: Text("Invalid email or password"));

  @override
  void dispose() {
    // _formKey.currentState?.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  static const defaultSpacing = SizedBox(height: 10);
  @override
  Widget build(BuildContext context) {
    return CustomInitialScreen(
      appBar: AppBar(
          leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      )),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'People Link One',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Image.asset('assets/images/pennstate_logo.png', width: 130, height: 130),
          const SizedBox(height: 10),
          LogInTextFieldWidget(
            formKey: _formKey,
            emailController: emailController,
            passwordController: passwordController,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                child: const Text("Forgot Password?", style: TextStyle(fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 50,
            width: MediaQuery.sizeOf(context).width * 0.6,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                // showDialog(
                //   context: context,
                //   builder: (context) => const Center(
                //     child: CircularProgressIndicator(),
                //   ),
                // );
                if (_formKey.currentState!.validate()) {
                  final result = await ref.watch(loginController.notifier).loginWithEmail();
                  Navigator.of(context).pop();

                  if (result == ReturnTypeENUM.success.toString()) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          defaultSpacing,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: MediaQuery.sizeOf(context).width * 0.6,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("New User? Sign-Up",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 80),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("로그인 없이 계속하기", style: TextStyle(color: Colors.black)),
            onPressed: () async {
              bool isConfirmed = false;
              isConfirmed = (await AlertBox.showYesOrNoAlertDialogue(context, "정말로 로그인 없이 계속하시겠습니까?"))!;
              if (isConfirmed) {
                ref.watch(anonymousLogInProvider.notifier).state = true;
                final result = await ref.watch(loginController.notifier).nonUserLogin();
                if (result == ReturnTypeENUM.success.toString()) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }
              }
            },
          )
        ],
      ),
    );
  }
}
