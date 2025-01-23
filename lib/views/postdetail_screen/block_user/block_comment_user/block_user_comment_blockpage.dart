import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/widgets/custom_button.dart';
import 'package:plo/common/widgets/profile_circular_image.dart';
import 'package:plo/model/user_model.dart';
import 'package:plo/views/postdetail_screen/block_user/block_comment_user/block_user_comment_modal_bottomsheet.dart';

class BlockedUserModalBottomSheetCommentBlockPage extends ConsumerWidget {
  final UserModel currentUser;
  final UserModel blockingUser;
  final bool isBlocked;
  const BlockedUserModalBottomSheetCommentBlockPage(
      {super.key,
      required this.currentUser,
      required this.blockingUser,
      required this.isBlocked});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultProfileImageWidget(
            imageUrl: blockingUser.profileImageUrl,
            radius: 50,
          ),
          const SizedBox(height: 12),
          FittedBox(
            child: Text(
                "정말 ${isBlocked ? "${blockingUser.userNickname}님을 차단 하시겠습니까?" : "${blockingUser.userNickname}님을 차단 해제 하시겠습니까?"}",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge),
          ),
          const SizedBox(
            height: 30,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
                isBlocked
                    ? "${blockingUser.userNickname}님의 정보가 더 이상 보이지 않습니다"
                    : "${blockingUser.userNickname}님의 게시물을 이제부터 볼 수 있습니다",
                style: Theme.of(context).textTheme.bodyLarge),
          ),
          const Spacer(),
          CustomButton(
            text: isBlocked ? "차단" : "네 알겠습니다",
            onPressed: () {
              log("Button pressed to ${isBlocked ? 'block' : 'unblock'} the user");

              ref
                  .read(blockedUserModalBottomSheetCommentIsBlockPressedProvider
                      .notifier)
                  .state = true;
              log("State updated: ${ref.read(blockedUserModalBottomSheetCommentIsBlockPressedProvider)}");
            },
          )
        ],
      ),
    );
  }
}
