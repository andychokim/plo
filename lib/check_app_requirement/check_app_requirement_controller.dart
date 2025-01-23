import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plo/common/providers/admin_provider.dart';
import 'package:plo/extensions/ref_dipsose.dart';
import 'package:plo/model/user_model.dart';
import 'package:plo/repository/firebase_user_repository.dart';
import 'package:plo/views/post_write/user_provider/user_provider.dart';

class CheckAppRequirementController extends StateNotifier<AsyncValue<void>> {
  final BuildContext context;
  Ref ref;
  CheckAppRequirementController(this.ref, this.context)
      : super(const AsyncValue.loading()) {
    _init();
  }

  // Check for app requirement
  // 1. Check if usermodel is in the firebase
  void _init() async {
    state = const AsyncValue.loading();

    // For users who are not logged in
    final user = ref.watch(firebaseUserRepositoryProvider).currentUser;
    if (user == null) {
      // print("User is null");
      state = const AsyncValue.data(null);
      return;
    }

    UserModel? userFetched =
        await ref.watch(firebaseUserRepositoryProvider).fetchUser();
    if (userFetched == null) {
      // User is not in the database
      // print("User fetched null");
      // ref.watch(isProfileSetUpProvider.notifier).state = false;
    } else {
      // print("User fetched not null");
      // ref.watch(isProfileSetUpProvider.notifier).state = true;
      ref.read(currentUserProvider.notifier).setUser(userFetched);
    }
    final isUserAdmin = await ref
        .watch(firebaseUserRepositoryProvider)
        .userAdmin(FirebaseAuth.instance.currentUser!.uid);
    log("Is user admin: $isUserAdmin");

    ref.read(isAdminProvider.notifier).state = isUserAdmin;

    state = const AsyncValue.data(null);
  }
}

final checkAppRequirementControllerProvider = StateNotifierProvider.family
    .autoDispose<CheckAppRequirementController, AsyncValue<void>, BuildContext>(
        (ref, context) {
  ref.logDisposeToConsole("checkAppRequirementControllerProvider");
  return CheckAppRequirementController(ref, context);
});
