// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:plo/common/utils/functions.dart';
// import 'package:plo/model/post_model.dart';
// import 'package:plo/model/types/category_type.dart';
// import 'package:plo/common/providers/singlepost.dart';
// import 'package:plo/views/post_write/user_provider/user_provider.dart';
// import 'package:plo/views/settings_screen/provider/non_login_provider.dart';

// class PostDetailWidget extends ConsumerStatefulWidget {
//   final PostModel postKey;
//   PostDetailWidget({super.key, required this.postKey});

//   @override
//   ConsumerState<PostDetailWidget> createState() => _PostDetailWidgetState();
// }

// class _PostDetailWidgetState extends ConsumerState<PostDetailWidget> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final post = ref.watch(singlePostProvider(widget.postKey));
//     final currentUser = ref.watch(currentUserProvider);
//     final isNotSignedUser = ref.watch(proceedWithoutLoginProvider);
//     return Column(
//       children: [
//         Container(
//           constraints: BoxConstraints(
//             minHeight: 300,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 4,
//                           child: FittedBox(
//                             fit: BoxFit.scaleDown,
//                             alignment: Alignment.centerLeft,
//                             child:
//                                 Row(mainAxisSize: MainAxisSize.min, children: [
//                               Text("${post.postTitle}",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20)),
//                               SizedBox(width: 20),
//                               Tooltip(
//                                   message:
//                                       post.category == CategoryType.information
//                                           ? "정보 게시물"
//                                           : "자유 게시물",
//                                   preferBelow: false,
//                                   triggerMode: TooltipTriggerMode.tap,
//                                   showDuration: const Duration(seconds: 3),
//                                   waitDuration: Duration.zero,
//                                   child: post.category ==
//                                           CategoryType.information
//                                       ? const Icon(Icons.info_outline, size: 30)
//                                       : const Icon(Icons.category, size: 30)),
//                             ]),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 10),
//               Row(children: [
//                 Expanded(
//                   flex: 4,
//                   Text(
//                     "${post.category}"
//                   ),
//                   Text(
//                       " ${Functions.timeDifferenceInText(DateTime.now().difference(post.uploadTime!.toDate()))}",
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodySmall!
//                           .copyWith(fontSize: 14, color: Colors.grey)),
//                 ),
//               ]),
//             ],
//           ),
//         ),
//         Text("${post.postContent}",
//             style: Theme.of(context).textTheme.bodyLarge),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/utils/functions.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/model/types/category_type.dart';
import 'package:plo/common/providers/singlepost.dart';
import 'package:plo/common/providers/user_provider.dart';
import 'package:plo/views/postdetail_screen/postpicture.dart';

import '../../common/providers/login_verification_provider.dart';

class PostDetailWidget extends ConsumerStatefulWidget {
  final PostModel postKey;
  const PostDetailWidget({super.key, required this.postKey});

  @override
  ConsumerState<PostDetailWidget> createState() => _PostDetailWidgetState();
}

class _PostDetailWidgetState extends ConsumerState<PostDetailWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final post = ref.watch(singlePostProvider(widget.postKey));
    final currentUser = ref.watch(currentUserProvider);
    final isNotSignedUser = ref.watch(anonymousLogInProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(minHeight: 200, minWidth: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Row(children: [
                                Text(post.postTitle,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30)),
                                const SizedBox(width: 5),
                                Tooltip(
                                    message: post.category ==
                                            CategoryType.information
                                        ? "정보 게시물"
                                        : "자유 게시물",
                                    preferBelow: false,
                                    triggerMode: TooltipTriggerMode.tap,
                                    showDuration: const Duration(seconds: 2),
                                    child: post.category ==
                                            CategoryType.information
                                        ? const Icon(Icons.info_outline,
                                            size: 20)
                                        : const Icon(Icons.category, size: 20)),
                              ]),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        post.category == CategoryType.information
                            ? "정보 게시물"
                            : "자유 게시물",
                        // post.category.toString(), // Convert enum to string
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                    Text(
                      " 작성일: ${Functions.timeDifferenceInText(DateTime.now().difference(post.uploadTime!.toDate()))}",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                PostDetailPhoto(postKey: widget.postKey),
                const SizedBox(height: 10),
                Text(post.postContent,
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
