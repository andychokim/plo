import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/providers/singlepost.dart';
import 'package:plo/common/widgets/profile_circular_image.dart';
import 'package:plo/common/widgets/shimmer_style.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/views/post_write/user_provider/user_provider.dart';
import 'package:plo/views/postdetail_screen/postDetailScreen.dart';
import 'package:plo/views/test_screen.dart';
import 'package:shimmer/shimmer.dart';

final postDetailProfileErrorProvider =
    StateProvider.autoDispose<bool>((ref) => false);

class PostDetailProfileWidget extends ConsumerWidget {
  final PostModel postKey;
  const PostDetailProfileWidget({super.key, required this.postKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postDetailProfilePhotoError =
        ref.watch(postDetailProfileErrorProvider);
    final post = ref.watch(singlePostProvider(postKey));
    final currentUser = ref.read(currentUserProvider);

    return ref.watch(postUploaderProvider(post.uploadUserUid)).when(
        // changing the loading screen to the profile loading widget
        loading: () => const PostDetailProfileLoadingWidget(),
        data: (uploader) {
          if (uploader == null) return Text("에러가 발생했습니다");
          return Container(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    //have to add viewMyProfileScreen to the TestScreen
                    MaterialPageRoute(builder: (context) => TestScreen()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DefaultProfileImageWidget(imageUrl: uploader.profileImageUrl),
                  SizedBox(width: 10),
                  Container(
                    child: Column(
                      children: [
                        Text("작성자: ${uploader.userNickname}님",
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) => Text("error Occured"));
  }
}

class PostDetailProfileLoadingWidget extends StatelessWidget {
  const PostDetailProfileLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Shimmer.fromColors(
          child: CircleAvatar(
            backgroundColor: Color.fromRGBO(224, 224, 224, 1),
          ),
          baseColor: Color.fromRGBO(224, 224, 224, 1),
          highlightColor: Color.fromRGBO(245, 245, 245, 1),
        ),
        const SizedBox(width: 6),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ShimmerIndividualWidget(
            child: Container(
                color: Color.fromRGBO(224, 224, 224, 1),
                child: const Text("Imaginary Name")),
          )
        ]),
        const Spacer(),
        Expanded(
            child: ShimmerIndividualWidget(
                child: Container(
          color: Color.fromRGBO(224, 224, 224, 1),
          height: 20,
        )))
      ],
    );
  }
}
