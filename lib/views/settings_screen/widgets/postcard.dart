import 'package:flutter/material.dart';

import '../../../model/post_model.dart';

class PostCard extends StatefulWidget {
  final PostModel? snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.snap!.postTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "작성자: ${widget.snap!.userNickname}",
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: Text(
                    widget.snap!.postContent,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 90,
              width: 110,
              child: widget.snap!.contentImageUrlList[0].isEmpty
                  ? null
                  : ClipRRect(
                      child: Image.network(
                        widget.snap!.contentImageUrlList[0],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                        },
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
