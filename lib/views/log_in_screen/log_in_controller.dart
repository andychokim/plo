import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/model/user_model.dart';
import 'package:plo/repository/auth_repository.dart';
import 'package:plo/repository/firebase_user_repository.dart';
import 'package:plo/views/post_write/user_provider/user_provider.dart';

class LoginWithEmailController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  LoginWithEmailController(this.ref) : super(const AsyncValue.data(null));

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  Future<String> loginWithEmail() async {
    state = const AsyncValue.loading();
    final result = await ref
        .watch(authRepository)
        .signInUserWithEmail(_emailController.text, _passwordController.text);
    final user = ref.watch(firebaseUserRepositoryProvider).currentUser;
    try {
      if (user == null) {
        state = AsyncValue.error("User Not found", StackTrace.current);
        return "User Not Found";
      }
      UserModel? userFetched =
          await ref.read(firebaseUserRepositoryProvider).fetchUser();
      if (userFetched == null) {
        state = AsyncValue.error(
            "User Does not exist in the model", StackTrace.current);
        return "User Does not exist in the database";
      } else {
        ref.read(currentUserProvider.notifier).setUser(userFetched);
      }
      return result;
    } catch (error) {
      state = AsyncValue.error(error.toString(), StackTrace.current);
      return error.toString();
    }
  }
}

final loginController = StateNotifierProvider.autoDispose<
    LoginWithEmailController,
    AsyncValue<void>>((ref) => LoginWithEmailController(ref));
