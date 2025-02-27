import 'dart:developer';
import 'dart:io';

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/providers/singlepost.dart';
import 'package:plo/common/utils/log_util.dart';
import 'package:plo/constants/error_message_constants.dart';
import 'package:plo/extensions/ref_dipsose.dart';
import 'package:plo/model/post_model.dart';
import 'package:plo/model/state_model/create_edit_post_model.dart';
import 'package:plo/model/types/return_type.dart';
import 'package:plo/repository/firebase_post_repository.dart';
import 'package:plo/repository/firebasestoroage_respository.dart';
import 'package:plo/repository/image_picker_repository.dart';
import 'package:plo/views/home_screen/main_post_list_provider.dart';
import 'package:plo/views/post_write/post_write_providers.dart';
import 'package:plo/views/post_write/post_write_screen/widgets/post_image_view.dart';
import 'package:plo/common/providers/user_provider.dart';
import 'package:uuid/uuid.dart';

class CreatePostController extends StateNotifier<AsyncValue<void>> {
  final SwiperController _swiperController = SwiperController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  // final TextEditingController _categoryController = TextEditingController();
  final Ref ref;

  CreatePostController(this.ref) : super(const AsyncLoading()) {
    _init();
  }
  get swiperController => _swiperController;
  TextEditingController get titleController => _titleController;
  get contentController => _contentController;
  // get categoryController => _categoryController;

  _init() async {
    state = const AsyncLoading();

    if (ref.read(createEditPostStateProvider).isForEdit) {
      final PostModel postStateModel =
          ref.read(createEditPostStateProvider).editPostInformation!;
      _titleController.text = postStateModel.postTitle;
      _contentController.text = postStateModel.postContent;
      // _categoryController.text = postStateModel.category.toString();
    }
    logToConsole("Create post Controller init");
    state = const AsyncData(null);
  }

  initAllFieldforEdit(CreateEditPostModel editPostInformation) {
    _titleController.text = editPostInformation.postTitle;
    _contentController.text = editPostInformation.postContent;
    // _categoryController.text = editPostInformation.category.toString();
  }

  void movetoEnd() {
    _swiperController
        .move(ref.read(createEditPostStateProvider).photos.length - 1);
  }

  swiperToEnd() {
    _swiperController.index =
        ref.read(createEditPostStateProvider).photos.length - 1;
  }

  void pickMultipleImagesFromGallery() async {
    ref.read(imageLoadingProvider.notifier).state = true;
    final result = await ref
        .watch(imagePickerRepositoryProvider)
        .pickMultipleImageFromGallery();
    if (result is ErrorReturnType) {
      ref.read(imageLoadingProvider.notifier).state = false;
      state = AsyncError(result.message!, StackTrace.current);
      state = const AsyncData(null);

      return;
    } else if (result is SuccessReturnType && result.data == null) {
      ref.read(imageLoadingProvider.notifier).state = true;
      return;
    }
    final List<File?> images = result.data as List<File?>;

    for (int i = 0; i < images.length; i++) {
      if (ref.read(createEditPostStateProvider).photos.length >= 6) {
        state = AsyncError("6개 이상의 사진은 업로드 할 수 없습니다.", StackTrace.current);
        break;
      }
      if (images[i] != null) {
        List<Object> updatedPhotos = [
          ...ref.read(createEditPostStateProvider).photos,
          images[i]!
        ];
        ref
            .read(createEditPostStateProvider.notifier)
            .updatePhotos(updatedPhotos);
      }
    }
    swiperToEnd();
    ref.read(imageLoadingProvider.notifier).state = false;
  }

  void pickImageFromCamera() async {
    if (ref.read(createEditPostStateProvider).photos.length >= 6) {
      state = AsyncError("6개 이상의 사진은 업로드 할 수 없습니다", StackTrace.current);
    } else {
      ref.read(imageLoadingProvider.notifier).state = true;
      final result =
          await ref.watch(imagePickerRepositoryProvider).pickImageFromCamera();
      if (result is ErrorReturnType) {
        ref.read(imageLoadingProvider.notifier).state = false;
        state = AsyncError(result.message!, StackTrace.current);
        state = const AsyncData(null);

        return;
      } else if (result is SuccessReturnType && result.data == null) {
        ref.read(imageLoadingProvider.notifier).state = false;

        return;
      }
      if (result is SuccessReturnType && result.data != null) {
        List<Object> updatedPhotos = [
          ...ref.read(createEditPostStateProvider).photos,
          result.data!
        ];
        ref
            .read(createEditPostStateProvider.notifier)
            .updatePhotos(updatedPhotos);
      }
    }
    swiperToEnd();
    ref.read(imageLoadingProvider.notifier).state = false;
  }

