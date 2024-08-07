import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/utils/log_util.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/model/types/return_type.dart';
import 'package:plo/repository/firebase_comments_repository.dart';
import 'package:plo/repository/firebase_image_repository.dart';
import 'package:plo/repository/firebase_post_repository.dart';
import 'package:plo/views/comments/comments_widget/commentlists/comments_list_controller.dart';
import 'package:plo/views/home_screen/main_post_list_controller.dart';

class DeleteService {
  final Ref ref;
  DeleteService({required this.ref});

  void _logToConsole(String typeofAction, String FunctionName) {
    logToConsole(
        "Firestore was used ($typeofAction in $FunctionName in DeleteService)");
  }

  Future<ReturnType> deletePost(PostModel post) async {
    try {
      final isPhotoDeleted = await ref
          .watch(FirebaseImageRepositoryProvider)
          .deletePostPhotos(post);
      if (isPhotoDeleted != true) {
        throw ErrorException(message: "Photo was not deleted");
      }

      final isPostDeleted = await ref
          .watch(firebasePostRepositoryProvider)
          .deletePostbyPid(post.pid);

      if (isPostDeleted == false) {
        logToConsole("Deleteservice deletePost Error: Error Deleting Post");
        throw ErrorException(message: "Error Deleting the post");
      }

      ref.refresh(mainpostListController);
      return SuccessReturnType(isSuccess: true);
    } catch (e) {
      logToConsole("DeleteServicePost error: $e");
      throw ErrorException(message: e.toString(), data: e);
    }
  }

  Future<ReturnType> deleteComment(String pid, String cid) async {
    try {
      final isCommentDelted =
          await ref.watch(firebaseCommentRepository).deleteComments(pid, cid);
      if (isCommentDelted == false) {
        throw ErrorException(message: "댓글을 삭제하는 도중 에러가 생겼습니다");
      }
      ref.refresh(commentListController(pid));
      return SuccessReturnType(isSuccess: true);
    } catch (e) {
      throw ErrorException(message: e.toString(), data: e);
    }
  }
}

final deleteServiceProvider = Provider.autoDispose<DeleteService>((ref) {
  ref.onDispose(() => logToConsole("Delete Service dispose"));
  return DeleteService(ref: ref);
});
