import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/widgets/custom_button.dart';
import 'package:plo/views/postdetail_screen/block_user/block_comment_user/block_user_comment_modal_bottomsheet.dart';

class BlockUserModalBottomSheetCommentResultScreen extends ConsumerWidget {
  final String blockingUserUid;
  final bool isBlocked;

  const BlockUserModalBottomSheetCommentResultScreen({
    super.key,
    required this.blockingUserUid,
    required this.isBlocked,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: ref
          .watch(blockUserBottomSheetCommentBlockUserFutureProvider(
              blockingUserUid))
          .when(
              data: (data) {
                log("Block/Unblock result: $data");

                return Column(
                  children: [
                    const Spacer(),
                    FittedBox(
                      child: Text(
                          isBlocked ? "성공적으로 차단하셨습니다" : "성공적으로 차단 해제하셨습니다",
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    const Spacer(),
                    CustomButton(
                        text: "닫기",
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                );
              },
              error: (error, stackTrace) =>
                  const Icon(Icons.error_outline_outlined, size: 30),
              loading: () => const Center(child: CircularProgressIndicator())),
    );
  }
}
