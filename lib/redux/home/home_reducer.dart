import 'package:pepoll/redux/home/home_action.dart';
import 'package:pepoll/redux/home/home_state.dart';
import 'package:redux/redux.dart';

final homeReducer = combineReducers<HomeState>([
  TypedReducer<HomeState, ChangeTabAction>(_changeTabAction),

]);


HomeState _changeTabAction(HomeState state, ChangeTabAction action) {
  return state.copyWith(currentTabIndex: action.tabIndex);
}
