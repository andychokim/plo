import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/utils/functions.dart';
import 'package:plo/common/utils/log_util.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/common/providers/user_provider.dart';

class PostWidget extends ConsumerWidget {
  final PostModel post;
  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      logToConsole(
          "Important Message! CurrentlySignedUserProvider is null in PostWidget.");
    }
    final Duration duration =
        DateTime.now().difference(post.uploadTime!.toDate());
    return Container(
      height: 100,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: (post.contentImageUrlList.isEmpty)
                ? Image.asset("assets/images/profile_default.png",
                    fit: BoxFit.cover)
                : Image.asset("assets/images/profile_default.png",
                    fit: BoxFit.cover),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.postTitle,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  Functions.timeDifferenceInText(duration),
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      user == null
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.blue,
                              size: 15,
                            )
                          : Icon(
                              size: 15,
                              Icons.favorite,
                              color: user.likedPosts.contains(post.pid)
                                  ? Colors.red
                                  : Colors.black),
                      Text(
                        post.postLikes == null
                            ? "0"
                            : post.postLikes.toString(),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.comment,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
