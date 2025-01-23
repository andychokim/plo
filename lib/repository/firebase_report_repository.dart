import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/utils/log_util.dart';
import 'package:plo/constants/firebase_contants.dart';
import 'package:plo/model/comments_model.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/model/types/comment_report_model.dart';
import 'package:plo/model/types/post_report_model.dart';
import 'package:plo/model/types/return_type.dart';
import 'package:plo/repository/firebase_user_repository.dart';

class FirebaseReportRepository {
  final Ref ref;
  FirebaseReportRepository({required this.ref});

  final _firebase = FirebaseFirestore.instance;

  void _logHelper(String typeofAction, String functionName) {
    logToConsole(
        "Firestore was used in $typeofAction in $functionName in firebasePostRepository");
  }

  Future<ReturnType> alreadyReported(String pid) async {
    try {
      final user = ref.watch(firebaseUserRepositoryProvider).currentUser;
      if (user == null) return ErrorReturnType(message: "User wasn't found");

      final doc = await _firebase
          .collection(FirebaseConstants.reportRecordscollectionName)
          .doc(pid)
          .collection(FirebaseConstants.reportRecordscollectionName)
          .doc(user.uid)
          .get();
      if (!doc.exists) {
        return SuccessReturnType(
            message: "User did not report this Post", isSuccess: false);
      }
      return SuccessReturnType(isSuccess: true);
    } catch (error) {
      return ErrorReturnType(message: "게시물이 이미 신고 되었습니다: $error", data: error);
    }
  }

  Future<ReturnType> alreadyCommentReported(String cid) async {
    try {
      final user = ref.watch(firebaseUserRepositoryProvider).currentUser;
      if (user == null) return ErrorReturnType(message: "유저를 찾을 수가 없습니다");
      final doc = await _firebase
          .collection(FirebaseConstants.reportCommentsRecordsCollectionName)
          .doc(cid)
          .collection(FirebaseConstants.reportCommentsRecordsCollectionName)
          .doc(user.uid)
          .get();
      if (!doc.exists) {
        return SuccessReturnType(
            isSuccess: false, message: "이 유저는 댓글을 신고하지 않았습니다");
      }
      return SuccessReturnType(isSuccess: true);
    } catch (error) {
      return ErrorReturnType(message: "댓글이 이미 신고 되었습니다: ${error.toString()}");
    }
  }

  Future<ReturnType> uploadPostReportModelToFirebase(
      PostReportModel postReportModel, PostModel post) async {
    try {
      final isReported = await alreadyReported(post.pid);

      await _firebase
          .collection(FirebaseConstants.reportRecordscollectionName)
          .doc(post.pid)
          .set({
        PostModelFieldNameConstants.pid: post.pid,
      });

      if (isReported is SuccessReturnType && isReported.isSuccess == true) {
        await _firebase
            .collection(FirebaseConstants.reportRecordscollectionName)
            .doc(post.pid)
            .collection(FirebaseConstants.reportRecordscollectionName)
            .doc(postReportModel.reportingUserUid)
            .update(postReportModel.toJson());
        _logHelper("Update", "uploadPostReportModelToFirebase");
      } else {
        await _firebase
            .collection(FirebaseConstants.reportRecordscollectionName)
            .doc(post.pid)
            .collection(FirebaseConstants.reportRecordscollectionName)
            .doc(postReportModel.reportingUserUid)
            .set(postReportModel.toJson());
        _logHelper("Set", "uploadPostReportModelToFirebase");
      }
      log("report uploaded Successfully");
      return SuccessReturnType(isSuccess: true);
    } catch (error) {
      return ErrorReturnType(message: error.toString(), data: error);
    }
  }

  Future<ReturnType> uploadCommentReportModelToFirebase(
      CommentReportModel commentReportModel, CommentModel commentKey) async {
    try {
      final isReported = await alreadyCommentReported(commentKey.cid);

      await _firebase
          .collection(FirebaseConstants.reportCommentsRecordsCollectionName)
          .doc(commentKey.cid)
          .set({CommentReportModelConstants.cid: commentKey.cid});

      if (isReported is SuccessReturnType && isReported.isSuccess == true) {
        await _firebase
            .collection(FirebaseConstants.reportCommentsRecordsCollectionName)
            .doc(commentKey.cid)
            .collection(FirebaseConstants.reportCommentsRecordsCollectionName)
            .doc(commentReportModel.reportingUserUid)
            .update(commentReportModel.toJson());
        _logHelper("Update", "uploadPostReportModelToFirebase");
      } else {
        await _firebase
            .collection(FirebaseConstants.reportCommentsRecordsCollectionName)
            .doc(commentKey.cid)
            .collection(FirebaseConstants.reportCommentsRecordsCollectionName)
            .doc(commentReportModel.reportingUserUid)
            .set(commentReportModel.toJson());
        _logHelper("Set", "uploadPostReportModelToFirebase");
      }
      log("report uploaded Successfully");
      return SuccessReturnType(isSuccess: true);
    } catch (error) {
      return ErrorReturnType(message: error.toString(), data: error);
    }
  }
}

final firebaseReportRepositoryProvider =
    Provider<FirebaseReportRepository>((ref) {
  ref.onDispose(() {
    logToConsole('FirebasePostRepositoryProvider Disposed');
  });
  return FirebaseReportRepository(ref: ref);
});
