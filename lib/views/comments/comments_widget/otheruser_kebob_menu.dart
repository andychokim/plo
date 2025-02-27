import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/widgets/modal_bottomsheet/default_modal_bottom.dart';
import 'package:plo/common/widgets/modal_bottomsheet/modal_bottom_icon.dart';
import 'package:plo/model/comments_model.dart';

import 'package:plo/views/postdetail_screen/block_user/block_comment_user/block_user_comment_modal_bottomsheet.dart';

import 'package:plo/views/postdetail_screen/report_screen/report_screen_comment/report_comment_screen.dart';
import 'package:plo/views/settings_screen/provider/non_login_provider.dart';

import '../../../common/providers/login_verification_provider.dart';

class CommentDetailOtherUserKebobIcon extends ConsumerWidget {
  final CommentModel commentKey;
  const CommentDetailOtherUserKebobIcon({super.key, required this.commentKey});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNotSignedUser = ref.watch(anonymousLogInProvider);
    return DefaultModalBottomSheet(
      title: "옵션",
      child: Column(
        children: [
          ModalBottomSheetIcon(
            title: "댓글 신고하기",
            icon: const Icon(Icons.warning),
            onTap: () async {
              if (isNotSignedUser) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("로그인을 하셔야 사용 가능한 기능입니다"),
                  ),
                );
                return;
              }
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ReportCommentScreen(
                    commentKey: commentKey,
                  ),
                ),
              );
            },
          ),
          ModalBottomSheetIcon(
              title: "댓글 쓴 유저 차단하기",
              icon: Icon(Icons.block),
              onTap: () async {
                Navigator.of(context).pop();
                showModalBottomSheet(
                    context: context,
                    builder: (context) => BlockCommentUserModalBottomsheet(
                        uploaderUserUid: commentKey.commentsUserUid));
              })
        ],
      ),
    );
  }
}
