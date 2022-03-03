import 'package:redux/redux.dart';
import 'navigation_action.dart';
import 'navigation_state.dart';

final navigationReducer = combineReducers<NavigationState>([
  TypedReducer<NavigationState, SaveCurrentNavigation>(_saveCurrentNavigation),
]);

NavigationState _saveCurrentNavigation(NavigationState state, SaveCurrentNavigation action) {
  return state.copyWith(navigation: action.navigation);
}