import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/model/comments_model.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/model/state_model/create_edit_comment_model.dart';
import 'package:plo/model/user_model.dart';
import 'package:plo/repository/firebase_comments_repository.dart';
import 'package:plo/repository/firebase_post_repository.dart';
import 'package:plo/repository/firebase_user_repository.dart';
import 'package:plo/views/comments/comments_controller.dart';
import 'package:plo/views/comments/comments_widget/commentlists/commentlist_screen.dart';
import 'package:plo/views/comments/comments_widget/commentlists/comments_list_controller.dart';
import 'package:plo/views/comments/comments_provider.dart';

final commentUploaderProvider = FutureProvider.autoDispose.family<UserModel?, String>((ref, userUid) async {
  final userFetched = ref.watch(firebaseUserRepositoryProvider).fetchUserbyUid(userUid);
  return userFetched;
});
final postDetailFutureProvider =
    FutureProvider.autoDispose.family<PostModel?, String>((ref, postPid) async {

  final firebasePostRepository = ref.watch(firebasePostRepositoryProvider);
  return await firebasePostRepository.fetchPostByPostPid(postPid);
});
final commentDetailCurrentUserFutureProvider = FutureProvider.autoDispose<UserModel?>((ref) async {
  final user = await ref.watch(firebaseUserRepositoryProvider).fetchUser();
  return user;
});

class CommentScreen extends ConsumerStatefulWidget {
  final CreateEditCommentModel? editCommentInformation;
  final PostModel postKey;

  const CommentScreen({
    super.key,
    this.editCommentInformation,
    required this.postKey,
  });
  @override
  ConsumerState<CommentScreen> createState() => _CommentWriteScreenState();
}

class _CommentWriteScreenState extends ConsumerState<CommentScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.editCommentInformation != null) {
        ref.watch(createEditCommentController.notifier).initFieldForEdit(widget.editCommentInformation!);
        ref.watch(createEditCommentStateProvider.notifier).initForEdit(widget.editCommentInformation!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // var commentState = ref.watch(createEditCommentStateProvider);
    final post = ref.watch(postDetailFutureProvider(widget.postKey.pid));
    return post.when(
      data: (post) {
        if (post == null) {
          return Center(child: Text("댓글이 존재하지 않습니다"));
        }
        ref.watch(commentListController(post.pid));
        return CommentListScreen(
          postKey: post,
        );
      },
      loading: () => const SizedBox(width: 20, height: 20, child: Center(child: CircularProgressIndicator())),
      error: ((error, stackTrace) => Center(
            child: Text(
              "Error: ${error.toString()}",
            ),
          )),
    );
  }
}

// class CommentsList extends ConsumerWidget {
//   final String postId;

//   const CommentsList({Key? key, required this.postId}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final comments = ref.watch(commentListProvider(postId));

//     return ListView.builder(
//       physics: NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: comments.length,
//       itemBuilder: (context, index) {
//         final comment = comments[index];
//         return ListTile(
//           title: Text(comment.commentContent),
//           subtitle: Text(comment.commentsUserNickname),
//         );
//       },
//     );
//   }
// }
