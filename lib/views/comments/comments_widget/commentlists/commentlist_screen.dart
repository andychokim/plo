import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:plo/common/widgets/loading_widgets/expanded_loading_post.dart';
import 'package:plo/common/widgets/loading_widgets/loading_expanded_comments.dart';
import 'package:plo/common/widgets/loading_widgets/loading_expanded_post.dart';
import 'package:plo/common/widgets/no_comments_found.dart';
import 'package:plo/common/widgets/no_more_comments.dart';
import 'package:plo/common/widgets/no_more_post.dart';
import 'package:plo/model/comments_model.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/model/user_model.dart';
import 'package:plo/repository/firebase_comments_repository.dart';
import 'package:plo/repository/firebase_user_repository.dart';
import 'package:plo/views/comments/comments_detail_screen.dart';
import 'package:plo/views/comments/comments_widget/commentlists/comments_list_controller.dart';
import 'package:plo/views/comments/comments_widget/commentlists/comments_list_provider.dart';

final commentListCurrentUserProvider =
    FutureProvider.autoDispose<UserModel?>((ref) async {
  final user = await ref.watch(firebaseUserRepositoryProvider).fetchUser();
  return user;
});

class CommentListScreen extends ConsumerWidget {
  final PostModel postKey;
  const CommentListScreen({super.key, required this.postKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(commentListController(postKey.pid));
    // final comments = ref.watch(commentListProvider(postKey.pid));
    final comments = ref.watch(commentListProvider(postKey.pid));
    return RefreshIndicator(
      onRefresh: () async {
        // Refresh the comments and controller
        ref.refresh(commentListProvider(postKey.pid));
        ref.refresh(commentListController(postKey.pid));
      },
      child: ref.watch(commentListCurrentUserProvider).when(
            data: (currentUser) {
              return Container(
                padding: EdgeInsets.all(8),
                child: state.isLoading
                    ? const LoadingExpandedCommentsWidget()
                    : comments.length == 0
                        ? const NoCommentsFound()
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            controller: ref
                                .watch(
                                    commentListController(postKey.pid).notifier)
                                .scrollController, // Attach scroll controller for pagination
                            itemCount: comments.length +
                                1, // +1 for loading indicator or "No More" widget
                            itemBuilder: (context, index) {
                              if (index >= comments.length) {
                                // If it's the last item, show the "No More Comments" or Loading indicator
                                return ref
                                        .watch(
                                            commentListController(postKey.pid)
                                                .notifier)
                                        .isCommentAllLoaded
                                    ? const NoMoreComments() // All comments loaded, show "No More Comments"
                                    : const LoadingExpandedCommentsWidget(); // Still loading comments
                              }
                              // Render each comment
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: CommentDetailScreen(
                                  commentKey:
                                      comments[index], // Display comment
                                  postKey: postKey,
                                  isFromBlockedUser: currentUser == null
                                      ? false
                                      : currentUser.blockedUsers.contains(
                                          comments[index].commentsUserUid),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                          ),
              );
            },
            error: (error, stackTrace) => const Center(
              child: Text("An error occurred. Please try again."),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
    //           return Column(
    //             children: [
    //               Expanded(
    //                 child: PagedListView<int, CommentModel>(
    //                   pagingController: controller.pagingController,
    //                   padding: const EdgeInsets.symmetric(horizontal: 8),
    //                   builderDelegate: PagedChildBuilderDelegate<CommentModel>(
    //                       firstPageProgressIndicatorBuilder: (context) =>
    //                           const LoadingExpandedCommentsWidget(),
    //                       noItemsFoundIndicatorBuilder: (context) =>
    //                           const NoCommentsFound(),
    //                       noMoreItemsIndicatorBuilder: (context) =>
    //                           const NoMoreComments(),
    //                       itemBuilder: (context, comment, index) {
    //                         return Padding(
    //                             padding:
    //                                 const EdgeInsets.symmetric(vertical: 4.0),
    //                             child: CommentDetailScreen(
    //                               commentKey: comment,
    //                               postKey: postKey,
    //                             ));
    //                       }),
    //                 ),
    //               ),
    //             ],
    //           );
    //         },
    //         error: (error, stackTrace) => const Center(
    //           child: Text("An error occurred. Please try again."),
    //         ),
    //         loading: () => const Center(
    //           child: CircularProgressIndicator(),
    //         ),
    //       ),
    // // );
    // return ref.watch(commentListCurrentUserProvider).when(
    //       data: (currentUser) {
    //         return Column(
    //           children: [
    //             Expanded(
    //               child: PagedListView<int, CommentModel>(
    //                 pagingController: controller.pagingController,
    //                 padding: const EdgeInsets.symmetric(horizontal: 8),
    //                 builderDelegate: PagedChildBuilderDelegate<CommentModel>(
    //                   firstPageProgressIndicatorBuilder: (context) =>
    //                       const LoadingExpandedCommentsWidget(),
    //                   noItemsFoundIndicatorBuilder: (context) =>
    //                       const NoCommentsFound(),
    //                   noMoreItemsIndicatorBuilder: (context) =>
    //                       const NoMoreComments(),
    //                   itemBuilder: (context, comment, index) {
    //                     return Padding(
    //                       padding: const EdgeInsets.symmetric(vertical: 4.0),
    //                       child: CommentDetailScreen(
    //                         commentKey: comments[index],
    //                         postKey: postKey,
    //                       ),
    //                     );
    //                   },
    //                 ),
    //               ),
    //             ),
    //           ],
    //         );
    //       },
    //       error: (error, stackTrace) => const Center(
    //         child: Text("An error occurred. Please try again."),
    //       ),
    //       loading: () => const Center(
    //         child: CircularProgressIndicator(),
    //       ),
    //     );
