import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/providers/singlepost.dart';
import 'package:plo/common/widgets/custom_alert_box.dart';
import 'package:plo/common/widgets/loading_widgets/expanded_loading_post.dart';
import 'package:plo/common/widgets/loading_widgets/loading_expanded_post.dart';
import 'package:plo/common/widgets/no_more_post.dart';
import 'package:plo/common/widgets/no_post_found.dart';
import 'package:plo/model/comments_model.dart';
import 'package:plo/model/user_model.dart';
import 'package:plo/repository/firebase_user_repository.dart';
import 'package:plo/views/comments/comments_widget/commentlists/comments_list_controller.dart';
import 'package:plo/views/comments/comments_widget/commentlists/comments_list_provider.dart';
import 'package:plo/views/home_screen/main_post_list_controller.dart';
import 'package:plo/views/home_screen/main_post_list_provider.dart';
import 'package:plo/views/home_screen/widgets/expanded_post.dart';
import 'package:plo/views/postdetail_screen/postDetailScreen.dart';

final mainPostListCurrentUserProvider =
    FutureProvider.autoDispose<UserModel?>((ref) async {
  final user = await ref.watch(firebaseUserRepositoryProvider).fetchUser();
  return user;
});

class MainPostList extends ConsumerWidget {
  const MainPostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainpostListController);
    final posts = ref.watch(mainPostListProvider);
    return RefreshIndicator(
      onRefresh: () async {
        ref.refresh(mainpostListController);
        ref.refresh(mainPostListCurrentUserProvider);
      },
      child: ref.watch(mainPostListCurrentUserProvider).when(
            data: (currentUser) {
              return Container(
                padding: const EdgeInsets.all(10),
                child: state.isLoading
                    ? const ExpandedPostListLoadingWidget()
                    : posts.isEmpty
                        ? const NoPostFound()
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: ref
                                .watch(mainpostListController.notifier)
                                .scrollController,
                            itemBuilder: (context, index) {
                              if (index >= posts.length) {
                                return ref
                                        .watch(mainpostListController.notifier)
                                        .isPostAllLoaded
                                    ? const NoMorePost()
                                    : const LoadingExpandedPostWidget();
                              }
                              return InkWell(
                                  onTap: () async {
                                    bool? isConfirmed = true;

                                    if (posts.elementAt(index).showWarning) {
                                      isConfirmed = await AlertBox
                                          .showYesOrNoAlertDialogue(
                                              context, "계속 하시겠습니까?");
                                    }
                                    if (isConfirmed == true) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PostDetailScreen(
                                            postKey: posts[index],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return;
                                    }
                                  },
                                  child: ExpandedPostWidget(
                                    post: posts.elementAt(index),
                                    isFromBlockedUser: currentUser == null
                                        ? false
                                        : currentUser.blockedUsers.contains(
                                            posts[index].uploadUserUid),
                                  ));
                            },
                            separatorBuilder: (context, index) => Container(),
                            itemCount: posts.length + 1,
                          ),
              );
            },
            error: (error, stackTrace) => const Text("Unknow Error Occured"),
            loading: () => const SizedBox(
                width: 30,
                height: 30,
                child: Center(child: CircularProgressIndicator())),
          ),
    );
  }
}
