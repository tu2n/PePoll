import 'package:redux/redux.dart';

import 'local_action.dart';
import 'local_state.dart';

final localReducer = combineReducers<LocalState>([
  TypedReducer<LocalState, SetUser>(_setUser),
]);

LocalState _setUser(LocalState state, SetUser action) {
  return state.copyWith(user: action.user);
}