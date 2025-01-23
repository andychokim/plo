import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/providers/singlepost.dart';
import 'package:plo/common/widgets/detail_no_like_button.dart';
import 'package:plo/model/comments_model.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:plo/repository/firebase_comments_repository.dart';
import 'package:plo/repository/firebase_user_repository.dart';
import 'package:plo/views/comments/comments_controller.dart';
import 'package:plo/views/comments/comments_widget/commentlists/comments_list_controller.dart';
import 'package:plo/views/comments/comments_widget/comments_contentform.dart';
import 'package:plo/views/comments/comments_widget/comments_screen.dart';
import 'package:plo/views/comments/comments_widget/single_comment_provider.dart';
import 'package:plo/views/post_write/user_provider/user_provider.dart';
import 'package:plo/views/postdetail_screen/homescreenbuttonwidget.dart';
import 'package:plo/views/postdetail_screen/other_post/postdetailuserotherposts.dart';
import 'package:plo/views/postdetail_screen/post_detail_controller/post_detail_controller.dart';
import 'package:plo/views/postdetail_screen/post_like_button.dart';
import 'package:plo/views/postdetail_screen/postdetailProfile.dart';
import 'package:plo/views/postdetail_screen/postdetaildescription.dart';
import 'package:plo/views/postdetail_screen/postdetailsamecategory.dart';
import 'package:plo/views/settings_screen/provider/non_login_provider.dart';

final postUploaderProvider =
    FutureProvider.autoDispose.family<UserModel?, String>((ref, userUid) async {
  final userFetched =
      await ref.watch(firebaseUserRepositoryProvider).fetchUserbyUid(userUid);
  return userFetched;
});

final postDetailCurrentUserFutureProvider =
    FutureProvider.autoDispose<UserModel?>((ref) async {
  final user = await ref.watch(firebaseUserRepositoryProvider).fetchUser();
  return user;
});

class PostDetailScreen extends ConsumerWidget {
  final PostModel postKey;
  const PostDetailScreen({super.key, required this.postKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    ref.watch(postDetailControllerProvider.notifier).updateViewCounts(postKey);
    ref.watch(postDetailControllerProvider.notifier).updateComments(postKey);
    final state = ref.watch(postDetailControllerProvider);
    final isNotSignedUser = ref.watch(proceedWithoutLoginProvider);
    final user = ref.watch(currentUserProvider);
    final isMyPost = ref.watch(proceedWithoutLoginProvider)
        ? false
        : postKey.uploadUserUid == user!.userUid;
    final post = ref.watch(singlePostProvider(postKey));

    return ref.watch(postUploaderProvider(post.uploadUserUid)).when(
          data: (data) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Colors.transparent,
                actions: [
                  PostFloatingButton(postKey: postKey, parentContext: context)
                ],
              ),
              body: SafeArea(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 60),
                                  PostDetailProfileWidget(postKey: postKey),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: PostDetailWidget(postKey: postKey),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: isNotSignedUser
                                            ? const DetailNoLikeButton()
                                            : SizedBox(
                                                child: PostDetailLikeButton(
                                                    postKey: postKey),
                                              ),
                                      ),
                                      const Icon(Icons.comment),
                                      Text(post.commentCount.toString()),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  const Divider(thickness: 1),
                                ],
                              ),
                            ),
                          ),
                          // Insert the Comment Screen as a SliverToBoxAdapter
                          SliverFillRemaining(
                            hasScrollBody: true,
                            child: CommentScreen(postKey: postKey),
                          ),
                          // If needed, you can add additional sections here
                          // like related posts or more content as slivers
                        ],
                      ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: SafeArea(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 350,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CommentContentForm(formKey: _formKey),
                                      const SizedBox(height: 5),
                                      Container(
                                        width: 350,
                                        height: 60,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                          ),
                                          onPressed: () async {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) =>
                                                  const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              ),
                                            );
                                            final result = await ref
                                                .read(
                                                    createEditCommentController
                                                        .notifier)
                                                .uploadComment(
                                                  formKey: _formKey,
                                                  postPid: postKey.pid,
                                                );
                                            Navigator.of(context).pop();
                                            if (result == true) {
                                              await Future.delayed(
                                                  const Duration(
                                                      milliseconds: 100));
                                              Navigator.of(context).pop();
                                              ref.refresh(commentListController(
                                                  postKey.pid));
                                              ref
                                                  .read(
                                                      createEditCommentController
                                                          .notifier)
                                                  .commentContentController
                                                  .clear();
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content:
                                                      Text("댓글을 올리는데 실패 했습니다."),
                                                ),
                                              );
                                            }
                                          },
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.comment,
                                                  color: Colors.white),
                                              Spacer(),
                                              Text(
                                                "글 작성",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10)
                                    ],
                                  ),
                                ),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0),
                                  ),
                                ),
                                backgroundColor: Colors.white,
                                isScrollControlled: true,
                              );
                            },
                            child: const Text(
                              "글 쓰기 ",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) => const Icon(Icons.error_outline),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}
