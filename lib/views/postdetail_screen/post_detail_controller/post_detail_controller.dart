import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/providers/singlepost.dart';
import 'package:plo/extensions/ref_dipsose.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/repository/firebase_comments_repository.dart';
import 'package:plo/repository/firebase_post_repository.dart';
import 'package:plo/services/like_post_service.dart';
import 'package:plo/views/home_screen/main_post_list_provider.dart';
import 'package:plo/common/providers/user_provider.dart';
import 'package:plo/views/settings_screen/provider/non_login_provider.dart';

import '../../../common/providers/login_verification_provider.dart';

class PostDetailController extends StateNotifier<AsyncValue<void>> {
  Ref ref;
  PostDetailController(this.ref) : super(const AsyncValue.data(null)) {
    _init();
  }

  _init() async {}
  void updateViewCounts(PostModel postKey) async {
    final proceedWithoutLogin = ref.watch(anonymousLogInProvider);
    if (proceedWithoutLogin) {
      return;
    }

    final post = ref.read(singlePostProvider(postKey));

    final user = ref.read(currentUserProvider);

    if (user != null) {
      final bool alreadySeenThePost = post.postViewList.contains(user.userUid);
      if (alreadySeenThePost == false) {
        List<String> updatedViews = post.postViewList;
        updatedViews.add(user.userUid);
        final int result = await ref.watch(firebasePostRepositoryProvider).updateViews(updatedViews, post);
        if (result != -1) {
          PostModel postToBeUpdated = post.update(postViewList: updatedViews);
          _updatePost(postKey, postToBeUpdated);
        }
      }
    }
  }

  void updateComments(PostModel postKey) async {
    final post = ref.read(singlePostProvider(postKey));
    final int commentCount = await ref.watch(firebasePostRepositoryProvider).updateCommentCountInPostModel(postKey.pid);
    if (commentCount != 1) {
      PostModel postToBeUpdated = post.update(commentCount: commentCount);
      _updatePost(postKey, postToBeUpdated);
    }
  }

  void _updatePost(PostModel postKey, PostModel postToBeUpdated) {
    ref.read(singlePostProvider(postKey).notifier).updatePost(postToBeUpdated);

    if (ref.read(mainPostListProvider.notifier).mounted) {
      ref.read(mainPostListProvider.notifier).updateSingePostInPostList(postToBeUpdated);
    }
  }

  void changeTitle(PostModel postKey, String title) {
    final post = ref.read(singlePostProvider(postKey));
    PostModel postToBeUpdated = post.update(postLikes: int.parse(title));
    _updatePost(postKey, postToBeUpdated);
  }

  Future<bool> toggleLike(PostModel postKey, PostModel post) async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      return false;
    }
    int? postLikeCountAfterUpdate = await ref.watch(likedPostServiceProvider).likedPosts(user.userUid, post.pid);

    PostModel postToBeUpdated = post.update(postLikes: postLikeCountAfterUpdate);
    _updatePost(postKey, postToBeUpdated);
    return true;
  }
}

final postDetailControllerProvider = StateNotifierProvider.autoDispose<PostDetailController, AsyncValue<void>>((ref) {
  ref.logDisposeToConsole("postDetailControllerProvider Disposed");
  return PostDetailController(ref);
});
