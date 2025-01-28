import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/utils/functions.dart';
import 'package:plo/common/widgets/modal_bottomsheet/default_modal_bottom.dart';
import 'package:plo/common/widgets/modal_bottomsheet/modal_bottom_icon.dart';
import 'package:plo/model/types/post_report_model.dart';
import 'package:plo/repository/firebase_post_repository.dart';
import 'package:plo/views/postdetail_screen/postDetailScreen.dart';

class ManageReportPostScreen extends ConsumerStatefulWidget {
  final String pid;
  final List<Map<String, dynamic>> reportPostList;
  const ManageReportPostScreen(
      {super.key, required this.reportPostList, required this.pid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManageReportPostScreen();
}

class _ManageReportPostScreen extends ConsumerState<ManageReportPostScreen> {
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
                        final report = widget.reportPostList[index];
                        return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                Text("신고 번호  ${index}"),
                                RichText(
                                  text: TextSpan(
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    children: [
                                      TextSpan(
                                          text:
                                              "신고한 유저: ${report[PostReportModelConstants.reportingUserUid]}\n"),
                                      // TextSpan(
                                      //     text:
                                      //         "신고한 시간: ${Functions.timeDifferenceInText(
                                      //   DateTime.now().difference(
                                      //     (report[PostReportModelConstants
                                      //             .uploadTime] as Timestamp)
                                      //         .toDate(),
                                      //   ),
                                      // )}\n"),
                                      TextSpan(
                                        text:
                                            "신고한 시간: ${report[PostReportModelConstants.uploadTime] != null ? Functions.timeDifferenceInText(
                                                DateTime.now().difference(
                                                  (report[PostReportModelConstants
                                                              .uploadTime]
                                                          as Timestamp)
                                                      .toDate(),
                                                ),
                                              ) : 'N/A'}\n",
                                      ),

                                      TextSpan(
                                          text:
                                              "신고 유형: ${report[PostReportModelConstants.reportType]}\n",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red)),
                                      TextSpan(
                                          text:
                                              "신고 이유: ${report[PostReportModelConstants.reportDetail]}\n"),
                                      TextSpan(
                                          text:
                                              "기타 이유: ${report[PostReportModelConstants.etcDescription]}\n")
                                    ],
                                  ),
                                )
                              ],
                            ));
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: widget.reportPostList.length),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final post = await ref
                            .watch(firebasePostRepositoryProvider)
                            .fetchPostByPostPid(widget.pid);
                        if (post != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  PostDetailScreen(postKey: post),
                            ),
                          );
                        }
                      },
                      child: const Text("해당 게시물로 이동"),
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