  Future<bool> uploadPost({required GlobalKey<FormState> formKey}) async {
    try {
      if (!formKey.currentState!.validate()) {
        return false;
      }
      //controller: title and content
      final postState = ref.read(createEditPostStateProvider);

      // if (postState.postTitle.isEmpty) {
      //   state = AsyncError("게시물 제목을 작성해주세요", StackTrace.current);
      //   state = const AsyncData(null);
      //   return false;
      // }
      // if (postState.postContent.isEmpty) {
      //   state = AsyncError("게시물 내용은 빈칸으로 올릴 수 없습니다", StackTrace.current);
      //   state = const AsyncData(null);
      //   return false;
      // }

      final isForEdit = postState.isForEdit;
      if (ref.read(currentUserProvider.notifier).mounted == false ||
          ref.read(currentUserProvider) == null) {
        state = AsyncError("Debug: current user error", StackTrace.current);
        state = const AsyncData(null);
        return false;
      }
      print(
          'currentUserProvider.notifier.mounted: ${ref.read(currentUserProvider.notifier).mounted}');
      print('currentUserProvider value: ${ref.read(currentUserProvider)}');

      final user = ref.read(currentUserProvider)!;

      final String pid =
          isForEdit ? postState.editPostInformation!.pid : const Uuid().v1();
      final photos = postState.photos;
      List<String>? photoUrls = await ref
          .watch(firebaseStorageProvider)
          .uploadPostImageToStorage(user.userUid, pid, photos);
      log("it is uploaded in the Storage");
      if (photoUrls == null) {
        state = AsyncError(
            ErrorMessageConstants.imageUploadError, StackTrace.current);
        log("It is not uploading to the firebase");
        state = const AsyncData(null);
        return false;
      }
      PostModel post;

      if (isForEdit) {
        post = postState.editPostInformation!.update(
          postTitle: _titleController.text,
          postContent: _contentController.text,
          category: postState.category,
          contentImageUrlList: photoUrls,
        );
      } else {
        post = PostModel(
          pid: pid,
          uploadUserUid: user.userUid,
          userNickname: user.userNickname,
          userProfileURL: user.profileImageUrl,
          category: postState.category,
          postContent: _contentController.text,
          postTitle: _titleController.text,
          contentImageUrlList: photoUrls,
          postLikes: 0,
          uploadTime: Timestamp.now(),
          commentCount: 0,
        );
      }
      final postUploadResult = await ref
          .watch(firebasePostRepositoryProvider)
          .uploadPostFirebase(post, isForEdit);
      if (postUploadResult == false) {
        state = AsyncError(
            ErrorMessageConstants.postUploadError, StackTrace.current);
        state = const AsyncData(null);
        return false;
      }

      if (isForEdit) {
        ref.read(mainPostListProvider.notifier).updateSingePostInPostList(post);
        await ref
            .read(singlePostProvider(postState.editPostInformation!).notifier)
            .updatePostFromServer();
      } else {
        ref.read(mainPostListProvider.notifier).addListenToPostList([post]);
      }
      if (isForEdit) {
        await ref
            .read(singlePostProvider(postState.editPostInformation!).notifier)
            .updatePostFromServer();
      }
      return true;
    } catch (error) {
      logToConsole("${ErrorMessageConstants.unknownError} : $error");
      return false;
    } finally {
      state = const AsyncData(null);
    }
  }
}

final createEditPostStateController =
    StateNotifierProvider.autoDispose<CreatePostController, AsyncValue<void>>(
        (ref) {
  ref.logDisposeToConsole("CreatePostController Disposed");
  return CreatePostController(ref);
});
