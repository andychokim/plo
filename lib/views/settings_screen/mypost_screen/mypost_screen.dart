import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/log_util.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../model/post_model.dart';
import '../../../views/settings_screen/mypost_screen/mypost_controller.dart';
import '../../../views/settings_screen/widgets/postcard.dart';

class MyPostScreen extends ConsumerStatefulWidget {
  const MyPostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyPostScreenState();
}

class _MyPostScreenState extends ConsumerState<MyPostScreen> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      // 새로고침 기능
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        ref.read(myPostControllerProvider.notifier).refreshPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(myPostControllerProvider);

    return Scaffold(
      appBar: const BackButtonAppBar(title: "내 게시물"),
      body: SafeArea(
          child: postState.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: Text("내 게시물이 없습니다."));
          }
          return MyPostResultWidget(posts: data, scrollController: _controller);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          logToConsole("Error: $error");
          return Center(child: Text("Error: $error"));
        },
      )),
    );
  }
}

class MyPostResultWidget extends ConsumerWidget {
  final List<PostModel> posts;
  final ScrollController scrollController;
  const MyPostResultWidget({super.key, required this.posts, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: GridView.builder(
        controller: scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1 / 1.45,
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) => PostCard(
          snap: PostModel().fromJson(posts[index] as Map<String, dynamic>),
        ),
      ),
    );
  }
}
