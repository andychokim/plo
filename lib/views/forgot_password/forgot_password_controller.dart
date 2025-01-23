import 'package:plo/model/types/enum_type.dart';
import 'package:plo/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ForgotPasswordController(this.ref) : super(const AsyncValue.loading());

  get emailController => _emailController;
  get formKey => _formKey;

  Future<bool> sendResetPasswordEmail() async {
    if (_formKey.currentState!.validate()) {
      final result = await ref
          .read(authRepository)
          .sendPasswordEmail(_emailController.text);
      if (result != ReturnTypeENUM.success.toString()) {
        state = AsyncValue.error(result, StackTrace.current);
        return false;
      }
      return true;
    }
    return false;
  }

  Future<bool> resendResetPasswordEmail() async {
    if (_formKey.currentState!.validate()) {
      final result = await ref
          .read(authRepository)
          .sendPasswordEmail(_emailController.text);
      if (result != ReturnTypeENUM.success.toString()) {
        state = AsyncValue.error(result, StackTrace.current);
      }
      return false;
    }
    return true;
  }
}

final forgotPasswordControllerProvider = StateNotifierProvider.autoDispose<
    ForgotPasswordController, AsyncValue<void>>((ref) {
  return ForgotPasswordController(ref);
});
