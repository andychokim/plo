import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/providers/singlepost.dart';
import 'package:plo/model/comments_model.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/views/comments/comments_widget/currentuser_kebob_menu.dart';
import 'package:plo/views/comments/comments_widget/otheruser_kebob_menu.dart';
import 'package:plo/views/comments/comments_widget/single_comment_provider.dart';
import 'package:plo/common/providers/user_provider.dart';
import 'package:plo/views/settings_screen/provider/non_login_provider.dart';

import '../../../common/providers/login_verification_provider.dart';

class KebobIconButton extends ConsumerWidget {
  final CommentModel commentKey;
  final PostModel postKey;
  final BuildContext parentContext;
  const KebobIconButton(
      {super.key,
      required this.commentKey,
      required this.postKey,
      required this.parentContext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comment = ref.watch(singleCommentProvider(commentKey));
    final user = ref.watch(currentUserProvider);
    final isNotSignedInUser = ref.watch(anonymousLogInProvider);

    return Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: Colors.black, width: 1, style: BorderStyle.solid),
        ),
        child: IconButton(
          icon: Icon(Icons.more_vert, size: 18),
          onPressed: () async {
            isNotSignedInUser || user!.userUid != commentKey.commentsUserUid
                ? showModalBottomSheet(
                    context: context,
                    builder: (context) => CommentDetailOtherUserKebobIcon(
                          commentKey: commentKey,
                        ))
                : showModalBottomSheet(
                    context: context,
                    builder: (context) => CommentDetailCurrentUserKebobicon(
                          commentKey: commentKey,
                          postKey: postKey,
                          parentContext: parentContext,
                        ));
          },
        ));
  }
}
