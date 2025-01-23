import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/widgets/custom_app_bar.dart';
import 'package:plo/views/forgot_password/forgot_password_controller.dart';
import 'package:plo/views/home_screen/home_screen.dart';
import 'package:plo/views/log_in_screen/log_in_screen.dart';

class ForgotPasswordCheckEmailScreen extends ConsumerWidget {
  const ForgotPasswordCheckEmailScreen({super.key});

  static const defaultSpacing = SizedBox(height: 10);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Check your Email"),
                  defaultSpacing,
                  const Text("We sent the reset password to the email"),
                  defaultSpacing,
                  const Text("Did not receive an Email?"),
                  defaultSpacing,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black),
                    child: const Text("Resend",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      const snackBar =
                          SnackBar(content: Text("failed to send an email"));
                      const snackBar2 = SnackBar(
                        content: Text("we have resent the email"),
                      );
                      final result = await ref
                          .read(forgotPasswordControllerProvider.notifier)
                          .resendResetPasswordEmail();
                      if (!result) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                    },
                  ),
                  SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      );
                    },
                    child: const Text("Go Back To Login Screen",
                        style: TextStyle(color: Colors.white)),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
