import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/utils/log_util.dart';
import 'package:plo/model/user_model.dart';
import 'package:plo/repository/firebase_user_repository.dart';

class UserProvider extends StateNotifier<UserModel?> {
  final Ref ref;
  UserProvider(this.ref) : super(null);

  void setUser(UserModel? user) {
    state = user;
    print(
        "currently signed in as ${user?.userNickname}. UID: ${user?.userUid}}");
  }

  Future<bool> updateUserFromFirebase() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      final user = await ref.watch(firebaseUserRepositoryProvider).fetchUser();
      if (user != null) {
        log("User fetched from Firebase: ${user.userNickname}");
        state = user;
      } else {
        log("No user data returned from Firebase");
      }
    } catch (e) {
      log("Error fetching user from Firebase $e");
    }

    return true;
  }
}

final currentUserProvider =
    StateNotifierProvider<UserProvider, UserModel?>((ref) {
  ref.onDispose(() {
    logToConsole("currentUserProvider disposed");
  });
  return UserProvider(ref);
});
