import 'package:flutter/material.dart';
import 'package:secretchatting/auth_methods_chat/users_state.dart';

class Utils {
  static int stateToNum(UsersState usersState) {
    switch (usersState) {
      case UsersState.Offline:
        return 0;

      case UsersState.Online:
        return 1;

      default:
        return 2;
    }
  }

  static UsersState numToState(int number) {
    switch (number) {
      case 0:
        return UsersState.Offline;

      case 1:
        return UsersState.Online;

      default:
        return UsersState.Waiting;
    }
  }
}
