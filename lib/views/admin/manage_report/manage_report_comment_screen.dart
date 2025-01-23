import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/utils/functions.dart';
import 'package:plo/common/widgets/modal_bottomsheet/default_modal_bottom.dart';
import 'package:plo/common/widgets/modal_bottomsheet/modal_bottom_icon.dart';
import 'package:plo/model/types/comment_report_model.dart';
import 'package:plo/model/types/post_report_model.dart';
import 'package:plo/repository/firebase_comments_repository.dart';
import 'package:plo/repository/firebase_post_repository.dart';
import 'package:plo/views/comments/comments_detail_screen.dart';
import 'package:plo/views/comments/comments_widget/commentlists/commentlist_screen.dart';
import 'package:plo/views/postdetail_screen/postDetailScreen.dart';

class ManageReportCommentScreen extends ConsumerStatefulWidget {
  final String pid;
  final String cid;
  final List<Map<String, dynamic>> reportCommentList;
  const ManageReportCommentScreen(
      {super.key,
      required this.reportCommentList,
      required this.pid,
      required this.cid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManageReportCommentScreen();
}

class _ManageReportCommentScreen
    extends ConsumerState<ManageReportCommentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("신고 게시물 관리")),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        final report = widget.reportCommentList[index];
                        return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                Text("신고 번호  $index"),
                                RichText(
                                  text: TextSpan(
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    children: [
                                      TextSpan(
                                          text:
                                              "신고한 유저: ${report[CommentReportModelConstants.reportingUserUid]}\n"),
                                      TextSpan(
                                          text:
                                              "신고한 시간: ${Functions.timeDifferenceInText(
                                        DateTime.now().difference(
                                          (report[CommentReportModelConstants
                                                  .uploadTime] as Timestamp)
                                              .toDate(),
                                        ),
                                      )}\n"),
                                      TextSpan(
                                          text:
                                              "신고 유형: ${report[CommentReportModelConstants.reportType]}\n",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red)),
                                      TextSpan(
                                          text:
                                              "신고 이유: ${report[CommentReportModelConstants.reportDetail]}\n"),
                                      TextSpan(
                                          text:
                                              "기타 이유: ${report[CommentReportModelConstants.etcDescription]}\n")
                                    ],
                                  ),
                                )
                              ],
                            ));
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: widget.reportCommentList.length),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final comment = await ref
                            .watch(firebaseCommentRepository)
                            .fetchCommentByCid(widget.pid, widget.cid);

                        final post = await ref
                            .watch(firebasePostRepositoryProvider)
                            .fetchPostByPostUid(widget.pid);
                        if (comment != null && post != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CommentDetailScreen(
                                postKey: post,
                                commentKey: comment,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text("해당 댓글로 이동"),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => DefaultModalBottomSheet(
                              child: Column(
                                children: [
                                  ModalBottomSheetIcon(
                                      title: "게시물 삭제",
                                      onTap: () {},
                                      icon: const Icon(Icons.delete))
                                ],
                              ),
                            ),
                          );
                        },
                        child: const Text("Edit Item"))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
