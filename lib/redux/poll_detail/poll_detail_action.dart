import 'package:pepoll/model/local_user.dart';

class SelectPollToViewAction {
  final String pollId;
  final LocalUser user;

  SelectPollToViewAction(this.pollId, this.user);

  @override
  String toString() {
    return '${super.toString()} : $pollId';
  }
}