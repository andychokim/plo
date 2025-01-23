import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/views/admin/manage_report/manage_post_report_screen.dart';
import 'package:plo/views/admin/manage_report/manage_report_main_comment_screen.dart';

class AdminMainScren extends ConsumerStatefulWidget {
  const AdminMainScren({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminMainScreenState();
}

class _AdminMainScreenState extends ConsumerState<AdminMainScren> {
  int index = 0;
  bool toggleValue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("관리자/디버깅 페이지")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ManageReportPostMainScreen(),
                      ),
                    );
                  },
                  child: const Text("신고 게시물 관리 섹션"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ManageReportCommentMainScreen()));
                  },
                  child: const Text("신고 댓글 관리 섹션"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("플레이그라운드"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
