import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plo/constants/firebase_contants.dart';
import 'package:plo/model/types/return_type.dart';
import 'package:plo/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseUserRepository {
  final _auth = FirebaseAuth.instance;
  final _firebase = FirebaseFirestore.instance;
  void _logHelper(String typeofAction, String funcitonName) {
    log("Firestore was Used ($typeofAction) in $funcitonName in FirebaseUserRepository");
  }

  User? get currentUser => _auth.currentUser;

  Future<bool> uploadUserModel(UserModel user) async {
    try {
      await _firebase
          .collection(FirebaseConstants.usercollectionName)
          .doc(user.userUid)
          .set(user.toJson());
      _logHelper("Set", "uploadUserModel");
      return true;
    } catch (error) {
      log("UserRepository uploadUserModel error: $error");
      return false;
    }
  }

  Future<UserModel?> fetchUser() async {
    try {
      DocumentSnapshot documentSnapshot = await _firebase
          .collection(FirebaseConstants.usercollectionName)
          .doc(_auth.currentUser!.uid)
          .get();
      log("Get CurrentUserModel");
      if (documentSnapshot.exists) {
        UserModel? jsontoUserConverted =
            UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);

        return jsontoUserConverted;
      } else {
        log("Document does not exists");
        return null;
      }
    } catch (error) {
      log("UserRepository uploadUserModel error: $error ");
      return null;
    }
  }

  Future<UserModel?> fetchUserbyUid(String userUid) async {
    try {
      DocumentSnapshot documentSnapshot = await _firebase
          .collection(FirebaseConstants.usercollectionName)
          .doc(userUid)
          .get();
      if (documentSnapshot.exists) {
        UserModel? jsonUserconverted =
            UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
        return jsonUserconverted;
      } else {
        return null;
      }
    } catch (error) {
      log("UserRepository fetchUserbyUid Error Occurred");
      return null;
    }
  }

  Future<bool> userAdmin(String userUid) async {
    try {
      DocumentSnapshot documentSnapshot = await _firebase
          .collection(FirebaseConstants.adminUsers)
          .doc(userUid)
          .get();
      log("Document data: ${documentSnapshot.data()}");

      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        log("Document exists for UID: $userUid");

        return true;
      }
      return false;
    } catch (error) {
      log("User Repository is UserAdmin error: ${error}");
      return false;
    }
  }

  Future<ReturnType> blockUser(String blockingUserUid) async {
    try {
      bool isUserBlocked = false;
      final DocumentSnapshot documentSnapshot = await _firebase
          .collection(FirebaseConstants.usercollectionName)
          .doc(_auth.currentUser!.uid)
          .get();
      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        final UserModel? user =
            UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
        if (user != null) {
          List<String> blockedUsers = user.blockedUsers;
          if (blockedUsers.contains(blockingUserUid)) {
            blockedUsers.remove(blockingUserUid);
            isUserBlocked = false;
          } else {
            blockedUsers.add(blockingUserUid);
            isUserBlocked = true;
          }
          await _firebase
              .collection(FirebaseConstants.usercollectionName)
              .doc(_auth.currentUser!.uid)
              .update({"blockedUsers": blockedUsers});
          log(" block/unblock operation successful");
          return SuccessReturnType(isSuccess: true, data: isUserBlocked);
        }
        return ErrorReturnType(message: "User is Null");
      }
      return SuccessReturnType(
          isSuccess: false, message: "DocumentSnapshot does not exists");
    } catch (error) {
      return ErrorReturnType(message: error.toString(), data: error);
    }
  }
}

final firebaseUserRepositoryProvider = Provider<FirebaseUserRepository>((ref) {
  return FirebaseUserRepository();
});
