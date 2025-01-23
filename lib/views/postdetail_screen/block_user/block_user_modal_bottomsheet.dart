import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/widgets/modal_bottomsheet/default_modal_bottom.dart';
import 'package:plo/model/types/return_type.dart';
import 'package:plo/model/user_model.dart';
import 'package:plo/repository/firebase_user_repository.dart';
import 'package:plo/views/postdetail_screen/block_user/blocK_user_result_screen.dart';
import 'package:plo/views/postdetail_screen/block_user/block_user_modal_bottomsheet_page.dart';
import 'package:plo/views/postdetail_screen/postDetailScreen.dart';

final blockedUserModalBottomSheetIsBlockPressedProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final blockedUserModalBottomSheetCurrentUserFutureProvider =
    FutureProvider.autoDispose<UserModel?>((ref) async {
  final currentUser =
      await ref.watch(firebaseUserRepositoryProvider).fetchUser();
  return currentUser;
});

final blockUserBottomSheetBlockUserFutureProvider = FutureProvider.autoDispose
    .family<ReturnType, String>((ref, blockingUserUid) async {
  return await ref
      .watch(firebaseUserRepositoryProvider)
      .blockUser(blockingUserUid);
});

class BlockUserModalBottomsheet extends ConsumerWidget {
  final String uploaderUserUid;
  const BlockUserModalBottomsheet({super.key, required this.uploaderUserUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBlockPressed =
        ref.watch(blockedUserModalBottomSheetIsBlockPressedProvider);
    return DefaultModalBottomSheet(
      title: "차단/차단 해제",
      child:
          ref.watch(blockedUserModalBottomSheetCurrentUserFutureProvider).when(
                data: (user) {
                  if (user == null) {
                    return const Icon(Icons.error_outline, size: 30);
                  }
                  return ref.watch(postUploaderProvider(uploaderUserUid)).when(
                      data: (blockingUser) {
                        return isBlockPressed
                            ? BlockUserModalBottomSheetResultScreen(
                                blockingUserUid: blockingUser!.userUid,
                                isBlocked: !user.blockedUsers
                                    .contains(blockingUser.userUid),
                              )
                            : BlockedUserModalBottomSheetBlockPage(
                                currentUser: user,
                                blockingUser: blockingUser!,
                                isBlocked: !user.blockedUsers
                                    .contains(blockingUser.userUid));
                      },
                      error: (error, stackTrace) =>
                          const Icon(Icons.error_outline, size: 50),
                      loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ));
                },
                error: (error, stackTrace) =>
                    const Icon(Icons.error_outline, size: 50),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
    );
  }
}
