import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/utils/log_util.dart';

import '../../../common/providers/user_provider.dart';
import '../../../model/post_model.dart';
import '../../../repository/firebase_post_repository.dart';
import '../../../repository/firebase_user_repository.dart';

class MypostController extends StateNotifier<AsyncValue<List<PostModel>>> {
  Ref ref;
  FirebaseUserRepository firebaseUserRepository;

  MypostController(this.ref, this.firebaseUserRepository) : super(const AsyncLoading()) {
    _init();
  }

  Future<void> _init() async {
    log("mypost controller init");

    state = const AsyncLoading();
    final user = ref.read(currentUserProvider);

    if (user != null) {
      try {
        final List<PostModel>? postsFetched = await ref.watch(firebasePostRepositoryProvider).getUsersActivePost(userUid: user.userUid);

        if (postsFetched != null) {
          logToConsole('fetched posts: $postsFetched');
          state = AsyncData(postsFetched);
        } else {
          logToConsole('no posts fetched');
          state = const AsyncData([]); // null -> for error. No posts fetched means returning an empty list to the state
        }
      } catch (e) {
        logToConsole('Error fetching posts');
        state = AsyncError(e, StackTrace.current);
      }
    } else {
      logToConsole('User is null');
      state = AsyncError("user is null", StackTrace.current);
    }
  }

  // refreshing mypost_screen
  Future<void> refreshPosts() async {
    await _init(); // Re-fetch posts when called
  }
}

final myPostControllerProvider = StateNotifierProvider.autoDispose<MypostController, AsyncValue<List<PostModel>>>((ref) {
  final firebaseUserRepository = ref.watch(firebaseUserRepositoryProvider);
  return MypostController(ref, firebaseUserRepository);
});
