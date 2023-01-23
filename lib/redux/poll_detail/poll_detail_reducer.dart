import 'package:redux/redux.dart';

import 'poll_detail_action.dart';
import 'poll_detail_state.dart';

final pollDetailReducer = combineReducers<PollDetailState>([
  TypedReducer<PollDetailState, SelectPollToViewAction>(_selectPollToViewAction),

]);


PollDetailState _selectPollToViewAction(PollDetailState state, SelectPollToViewAction action) {
  return state.copyWith(pollId: action.pollId, user: action.user);
}