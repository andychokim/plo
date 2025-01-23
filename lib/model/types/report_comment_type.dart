class ReportTypeCommentFieldNameConstants {
  static const commentIssue = "postIssue";
  static const prohibitedComments = "prohibitedComments";
  static const falseInformation = "falseInformation";
  static const spam = "spam";
  static const fraud = "fraud";
  static const etc = "etc";
}

enum ReportCommentType {
  commentIssue,
  prohibitedComments,
  falseInformation,
  spam,
  fraud,
  etc;

  @override
  String toString() {
    switch (this) {
      case ReportCommentType.commentIssue:
        return ReportTypeCommentFieldNameConstants.commentIssue;
      case ReportCommentType.prohibitedComments:
        return ReportTypeCommentFieldNameConstants.prohibitedComments;
      case ReportCommentType.falseInformation:
        return ReportTypeCommentFieldNameConstants.falseInformation;
      case ReportCommentType.spam:
        return ReportTypeCommentFieldNameConstants.spam;
      case ReportCommentType.fraud:
        return ReportTypeCommentFieldNameConstants.fraud;
      case ReportCommentType.etc:
        return ReportTypeCommentFieldNameConstants.etc;
    }
  }

  String getDescription() {
    switch (this) {
      case ReportCommentType.commentIssue:
        return "댓글 에러가 있습니다";
      case ReportCommentType.prohibitedComments:
        return "댓글 정책에 위반되는 댓글입니다";
      case ReportCommentType.falseInformation:
        return "부 정확하거나 사실이 아닌 댓글입니다";
      case ReportCommentType.spam:
        return "스팸/광고성 댓글입니다.";
      case ReportCommentType.fraud:
        return "사기가 의심되는 댓글입니다";
      case ReportCommentType.etc:
        return "기타 이유";
    }
  }

  static stringToCategory(String string) {
    switch (string) {
      case ReportTypeCommentFieldNameConstants.commentIssue:
        return ReportCommentType.commentIssue;
      case ReportTypeCommentFieldNameConstants.prohibitedComments:
        return ReportCommentType.prohibitedComments;
      case ReportTypeCommentFieldNameConstants.falseInformation:
        return ReportCommentType.falseInformation;
      case ReportTypeCommentFieldNameConstants.spam:
        return ReportCommentType.spam;
      case ReportTypeCommentFieldNameConstants.fraud:
        return ReportCommentType.fraud;
      case ReportTypeCommentFieldNameConstants.etc:
        return ReportCommentType.etc;
      default:
        return ReportCommentType.etc;
    }
  }
}

enum ReportCommentDescription {
  description;
}
