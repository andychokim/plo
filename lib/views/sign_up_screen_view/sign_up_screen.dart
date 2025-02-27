import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/validator/validator.dart';
import 'package:plo/common/widgets/custom_app_bar.dart';
import 'package:plo/common/widgets/custom_button.dart';
import 'package:plo/common/widgets/custom_screen.dart';
import 'package:plo/common/widgets/custom_text_input_box.dart';
import 'package:plo/model/erro_handling/error_handler.dart';
import 'package:plo/views/sign_up_screen_view/provider/signup_provider.dart';
import 'package:plo/views/sign_up_screen_view/sign_up_screen_controller.dart';
import 'package:plo/views/sign_up_screen_view/verification_code.dart';
import 'package:plo/views/splash_screen/splash_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordRetype = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordRetype.dispose();
    super.dispose();
  }

  //Pass email and password to signup_provider
  void _setProvider() {
    ref.watch(signUpInfoProvider.notifier).setEmailAndPassword(_email, _password, _passwordRetype);
  }

  void _sendVerifyCodeToEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _setProvider();
      var res = await sendVerifyCodeToEmail(_email);
      res.fold((errorMessage) => ErrorHandler().showSnackBar(context, errorMessage), (response) {
        setState(() {
          _isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => VerifyCodeScreen(
                  emailcontroller: _email,
                  otpHash: response.data!,
                )),
          ),
        );
      });
    }
  }

  static const SizedBox defaultSpacing = SizedBox(height: 20);
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    }
    return CustomInitialScreen(
      appBar: const BackButtonAppBar(),
      padding: const EdgeInsets.symmetric(horizontal: 40),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(children: [
            //나중에 plo로고로 대체해야 합니다.
            const Icon(
              Icons.person,
              size: 80,
            ),

            const Text(
              '회원가입',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            defaultSpacing,

            textInputBox(text: '학교 이메일', controller: _email, validator: (value) => Validator.validatePSUEmail(value)),

            defaultSpacing,

            passwordInputBox(
              text: '비밀번호',
              controller: _password,
              passwordVisible: _isPasswordVisible,
              onPressed: () => setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              }),
              validator: (value) => Validator.validatePassword(value),
            ),

            defaultSpacing,

            passwordInputBox(
              text: '비밀번호 확인',
              controller: _passwordRetype,
              passwordVisible: _isPasswordVisible,
              onPressed: () => setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              }),
              validator: (value) => Validator.isSamePassword(value, _password.text),
            ),

            const SizedBox(height: 90),

            CustomButton(
              text: '인증번호 보내기',
              onPressed: _sendVerifyCodeToEmail,
            ),
            /*
                ButtonBox(
                    text: '인증번호 보내기',
                    boxWidth: 190,
                    boxHeight: 60,
                    buttonFunc: _sendVerifyCodeToEmail),
                */
          ]),
        ),
      ),
    );
  }
}
