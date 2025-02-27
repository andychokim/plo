import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/utils/log_util.dart';
import 'package:plo/constants/firebase_contants.dart';
import 'package:plo/model/erro_handling/error_handling_auth.dart';
import 'package:plo/model/types/enum_type.dart';
import 'package:plo/model/user_model.dart';
import 'package:plo/repository/firebasestoroage_respository.dart';
import 'package:plo/common/providers/user_provider.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final Ref ref;

  AuthMethods(this.ref);
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String nickname,
    required String grade,
    required String major,
    required File? file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty || nickname.isNotEmpty || grade.isNotEmpty || major.isNotEmpty || file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        String photoUrl = file != null
            ? await StorageMethods().uploadProfileImageToStorage('profilePics', file, false)
            : "https://firebasestorage.googleapis.com/v0/b/project-plo.appspot.com/o/profilePics%2Fprofile_default.png?alt=media&token=46c5a927-ba2c-4901-9a2e-d3f7c60aca2e";

        //이런 방식으로 하면 doc uid가 자동으로 auth uid로 생성이 됨

        // _firestore.collection('users').doc(cred.user!.uid).set({
        //   'grade': grade,
        //   'major': major,
        //   'nickname': nickname,
        //   'user_pfp': photoUrl,
        // });
        UserModel userModel = UserModel(
            userUid: cred.user!.uid,
            email: email,
            userNickname: nickname,
            userCreatedDate: Timestamp.now(),
            grade: grade,
            major: major,
            profileImageUrl: photoUrl,
            likedPosts: [],
            blockedUsers: []);

        await _firestore.collection(FirebaseConstants.usercollectionName).doc(userModel.userUid).set(userModel.toJson());
        ref.read(currentUserProvider.notifier).setUser(userModel);
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> signInUserWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      await ref.read(currentUserProvider.notifier).updateUserFromFirebase();
      return ReturnTypeENUM.success.toString();
    } on FirebaseAuthException catch (error) {
      String errorText = ErrorHandlerFunction().signInErrorToString(error);
      return errorText.toString();
    } catch (error) {
      logToConsole("Error ${error.toString()} in SignInUserWithEmail");
      return error.toString();
    }
  }

  Future<String> sendPasswordEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return ReturnTypeENUM.success.toString();
    } catch (error) {
      return error.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    ref.read(currentUserProvider.notifier).setUser(null);
  }

  Future<String> deleteUserAccount() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
      return ReturnTypeENUM.success.toString();
    } on FirebaseAuthException catch (error) {
      return error.toString();
    } catch (error) {
      return error.toString();

      // Handle general exception
    }
  }

  Future<String> nonUserSignIn() async {
    try {
      await _auth.signInAnonymously();
      // await ref.read(currentUserProvider.notifier).updateUserFromFirebase();
      return ReturnTypeENUM.success.toString();
    } on FirebaseAuthException catch (error) {
      logToConsole("Error ${error.toString()} in nonUserSignIn");
      return error.toString();
    } catch (error) {
      logToConsole("Error ${error.toString()} in nonUserSignIn");
      return error.toString();
    }
  }
}

final authRepository = Provider<AuthMethods>((ref) {
  return AuthMethods(ref);
});
