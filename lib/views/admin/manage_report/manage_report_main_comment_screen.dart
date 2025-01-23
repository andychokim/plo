import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/constants/firebase_contants.dart';
import 'package:collection/collection.dart';
import 'package:plo/model/comments_model.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/model/types/post_report_model.dart';
import 'package:plo/views/admin/manage_report/manage_report_comment_screen.dart';
import 'package:plo/views/admin/manage_report/manage_report_post_screen.dart';

class ManageReportCommentMainScreen extends ConsumerStatefulWidget {
  const ManageReportCommentMainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManageReportPostMainScreenState();
}

class _ManageReportPostMainScreenState
    extends ConsumerState<ManageReportCommentMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("게시물 관리 페이지")),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collectionGroup(
                      FirebaseConstants.reportCommentsRecordsCollectionName)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data == null)
                  return Center(child: Text("신고된 댓글이 없습니다"));
                List<Map<String, dynamic>> commentList = [];
                for (var doc in snapshot.data!.docs) {
                  commentList.add(doc.data());
                }
                final groupedCommentPid = groupBy(
                    commentList,
                    (Map commentReport) => commentReport[
                        CommentModelFieldNameConstants.commentsPid]);
                final groupedComment = groupBy(
                    commentList,
                    (Map commentReport) =>
                        commentReport[CommentModelFieldNameConstants.cid]);
                return ListView.separated(
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ManageReportCommentScreen(
                                    reportCommentList:
                                        groupedComment.values.toList()[index],
                                    pid: groupedCommentPid.keys.toList()[index],
                                    cid: groupedComment.keys.toList()[index]),
                              ),
                            );
                          },
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(border: Border.all()),
                              child: Text(groupedComment.keys.toList()[index],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))));
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: groupedComment.length);
              },
            ),
          ),
        ],
      ),
    );
  }
}
