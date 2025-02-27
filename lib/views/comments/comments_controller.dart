import 'dart:developer';

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/model/comments_model.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/model/state_model/create_edit_comment_model.dart';
import 'package:plo/repository/firebase_comments_repository.dart';
import 'package:plo/views/comments/comments_provider.dart';
import 'package:plo/views/comments/comments_widget/commentlists/comments_list_provider.dart';
import 'package:plo/common/providers/user_provider.dart';
import 'package:uuid/uuid.dart';

class CreateEditCommentController extends StateNotifier<AsyncValue<void>> {
  final SwiperController _swiperController = SwiperController();
  final TextEditingController _commentContentController =
      TextEditingController();
  final Ref ref;

  CreateEditCommentController(this.ref) : super(const AsyncLoading()) {
    _init();
  }
  SwiperController get swiperController => _swiperController;
  TextEditingController get commentContentController =>
      _commentContentController;

  _init() async {
    state = const AsyncLoading();

    if (ref.read(createEditCommentStateProvider).isForEdit) {
      final CommentModel commentStateModel =
          ref.read(createEditCommentStateProvider).editCommentInformation!;
      _commentContentController.text = commentStateModel.commentContent;
    }
    log("create comment controller init");
  }

  initFieldForEdit(CreateEditCommentModel editCommentInformation) {
    _commentContentController.text = editCommentInformation.commentContent;
  }

  Future<bool> uploadComment(
      {required GlobalKey<FormState> formKey, required String postPid}) async {
    try {
      if (!formKey.currentState!.validate()) {
        return false;
      }
      final commentState = ref.read(createEditCommentStateProvider);

      final isForEdit = commentState.isForEdit;

      if (ref.read(currentUserProvider.notifier).mounted == false ||
          ref.read(currentUserProvider) == null) {
        state = AsyncError("CurrentUserSignedIn Error", StackTrace.current);
        state = const AsyncData(null);
        return false;
      }
      final user = ref.read(currentUserProvider)!;
      final String cid = isForEdit
          ? commentState.editCommentInformation!.cid
          : const Uuid().v1();

      CommentModel comment;
      if (isForEdit) {
        comment = commentState.editCommentInformation!.update(
          commentContent: _commentContentController.text,
        );
      } else {
        comment = CommentModel(
          cid: cid,
          commentContent: _commentContentController.text,
          profileImageUrl: user.profileImageUrl,
          commentsUserNickname: user.userNickname,
          commentsUserUid: user.userUid,
          uploadTime: Timestamp.now(),
          commentsPid: postPid,
        );
      }
      log('Uploading comment: $comment');

      final commentUploadResult =
          await ref.watch(firebaseCommentRepository).uploadCommentToFirebase(
                postPid,
                comment,
                isForEdit,
              );
      if (commentUploadResult == false) {
        state = AsyncError("Error while Uploading commentModel to Firebase",
            StackTrace.current);
        state = const AsyncData(null);
        return false;
      }
      if (isForEdit) {
        ref
            .read(commentListProvider(postPid).notifier)
            .updateSingleCommentInCommentList(comment);
      } else {
        ref
            .read(commentListProvider(postPid).notifier)
            .addSingleComment(comment);
      }
      return true;
    } catch (error) {
      log("Error occursed ${error.toString()}");
      return false;
    }
  }

  // Future<bool> deleteComment(PostModel post, CommentModel comment) async {
  //   try {
  //     state = const AsyncLoading();
  //     final deleteCommentResult = await ref
  //         .watch(firebaseCommentRepository)
  //         .deleteComments(post, comment);

  //     if (!deleteCommentResult) {
  //       state = AsyncError("Error while deleting comment from the firebase",
  //           StackTrace.current);
  //       state = const AsyncData(null);
  //       return false;
  //     }
  //     state = const AsyncData(null);
  //     return true;
  //   } catch (error) {
  //     state = AsyncError(
  //         "Error deleting comment: ${error.toString()}", StackTrace.current);
  //     log("There was an error while deleting a comment ${error.toString()}");
  //     return false;
  //   }
  // }
}

final createEditCommentController =
    StateNotifierProvider<CreateEditCommentController, AsyncValue<void>>((ref) {
  return CreateEditCommentController(ref);
});
