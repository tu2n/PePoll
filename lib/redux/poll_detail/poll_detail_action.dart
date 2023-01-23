import 'package:pepoll/model/local_user.dart';

class SelectPollToViewAction {
  final String pollId;
  final LocalUser user;
  final bool createdByCurrentUser;

  SelectPollToViewAction(this.pollId, this.user, this.createdByCurrentUser);

  @override
  String toString() {
    return '${super.toString()} : $pollId';
  }
}