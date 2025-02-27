import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/providers/singlepost.dart';
import 'package:plo/model/comments_model.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/model/user_model.dart';
import 'package:plo/repository/firebase_user_repository.dart';
import 'package:plo/views/comments/comments_widget/commentlists/comments_list_controller.dart';
import 'package:plo/views/comments/comments_widget/comments_detail.dart';
import 'package:plo/views/comments/comments_widget/comments_profile.dart';
import 'package:plo/views/comments/comments_widget/comments_screen.dart';
import 'package:plo/views/comments/comments_widget/single_comment_provider.dart';
import 'package:plo/common/providers/user_provider.dart';
import 'package:plo/views/settings_screen/provider/non_login_provider.dart';

final postDetailCurrentUserFutureProvider =
    FutureProvider.autoDispose<UserModel?>((ref) async {
  final user = await ref.watch(firebaseUserRepositoryProvider).fetchUser();
  return user;
});
final commentUploaderProvider =
    FutureProvider.autoDispose.family<UserModel?, String>((ref, userUid) async {
  final userFetched =
      ref.watch(firebaseUserRepositoryProvider).fetchUserbyUid(userUid);
  return userFetched;
});

class CommentDetailScreen extends ConsumerWidget {
  final CommentModel commentKey;
  final PostModel postKey;
  final bool isFromBlockedUser;
  const CommentDetailScreen(
      {super.key,
      required this.commentKey,
      required this.postKey,
      this.isFromBlockedUser = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final state = ref.watch(
      commentListController(commentKey.commentsPid),
    );

    final comment = ref.watch(singleCommentProvider(commentKey));
    // final isMyComment = ref.watch(proceedWithoutLoginProvider)
    //     ? false
    //     : comment.commentsUserUid == user!.userUid;
    final uploader =
        ref.watch(commentUploaderProvider(comment.commentsUserUid));
    return uploader.when(
      data: (data) {
        if (data == null) {
          return const Text("유저를 찾을 수 없습니다");
        }
        // return state.isLoading
        //     ? CircularProgressIndicator()
        // : Material(
        //     child: SafeArea(
        //       child: Scaffold(
        //           body: SingleChildScrollView(
        //               child: Container(
        //                   child: Column(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Row(
        //             children: [
        //               CommentProfileWidget(commentKey: commentKey),
        //               const SizedBox(width: 10),
        //               CommentDetailWidget(commentKey: commentKey)
        //             ],
        //           ),
        //         ],
        //       )))),
        //     ),
        //   );
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: isFromBlockedUser
              ? Row(
                children: [
                  Center(
                      child: Text("댓글이 차단된 유저입니다!",
                          style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    
                ],
              )
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: CommentProfileWidget(
                      commentKey: commentKey,
                      postKey: postKey,
                    )),
                  ],
                ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const Icon(Icons.error_outline, size: 20),
    );
  }
}
