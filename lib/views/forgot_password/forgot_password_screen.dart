import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/validator/validator.dart';
import 'package:plo/common/widgets/custom_app_bar.dart';
import 'package:plo/views/Forgot_password/Forgot_password_controller.dart';
import 'package:plo/views/forgot_password/forgot_password_check_email/check_email_Screen.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const BackButtonAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Forgot Password', style: TextStyle(fontSize: 24)),
              ),
              const SizedBox(height: 20), // Adding some space
              Form(
                key:
                    ref.read(forgotPasswordControllerProvider.notifier).formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                        controller: ref
                            .watch(forgotPasswordControllerProvider.notifier)
                            .emailController,
                        validator: (value) => Validator.validatePSUEmail(value),
                        decoration: const InputDecoration(
                          hintText: "Enter your Email Address",
                          helperText:
                              "We will send a link to reset your password",
                        ))
                  ],
                ),
              ),
              const SizedBox(
                  height: 20), // Adding space between form and button
              TextButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()));
                  final result = await ref
                      .watch(forgotPasswordControllerProvider.notifier)
                      .sendResetPasswordEmail();
                  Navigator.of(context).pop(); // Fixed pop function
                  if (result) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ForgotPasswordCheckEmailScreen(),
                      ),
                    );
                  }
                },
                child: const Text("Next"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
