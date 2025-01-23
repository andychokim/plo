import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/constants/firebase_contants.dart';
import 'package:collection/collection.dart';
import 'package:plo/model/types/post_report_model.dart';
import 'package:plo/views/admin/manage_report/manage_report_post_screen.dart';

class ManageReportPostMainScreen extends ConsumerStatefulWidget {
  const ManageReportPostMainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManageReportPostMainScreenState();
}

class _ManageReportPostMainScreenState
    extends ConsumerState<ManageReportPostMainScreen> {
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
                      FirebaseConstants.reportRecordscollectionName)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data == null)
                  return Center(child: Text("신고된 게시물이 없습니다"));
                List<Map<String, dynamic>> postList = [];
                for (var doc in snapshot.data!.docs) {
                  postList.add(doc.data());
                }
                final groupedPost = groupBy(
                    postList,
                    (Map postReport) =>
                        postReport[PostReportModelConstants.pid]);
                return ListView.separated(
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ManageReportPostScreen(
                                  reportPostList:
                                      groupedPost.values.toList()[index],
                                  pid: groupedPost.keys.toList()[index],
                                ),
                              ),
                            );
                          },
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(border: Border.all()),
                              child: Text(groupedPost.keys.toList()[index],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))));
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: groupedPost.length);
              },
            ),
          ),
        ],
      ),
    );
  }
}
