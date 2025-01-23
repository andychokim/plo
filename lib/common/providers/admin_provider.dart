import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plo/common/utils/log_util.dart';

final isAdminProvider = StateProvider.autoDispose((ref) {
  ref.onDispose(() {
    logToConsole("isAdminProvider disposed");
  });
  return false;
});
