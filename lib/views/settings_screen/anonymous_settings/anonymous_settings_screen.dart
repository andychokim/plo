import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/custom_app_bar.dart';

class AnonymousSettingsScreen extends ConsumerWidget {
  const AnonymousSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      appBar: BackButtonAppBar(title: "익명 설정"),
      body: Center(
        child: Text("익명 설정 화면"),
      ),
    );
  }
}
