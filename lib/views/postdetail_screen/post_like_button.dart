import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:plo/common/providers/singlepost.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/common/providers/user_provider.dart';
import 'package:plo/views/postdetail_screen/post_detail_controller/post_detail_controller.dart';

class PostDetailLikeButton extends ConsumerStatefulWidget {
  final PostModel postKey;
  const PostDetailLikeButton({super.key, required this.postKey});

  @override
  ConsumerState<PostDetailLikeButton> createState() =>
      _PostDetailLikeButtonState();
}

class _PostDetailLikeButtonState extends ConsumerState<PostDetailLikeButton> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = ref.watch(singlePostProvider(widget.postKey));
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final int likeCount = post.postLikes ?? 0;
    final bool isLiked = user.likedPosts.contains(post.pid);
    return LikeButton(
      size: 30,
      isLiked: !isLiked,
      circleColor:
          const CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
      bubblesColor: const BubblesColor(
          dotPrimaryColor: Color.fromARGB(255, 229, 66, 51),
          dotSecondaryColor: Color.fromARGB(255, 255, 1, 217)),
      likeCount: likeCount,
      likeBuilder: (bool isLiked) {
        return Icon(Icons.favorite,
            size: 20, color: !isLiked ? Colors.pinkAccent : Colors.grey);
      },
      countPostion: CountPostion.right,
      onTap: (bool isLiked) async {
        final result = await ref
            .read(postDetailControllerProvider.notifier)
            .toggleLike(widget.postKey, post);
        // return !isLiked;
        return result;
      },
    );
  }
}
