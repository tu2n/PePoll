import 'package:pepoll/model/local_user.dart';

class PollDetailState {
  final String pollId;
  final LocalUser user;
  final bool createdByCurrentUser;
  PollDetailState({this.pollId, this.user, this.createdByCurrentUser});

  factory PollDetailState.initial() => PollDetailState(
    pollId: "",
    user: LocalUser(),
    createdByCurrentUser: false
  );

  PollDetailState copyWith({
    String pollId,
    LocalUser user,
    bool createdByCurrentUser,
  }) => PollDetailState(
      pollId: pollId,
      user: user,
      createdByCurrentUser: createdByCurrentUser
  );
}