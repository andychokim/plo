import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plo/constants/error_replacement_constants.dart';
import 'package:plo/model/types/report_comment_type.dart';
import 'package:plo/model/types/report_type.dart';

class CommentReportModelConstants {
  static const cid = 'cid';
  static const uploadUserUid = 'uploadUserUid';
  static const reportingUserUid = 'reportingUserUid';
  static const uploadTime = 'uploadTime';
  static const reportType = 'reportType';
  static const etcDescription = 'etcDescription';
  static const reportDetail = 'reportDetail';
}

class CommentReportModel {
  final String cid;
  final String uploadUserUid;
  final String reportingUserUid;
  final Timestamp uploadTime;
  final ReportCommentType reportType;
  final String? etcDescription;
  final String reportDetail;

  CommentReportModel(
      {this.cid = ErrorReplacementConstants.notSetString,
      this.uploadUserUid = ErrorReplacementConstants.notSetString,
      this.reportingUserUid = ErrorReplacementConstants.notSetString,
      required this.uploadTime,
      required this.reportType,
      this.etcDescription = ErrorReplacementConstants.notSetString,
      required this.reportDetail});
  Map<String, Object?> toJson() {
    return {
      CommentReportModelConstants.cid: cid,
      CommentReportModelConstants.uploadUserUid: uploadUserUid,
      CommentReportModelConstants.reportingUserUid: reportingUserUid,
      CommentReportModelConstants.uploadTime: uploadTime,
      CommentReportModelConstants.reportType: reportType.toString(),
      CommentReportModelConstants.etcDescription: etcDescription,
      CommentReportModelConstants.reportDetail: reportDetail,
    };
  }

  CommentReportModel? fromJson(Map<String, dynamic> json) {
    try {
      return CommentReportModel(
        cid: json[CommentReportModelConstants.cid] ??
            ErrorReplacementConstants.notFoundString,
        uploadUserUid: json[CommentReportModelConstants.uploadUserUid] ??
            ErrorReplacementConstants.notFoundString,
        reportingUserUid: json[CommentReportModelConstants.reportingUserUid] ??
            ErrorReplacementConstants.notFoundString,
        uploadTime: json[CommentReportModelConstants.cid],
        reportType: json[CommentReportModelConstants.cid],
        etcDescription: json[CommentReportModelConstants.cid] ??
            ErrorReplacementConstants.notFoundString,
        reportDetail: json[CommentReportModelConstants.cid] ??
            ErrorReplacementConstants.notFoundString,
      );
    } catch (error) {
      return null;
    }
  }
}
