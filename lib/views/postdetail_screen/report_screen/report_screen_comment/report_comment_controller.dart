import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/utils/log_util.dart';
import 'package:plo/model/comments_model.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/model/types/comment_report_model.dart';
import 'package:plo/model/types/post_report_model.dart';
import 'package:plo/model/types/report_comment_type.dart';
import 'package:plo/model/types/report_type.dart';
import 'package:plo/model/types/return_type.dart';
import 'package:plo/repository/firebase_report_repository.dart';
import 'package:plo/common/providers/user_provider.dart';

class ReportPostController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  ReportPostController(this.ref) : super(const AsyncLoading()) {
    _init();
  }

  _init() async {
    state = const AsyncLoading();

    logToConsole("Create Post Controller init");
    state = const AsyncData(null);
  }

  Future<bool> uploadCommentReport(
      {required ReportCommentType reportType,
      required CommentModel comment,
      String? etcDescription,
      String? reportDescription,
      required GlobalKey<FormState> formkey}) async {
    final user = ref.read(currentUserProvider);
    final CommentReportModel report = CommentReportModel(
      cid: comment.cid,
      uploadUserUid: comment.commentsUserUid,
      reportingUserUid: user!.userUid,
      uploadTime: Timestamp.now(),
      reportType: reportType,
      etcDescription: etcDescription,
      reportDetail: reportDescription ?? "",
    );
    log("Attempting upload the reportModel");
    final reportUplodresult = await ref
        .watch(firebaseReportRepositoryProvider)
        .uploadCommentReportModelToFirebase(report, comment);
    if ((reportUplodresult is SuccessReturnType &&
            reportUplodresult.isSuccess != true) ||
        reportUplodresult is ErrorReturnType) {
      log("Error uploading report: ${reportUplodresult.toString()}");
      return false;
    }
    log("report uploaded successfully");
    return true;
  }
}

final reportCommentControllerProvider =
    StateNotifierProvider.autoDispose<ReportPostController, AsyncValue<void>>(
        (ref) {
  return ReportPostController(ref);
});
