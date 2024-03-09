import 'package:email_vertify/model/user.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInfoNotifier extends StateNotifier<model.User> {
  UserInfoNotifier() : super(model.User.initial());

  void setUserdata(model.User user) {
    state = user;
  }
}

final userInfoProvider = StateNotifierProvider<UserInfoNotifier, model.User>(
  (ref) => UserInfoNotifier(),
);
