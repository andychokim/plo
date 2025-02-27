import 'package:plo/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final logInVerifyProvider = StateProvider<bool>((ref) {
  final user = ref.watch(authRepository).getCurrentUser();

  if (user == null) {
    return false;
  }
  return true;
});

final anonymousLogInProvider = StateProvider<bool>((ref) => false);
