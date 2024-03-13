import 'package:email_vertify/common/validator/validator.dart';
import 'package:email_vertify/common/widgets/custom_app_bar.dart';
import 'package:email_vertify/views/forgot_password/forgot_password_check_email/check_email_Screen.dart';
import 'package:email_vertify/views/forgot_password/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Forgot Password'),
              ),
            ),
            Expanded(
              flex: 6,
              child: Form(
                key: ref
                    .watch(forgotPasswordControllerProvider.notifier)
                    .formKey,
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
            ),
            Expanded(
              child: TextButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()));
                  final result = await ref
                      .watch(forgotPasswordControllerProvider.notifier)
                      .sendResetPasswordEmail();
                  Navigator.of(context).pop;
                  if (result) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const forgotPasswordCheckEmailScreen(),
                      ),
                    );
                  }
                },
                child: const Text("Next"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
