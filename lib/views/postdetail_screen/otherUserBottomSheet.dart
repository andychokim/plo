import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/widgets/modal_bottomsheet/default_modal_bottom.dart';
import 'package:plo/common/widgets/modal_bottomsheet/modal_bottom_icon.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/views/postdetail_screen/block_user/block_user_modal_bottomsheet.dart';
import 'package:plo/views/postdetail_screen/report_screen/reportScreen.dart';
import 'package:plo/views/settings_screen/provider/non_login_provider.dart';

import '../../common/providers/login_verification_provider.dart';

class PostDetailOtherUserBottomSheet extends ConsumerWidget {
  final PostModel postKey;
  const PostDetailOtherUserBottomSheet({super.key, required this.postKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNotSignedUser = ref.watch(anonymousLogInProvider);
    return DefaultModalBottomSheet(
      title: "옵션",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModalBottomSheetIcon(
            title: "게시물 신고하기",
            icon: const Icon(Icons.warning),
            onTap: () {
              if (isNotSignedUser) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("로그인을 하셔야 사용 가능한 기능입니다"),
                  ),
                );
                return;
              }
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ReportScreen(postKey: postKey);
                  },
                ),
              );
            },
          ),
          ModalBottomSheetIcon(
              title: "이 유저 차단하기",
              icon: const Icon(Icons.block),
              onTap: () {
                if (isNotSignedUser) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("로그인 하셔야 이용 가능한 기능입니다"),
                    ),
                  );
                }
                Navigator.of(context).pop();
                showModalBottomSheet(
                    context: context,
                    builder: (context) => BlockUserModalBottomsheet(
                          uploaderUserUid: postKey.uploadUserUid,
                        ));
              })
        ],
      ),
    );
  }
}
