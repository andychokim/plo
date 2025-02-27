import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/providers/singlepost.dart';
import 'package:plo/common/utils/functions.dart';
import 'package:plo/common/widgets/square_image_widget.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/model/types/category_type.dart';
import 'package:plo/common/providers/user_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExpandedPostWidget extends ConsumerWidget {
  final PostModel post;
  final bool isFromBlockedUser;
  const ExpandedPostWidget(
      {super.key, required this.post, this.isFromBlockedUser = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Duration duration =
        DateTime.now().difference(post.uploadTime!.toDate());
    // log('item widget photoUrls : ${item.photoUrls}');
    // final item = ref.watch(itemDetailProvider(item));
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      log('important message! currentlySignedInUserProvider is null in PostWidget.');
    }
    // final Duration duration =
    //     DateTime.now().difference(item.uploadTime!.toDate());
    return Container(
      height: 500,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))),
      width: double.infinity,
      child: Column(
        children: [
          // Image section
          Expanded(
            flex: 1,
            child: isFromBlockedUser
                ? FittedBox(
                    child: Text(
                      "This item is from blocked user",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.postTitle,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 3),
                          Container(
                            height: 20,
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey,
                            ),
                            child: Center(
                              child: Text(
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[100]),
                                  post.category == CategoryType.information
                                      ? "정보 게시물"
                                      : "자유 게시물"),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 5,
                      ),
                      // Upload time
                      Row(
                        children: [
                          Text(
                            Functions.timeDifferenceInText(duration),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.grey),
                          ),
                          const Spacer(),
                          Text(post.userNickname,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // Like, view, comment
                    ],
                  ),
          ),
          Expanded(
              flex: 1,
              child: Row(
                children: [
                  Text(post.postContent,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const Spacer(),
                  Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.visibility),
                          const SizedBox(width: 5),
                          Text(post.postViewList.isEmpty
                              ? "0"
                              : post.postViewList.length.toString())
                        ],
                      )
                    ],
                  )
                ],
              )),
          Expanded(
            flex: 5,
            child: isFromBlockedUser
                ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300],
                    ),
                    child: const Center(child: Icon(Icons.warning)),
                  )
                : (post.showWarning)
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[300],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.visibility_off_rounded,
                            color: Colors.grey,
                            size: 50,
                          ),
                        ),
                      )
                    : (post.contentImageUrlList.isEmpty)
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent,
                            ),
                          )
                        : SquareImageWidget(
                            postImageUrl: post.contentImageUrlList[0]),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                //have to change this to different Icon where when user liked it it changes the heart to filled and if user is null or has not liked the post it should be an empty heart.
                user == null || !user.likedPosts.contains(post.pid)
                    ? SvgPicture.asset(
                        "assets/images/heart-empty-svgrepo-com.svg",
                        height: 24)
                    : SvgPicture.asset("assets/images/heart-svgrepo-com.svg"),
                Text(post.postLikes == null ? '0' : post.postLikes.toString()),
                const SizedBox(width: 10),
                const Icon(Icons.comment),
                Text(post.commentCount == null
                    ? '0'
                    : post.commentCount.toString())
              ],
            ),
          )
        ],
      ),
    );
  }
}
