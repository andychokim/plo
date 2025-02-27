import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/constants/firebase_contants.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/model/user_model.dart';
import 'package:plo/common/providers/user_provider.dart';

class LikePostService {
  Ref ref;
  LikePostService(this.ref);

  final _firebase = FirebaseFirestore.instance;

  void _logHelper(String typeOfAction, String functionName) {
    log("FireStore was used $typeOfAction in $functionName in LikePostService ");
  }

  Future<bool> didUserAlreadyLikeThePost(String userUid, String pid) async {
    try {
      QuerySnapshot userSnapShot = await _firebase
          .collection(FirebaseConstants.usercollectionName)
          .where(UserModelNameConstants.userUid, isEqualTo: userUid)
          .get();
      _logHelper("Get", "didUserAlreadyLikeThePost");

      if (userSnapShot.size != 1) {
        log("didUserAlreadyLikeTHePost Error: User not found in the firebase");
        return false;
      }
      List<dynamic>? likedPosts = userSnapShot.docs[0]
          [UserModelNameConstants.likedPosts] as List<dynamic>?;

      if (likedPosts == null || likedPosts.isEmpty) {
        return false;
      }
      if (!likedPosts.contains(pid)) {
        return false;
      }
      return true;
    } catch (error) {
      log("didUserAlreadyLikedThePost Error ${error.toString()}");
    }
    return false;
  }

  Future<int> updateLikedPostsInPostModel(String pid, int addValue) async {
    try {
      DocumentSnapshot postSnapshot = await _firebase
          .collection(FirebaseConstants.postcollectionName)
          .doc(pid)
          .get();
      _logHelper("Get", "updateLikedPostsInPostModel");

      if (postSnapshot.exists == false) {
        return -1;
      }
      int? currentNumberOfLikes = (postSnapshot.data()
              as Map<String, dynamic>)[PostModelFieldNameConstants.postLikes]
          as int?;

      int updatedNumberOfLikes = (currentNumberOfLikes == null)
          ? addValue
          : currentNumberOfLikes + addValue;

      await postSnapshot.reference.update(
          {PostModelFieldNameConstants.postLikes: updatedNumberOfLikes});

      _logHelper("Update", "updateLikedPostsInPostModel");
      return updatedNumberOfLikes;
    } catch (error) {
      log("There was an error during the updateLikedPostsInPostModel ${error.toString()}");
      return -1;
    }
  }

  Future<int?> updateLikedPostsInUserModel(String userUid, String pid) async {
    try {
      DocumentSnapshot userSnapShot = await _firebase
          .collection(FirebaseConstants.usercollectionName)
          .doc(userUid)
          .get();

      _logHelper("Get", "updateLikedPostsInUserModel");

      if (userSnapShot.exists == false) {
        log("User wasn't found in the Database");
        return null;
      }

      UserModel? user =
          UserModel.fromJson(userSnapShot.data() as Map<String, dynamic>);

      if (user != null) {
        List<String> likedPosts = user.likedPosts;
        bool alreadyLikedPosts = likedPosts.contains(pid);
        if (alreadyLikedPosts) {
          likedPosts.remove(pid);
          userSnapShot.reference
              .update({UserModelNameConstants.likedPosts: likedPosts});
          _logHelper("Update", "updateLikedPostsInUserModel");
          if (ref.read(currentUserProvider.notifier).mounted) {
            UserModel updatedUser = user.copyWith(likedPosts: likedPosts);
            ref.read(currentUserProvider.notifier).setUser(updatedUser);
          }
          return -1;
        } else {
          likedPosts.add(pid);
          userSnapShot.reference
              .update({UserModelNameConstants.likedPosts: likedPosts});
          _logHelper("Update", "updateLikedPostsInuserModel");

          if (ref.read(currentUserProvider.notifier).mounted) {
            UserModel updatedUser = user.copyWith(likedPosts: likedPosts);
            ref.read(currentUserProvider.notifier).setUser(updatedUser);
          }
          return 1;
        }
      }
    } catch (error) {
      log("There was an error in updateLikedPostsInUserModel ${error.toString()}");
      return null;
    }
    return null;
  }

  Future<int?> likedPosts(String userUid, String pid) async {
    try {
      int? updatedUserModelResult =
          await updateLikedPostsInUserModel(userUid, pid);

      if (updatedUserModelResult == null) return -1;

      int updatedPostModelResult =
          await updateLikedPostsInPostModel(pid, updatedUserModelResult);

      return updatedPostModelResult;
    } catch (error) {
      log("There has been an error during the function ${error.toString()}");
      return -1;
    }
  }
}

final likedPostServiceProvider = Provider<LikePostService>((ref) {
  return LikePostService(ref);
});
