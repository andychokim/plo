import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/common/providers/singlepost.dart';
import 'package:plo/common/providers/user_provider.dart';
import 'package:plo/views/postdetail_screen/currentUserBottomSheet.dart';
import 'package:plo/views/postdetail_screen/otherUserBottomSheet.dart';
import 'package:plo/views/settings_screen/provider/non_login_provider.dart';

import '../../common/providers/login_verification_provider.dart';

class PostFloatingButton extends ConsumerWidget {
  final PostModel postKey;
  final BuildContext parentContext;
  const PostFloatingButton(
      {super.key, required this.postKey, required this.parentContext});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(singlePostProvider(postKey));
    final user = ref.watch(currentUserProvider);
    final isNotSignedUser = ref.watch(anonymousLogInProvider);
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FloatingButtonWidget(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              const SizedBox(width: 25),
              FloatingButtonWidget(
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }),
              //내가 쓴 게시물 보기?? 아니면 그냥 설정 버튼?
              const Spacer(),
              FloatingButtonWidget(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    isNotSignedUser || user!.userUid != post.uploadUserUid
                        ? showModalBottomSheet(
                            context: context,
                            builder: (context) =>
                                PostDetailOtherUserBottomSheet(
                                  postKey: postKey,
                                ))
                        : showModalBottomSheet(
                            context: context,
                            builder: (context) =>
                                PostDetailCurrentUserBottomSheet(
                                  postKey: postKey,
                                  parentContext: parentContext,
                                ));
                  }),
            ]));
  }
}

class FloatingButtonWidget extends StatelessWidget {
  final Function onPressed;
  final Icon icon;
  const FloatingButtonWidget(
      {super.key, required this.onPressed, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 1,
            style: BorderStyle.solid,
          ),
          color: Colors.white,
        ),
        child: IconButton(
            icon: icon,
            onPressed: () {
              onPressed();
            }));
  }
}
