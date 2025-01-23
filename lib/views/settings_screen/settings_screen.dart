import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/providers/admin_provider.dart';
import 'package:plo/common/widgets/custom_alert_box.dart';
import 'package:plo/repository/auth_repository.dart';
import 'package:plo/views/admin/admin_main_screen.dart';
import 'package:plo/views/log_in_screen/log_in_screen.dart';
import 'package:plo/views/settings_screen/likedpost_screen.dart';
import 'package:plo/views/settings_screen/mypost_screen.dart';
import 'package:plo/views/settings_screen/provider/user_provider.dart';
import 'package:plo/views/settings_screen/savedpost_screen.dart';
import 'package:plo/views/settings_screen/settings_controller.dart';
import 'package:plo/views/settings_screen/widgets/list_button_widget.dart';
import 'package:plo/views/settings_screen/widgets/modal_bottom_sheet.dart';
import 'package:plo/views/welcome_screen/welcome_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void goToSignInScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProvider);
    final user = ref.watch(userInfoProvider);
    print("my profile screen isAdmin : ${ref.watch(isAdminProvider)}");
    return Scaffold(
      body: userAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (_) {
          return Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 62,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                NetworkImage(user.userProfilePictureURL),
                          ),
                          //이미지 추가 팝업메뉴 버튼
                          Positioned(
                            right: -10,
                            bottom: -8,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: TextButton(
                                  child: Image.asset(
                                    "assets/images/profile_plus.png",
                                    width: 42.5,
                                  ),
                                  onPressed: () {
                                    showChoiceModalBottomSheet(context);
                                  }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        user.nickname,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${user.major} ${user.grade}학년',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 40),
                      const Divider(
                        color: CupertinoColors.systemGrey5,
                        thickness: 5,
                      ),
                      const SizedBox(height: 15),
                      if (ref.watch(isAdminProvider))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: const Text(
                                "게시물 관리자",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 100, 100, 100)),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ListButtonWidget(
                              title: "게시물 관리",
                              icon: const Icon(
                                Icons.edit,
                                size: 33,
                              ),
                              callback: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AdminMainScren(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      //나만의 기록들
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: const Text(
                              "나만의 기록들",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 100, 100, 100)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListButtonWidget(
                            title: "내 게시물",
                            icon: const Icon(
                              Icons.list_alt_rounded,
                              size: 33,
                            ),
                            callback: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const MyPostScreen(),
                              ));
                            },
                          ),
                          ListButtonWidget(
                            title: "저장한 게시물",
                            icon: const Icon(
                              Icons.bookmark_outline_rounded,
                              size: 33,
                            ),
                            callback: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SavedPostScreen(),
                                ),
                              );
                            },
                          ),
                          ListButtonWidget(
                            title: "좋아요한 게시물",
                            icon: const Icon(
                              Icons.thumb_up_alt_outlined,
                              size: 33,
                            ),
                            callback: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const LikedPostScreen(),
                              ));
                            },
                          ),
                        ],
                      ),

                      const Divider(
                        color: CupertinoColors.systemGrey5,
                        thickness: 5,
                      ),
                      const SizedBox(height: 15),
                      //앱 설정
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: const Text(
                              "앱 설정",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 100, 100, 100)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListButtonWidget(
                            title: "알림 설정",
                            icon: const Icon(
                              Icons.notifications_outlined,
                              size: 33,
                            ),
                            callback: () {},
                          ),
                        ],
                      ),
                      const Divider(
                        color: CupertinoColors.systemGrey5,
                        thickness: 5,
                      ),
                      const SizedBox(height: 15),

                      //계정관리
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: const Text(
                              "계정관리",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 100, 100, 100)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListButtonWidget(
                              title: "로그아웃",
                              icon: const Icon(
                                Icons.logout_outlined,
                                size: 33,
                              ),
                              callback: () async {
                                bool? confirmed =
                                    await AlertBox.showYesOrNoAlertDialogue(
                                  context,
                                  "로그아웃 하시겠습니까?",
                                );
                                if (confirmed == true) {
                                  final authMethods = ref.read(authRepository);
                                  await authMethods.signOut();
                                  goToSignInScreen(context);
                                }
                              }),
                          ListButtonWidget(
                              title: "계정 삭제",
                              icon: const Icon(
                                Icons.delete_outlined,
                                size: 33,
                              ),
                              callback: () async {
                                bool? isDelete =
                                    await AlertBox.showYesOrNoAlertDialogue(
                                        context, "정말로 계정을 삭제하시겠습니까?");
                                if (isDelete == true) {
                                  final result = await deleteUserAccount(ref);
                                  if (result.toString() ==
                                      'auth/requires-recent-login') {
                                    const snackBar = SnackBar(
                                      content: Text(
                                          '로그인 기간이 오래되어 인증정보가 만료되었습니다.\n. 로그아웃 후 다시 로그인한 다음 시도하여주시기 바랍니다.'),
                                    );

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    goToSignInScreen(context);
                                  }
                                }
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
