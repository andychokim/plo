import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plo/common/utils/log_util.dart';
import 'package:plo/constants/error_replacement_constants.dart';
import 'package:plo/model/types/category_type.dart';

class PostModelFieldNameConstants {
  static const String pid = "pid";
  static const String uploadUserUid = "uid";
  static const String userNickname = "userNickname";
  static const String userProfileURL = "userProfileURL";
  static const String category = "category";
  static const String postContent = "postContent";
  static const String postTitle = "postTitle";
  static const String contentImageUrlList = "contentImageURL";
  static const String postLikes = "postLikes";
  static const String isPostImageBool = "istPostImageBool";
  static const String uploadTime = "uploadTime";
  static const String postViewList = "postViewList";
  static const String postViewListLength = "postViewListLength";
  static const String showWarning = "ShowWarning";
  static const String commentCount = "commentCount";
}

class PostModel {
  final String pid;
  final String uploadUserUid;
  final String userNickname;
  final String userProfileURL;
  final String postTitle;
  final String postContent;
  final List<String> contentImageUrlList;
  final int postLikes;
  final Timestamp? uploadTime;
  final bool isPostImageBool;
  final CategoryType category;
  final List<String> postViewList;
  final int postViewListLength;
  final bool showWarning;
  final int commentCount;

  PostModel(
      {this.pid = ErrorReplacementConstants.notSetString,
      this.uploadUserUid = ErrorReplacementConstants.notSetString,
      this.userNickname = ErrorReplacementConstants.notSetString,
      this.userProfileURL = ErrorReplacementConstants.notSetString,
      this.postTitle = ErrorReplacementConstants.notSetString,
      this.postContent = ErrorReplacementConstants.notSetString,
      this.contentImageUrlList = const [],
      this.postLikes = 0,
      this.uploadTime,
      this.isPostImageBool = false,
      this.category = CategoryType.information,
      this.postViewList = const [],
      this.postViewListLength = 0,
      this.showWarning = false,
      this.commentCount = 0});

  Map<String, Object?> toJson() {
    return {
      PostModelFieldNameConstants.pid: pid,
      PostModelFieldNameConstants.uploadUserUid: uploadUserUid,
      PostModelFieldNameConstants.userNickname: userNickname,
      PostModelFieldNameConstants.userProfileURL: userProfileURL,
      PostModelFieldNameConstants.postTitle: postTitle,
      PostModelFieldNameConstants.postContent: postContent,
      PostModelFieldNameConstants.contentImageUrlList: contentImageUrlList,
      PostModelFieldNameConstants.postLikes: postLikes,
      PostModelFieldNameConstants.uploadTime: uploadTime,
      PostModelFieldNameConstants.isPostImageBool: isPostImageBool,
      PostModelFieldNameConstants.category: category.toString(),
      PostModelFieldNameConstants.postViewList: postViewList,
      PostModelFieldNameConstants.postViewListLength: postViewList.length,
      PostModelFieldNameConstants.showWarning: showWarning,
      PostModelFieldNameConstants.commentCount: commentCount
    };
  }

  PostModel? fromJson(Map<String, dynamic> json) {
    try {
      final List<String> convertedPostViewList =
          json[PostModelFieldNameConstants.postViewList] == null
              ? const []
              : (json[PostModelFieldNameConstants.postViewList]
                      as List<dynamic>)
                  .map((e) => e.toString())
                  .toList();

      final List<String> convertedContentImageUrlList =
          json[PostModelFieldNameConstants.contentImageUrlList] == null
              ? const []
              : (json[PostModelFieldNameConstants.contentImageUrlList]
                      as List<dynamic>)
                  .map((e) => e.toString())
                  .toList();

      return PostModel(
        pid: json[PostModelFieldNameConstants.pid] ??
            ErrorReplacementConstants.notFoundString,
        uploadUserUid: json[PostModelFieldNameConstants.uploadUserUid] ??
            ErrorReplacementConstants.notFoundString,
        userNickname: json[PostModelFieldNameConstants.userNickname] ??
            ErrorReplacementConstants.notFoundString,
        userProfileURL: json[PostModelFieldNameConstants.userProfileURL] ??
            ErrorReplacementConstants.notFoundString,
        postTitle: json[PostModelFieldNameConstants.postTitle] ??
            ErrorReplacementConstants.notFoundString,
        postContent: json[PostModelFieldNameConstants.postContent] ??
            ErrorReplacementConstants.notFoundString,
        contentImageUrlList: convertedContentImageUrlList,
        uploadTime: json[PostModelFieldNameConstants.uploadTime],
        isPostImageBool:
            json[PostModelFieldNameConstants.isPostImageBool] ?? false,
        category: CategoryType.stringToCategory(
            json[PostModelFieldNameConstants.category]),
        postLikes: json[PostModelFieldNameConstants.postLikes] ?? 0,
        postViewList: convertedPostViewList,
        postViewListLength:
            json[PostModelFieldNameConstants.postViewListLength] ?? -1,
        showWarning: json[PostModelFieldNameConstants.showWarning] ?? false,
        commentCount: json[PostModelFieldNameConstants.commentCount] ?? 0,
      );
    } catch (error) {
      logToConsole('PostModel fromJson Error: ${error.toString()}');
      return null;
    }
  }

  PostModel update(
      {String? pid,
      String? uploadUserUid,
      String? userNickname,
      String? userProfileURL,
      String? postTitle,
      String? postContent,
      List<String>? contentImageUrlList,
      Timestamp? uploadTime,
      bool? isPostImageBool,
      CategoryType? category,
      int? postLikes,
      List<String>? postViewList,
      bool? showWarning,
      int? postViewListLength,
      int? commentCount}) {
    return PostModel(
      pid: pid ?? this.pid,
      uploadUserUid: uploadUserUid ?? this.uploadUserUid,
      userNickname: userNickname ?? this.userNickname,
      userProfileURL: userProfileURL ?? this.userProfileURL,
      postTitle: postTitle ?? this.postTitle,
      postContent: postContent ?? this.postContent,
      contentImageUrlList: contentImageUrlList ?? this.contentImageUrlList,
      uploadTime: uploadTime ?? this.uploadTime,
      isPostImageBool: isPostImageBool ?? this.isPostImageBool,
      category: category ?? this.category,
      postLikes: postLikes ?? this.postLikes,
      postViewList: postViewList ?? this.postViewList,
      postViewListLength: postViewListLength ?? this.postViewListLength,
      showWarning: showWarning ?? this.showWarning,
      commentCount: commentCount ?? this.commentCount,
    );
  }

  @override
  String toString() {
    return 'PostModel(pid: $pid, uploadUseruid: $uploadUserUid)';
  }
}
