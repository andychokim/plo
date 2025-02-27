import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/check_app_requirement/check_app_requirement_controller.dart';
import 'package:plo/common/providers/admin_provider.dart';
import 'package:plo/views/home_screen/home_screen.dart';
import 'package:plo/common/providers/user_provider.dart';

// final isEmailVerifiedProvider = StateProvider<bool>((ref) => FirebaseAuth.instance.currentUser!.emailVerified);
final isProfileSetUpProvider = StateProvider<bool>((ref) => false);
final showImageProvider = StateProvider<bool>((ref) => true);

class CheckAppRequirementScreen extends ConsumerStatefulWidget {
  const CheckAppRequirementScreen({super.key});

  @override
  ConsumerState<CheckAppRequirementScreen> createState() =>
      _CheckAppRequirementScreenState();
}

class _CheckAppRequirementScreenState
    extends ConsumerState<CheckAppRequirementScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Checking all app requirements...");
    final state = ref.watch(checkAppRequirementControllerProvider(context));
    final currentUser = ref.watch(currentUserProvider);
    final isAdmin = ref.watch(isAdminProvider);
    
    // final isEmailVerified = ref.watch(isEmailVerifiedProvider);
    // print("is User email verified: ${FirebaseAuth.instance.currentUser!.emailVerified}");
    // if (isEmailVerified == false) return const EmailVerificationScreen();
    return Scaffold(
        // This appbar is for changing the system overlay style
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        resizeToAvoidBottomInset: true,
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : const HomeScreen());
  }
}
