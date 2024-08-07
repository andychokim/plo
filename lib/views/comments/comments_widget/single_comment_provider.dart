import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/providers/singlepost.dart';
import 'package:plo/model/comments_model.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/repository/firebase_comments_repository.dart';

class SingleCommentProvider extends StateNotifier<CommentModel> {
  final CommentsRepository firebaseCommentRepository;
  final CommentModel comment;
  SingleCommentProvider({
    required this.firebaseCommentRepository,
    required this.comment,
  }) : super(comment);

  updateComment(CommentModel comment) {
    state = comment;
  }

  Future<void> updateCommentFromServer() async {
    final comment = await firebaseCommentRepository.fetchCommentByCid(
        state.commentsPid, state.cid);

    if (comment != null) {
      state = comment;
      log("Updating a comment from Server");
    } else {
      log("Comment not found on the server");
    }
  }
}

//확인 한번 해야 함....

final singleCommentProvider = StateNotifierProvider.family
    .autoDispose<SingleCommentProvider, CommentModel, CommentModel>(
        (ref, comment) {
  return SingleCommentProvider(
    firebaseCommentRepository: ref.watch(firebaseCommentRepository),
    comment: comment,
  );
});
