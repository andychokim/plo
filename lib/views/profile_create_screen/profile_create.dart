import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/utils/log_util.dart';
import '../../common/validator/validator.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../common/widgets/custom_button.dart';
import '../../common/widgets/my_widgets.dart';
import '../../model/types/return_type.dart';
import '../../repository/image_picker_repository.dart';
import '../../views/log_in_screen/log_in_screen.dart';
import '../../views/profile_create_screen/profile_create_controller.dart';
import '../../views/sign_up_screen_view/provider/signup_provider.dart';

class ProfileCreate extends ConsumerStatefulWidget {
  const ProfileCreate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<ProfileCreate> {
  //local 객체들
  File? image; //File? 타입 객체 - 프로필 이미지 로컬에서 받는 용도
  final formKey = GlobalKey<FormState>(); //GlobalKey 타입 객체 - onClicked의 validation 위한 Key
  //AuthMethods 타입 객체 - 받은 유저 정보(inputs)들 authenticator에 올리기 위한 용도

  //controllers - 각각 유저 input 받는 textformfield들의 validator들을 위한 controllers
  TextEditingController nickname = TextEditingController();
  TextEditingController grade = TextEditingController();
  TextEditingController major = TextEditingController();

  //프로필 사진 카메라/앨범에서 가져오는 function - ImageSource source --> 카메라 or 앨범
  Future<void> selectImage(ImageSource? source) async {
    final pickedImage = ref.watch(imagePickerRepositoryProvider);
    ReturnType result;
    if (source == ImageSource.camera) {
      result = await pickedImage.pickImageFromCamera();
    } else if (source == ImageSource.gallery) {
      result = await pickedImage.pickImageFromGallery();
    } else if (source == null) {
      //기본 프로필 옵션 선택 시
      image = null;
      ref.watch(selectedFile.notifier).setFile(null);
      return;
    } else {
      result = ErrorReturnType(message: "Invalid image Source");
    }
    if (result is SuccessReturnType && result.data != null) {
      File file = result.data;
      ref.watch(selectedFile.notifier).setFile(file);
      setState(() {
        image = file;
      });
    } else if (result is ErrorReturnType) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message!)));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //local 객체들 for holding each user inputs temporarily
    //final user = FirebaseAuth.instance.currentUser;
    final signUpInfo = ref.watch(signUpInfoProvider);
    final email = signUpInfo['email'] ?? '';
    final password = signUpInfo['password'] ?? '';
    File? profilePic = ref.watch(selectedFile);
    //Front-end codes
    return Scaffold(
      appBar: const BackButtonAppBar(),
      body: Container(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //프로필 사진 추가 Stateful Stack
                pfpStack(
                  pfpImage: image,
                  bgImage: const AssetImage('assets/images/profile_default.png'),
                  items: (BuildContext context) => <PopupMenuEntry>[
                    dropMenuItem(
                      val: "photo",
                      iconData: const Icon(
                        Icons.camera_alt_outlined,
                        size: 25,
                      ),
                      text: "사진 찍기",
                    ),
                    dropMenuItem(
                      val: "gallery",
                      iconData: const Icon(
                        Icons.collections_outlined,
                        size: 25,
                      ),
                      text: "갤러리에서 가져오기",
                    ),
                    dropMenuItem(
                      val: "default",
                      iconData: const Icon(
                        Icons.code_outlined,
                        size: 25,
                      ),
                      text: "기본 프로필 사용하기",
                    )
                  ],
                  onSelected: (value) {
                    if (value == 'photo') {
                      selectImage(ImageSource.camera);
                    } else if (value == 'gallery') {
                      selectImage(ImageSource.gallery);
                    } else if (value == 'default') {
                      image = null;
                      //어떤 value를 전달하는것이 아님. if/else 문을 위한 parameter pass
                      selectImage(null);
                    }
                  },
                ),
                //"프로필 설정"
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "프로필 설정",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                //프로필 상세 입력 Stateful TextFormField 및 확인 버튼
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        //정보 입력란 패딩
                        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                        child: Column(
                          children: [
                            //닉네임 입력
                            textFormFieldErrWithShadow(
                              textAbove: "닉네임",
                              shadowOffset: const Offset(0, 1),
                              controller: nickname,
                              validator: (value) => Validator.validateNickName(value),
                            ),
                            //학년 입력
                            textFormFieldErrWithShadow(
                              textAbove: "학년",
                              shadowOffset: const Offset(0, 1),
                              controller: grade,
                              inputRules: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^[1-9][0-9]*'),
                                ),
                                LengthLimitingTextInputFormatter(1),
                              ],
                              validator: (value) => Validator.validateGrade(value),
                            ),
                            //전공 입력
                            textFormFieldErrWithShadow(
                              textAbove: "전공",
                              shadowOffset: const Offset(0, 1),
                              controller: major,
                              validator: (value) => Validator.validateMajor(value),
                              textInputAction: TextInputAction.done,
                            ),
                          ],
                        ),
                      ),
                      //확인 버튼
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: CustomButton(
                          text: "확인",
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              // SelectedFileNotifier()
                              //     .checkNickNameDupsThenSignUp(
                              //   email,
                              //   password,
                              //   nickname.text,
                              //   grade.text,
                              //   major.text,
                              //   profilePic,
                              // )
                              //     .then((value) {
                              //   if (value == true) {
                              //     // success dialog pop up
                              //     Navigator.push(
                              //       // ignore: use_build_context_synchronously
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) =>
                              //             const SignInScreen(),
                              //       ),
                              //     );
                              //     logToConsole('User profile create succeed');
                              //   } else {
                              //     // failed dialog pop up
                              //     logToConsole('User profile create failed');
                              //   }
                              // });
                              bool isSignedUp = await ref
                                  .watch(selectedFile.notifier)
                                  .checkNickNameDupsThenSignUp(email, password, nickname.text, grade.text, major.text, profilePic);
                              if (isSignedUp) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignInScreen(),
                                  ),
                                );
                                logToConsole('User Profile create Successfully into the server');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("유저 프로필 사진 혹은 계정 생성을 하는데 실패하였습니다."),
                                  ),
                                );
                                logToConsole("User Profile create or Upload Failed");
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
