import 'package:pepoll/model/local_user.dart';

class PollDetailState {
  final String pollId;
  final LocalUser user;
  PollDetailState({this.pollId, this.user});

  factory PollDetailState.initial() => PollDetailState(
      pollId: "", user: LocalUser()
  );

  PollDetailState copyWith({
    String pollId,
    LocalUser user,
  }) => PollDetailState(pollId: pollId, user: user);
}