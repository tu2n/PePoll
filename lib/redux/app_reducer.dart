import 'app_state.dart';
import 'home/home_reducer.dart';
import 'local/local_reducer.dart';
import 'navigation/navigation_reducer.dart';
import 'poll_detail/poll_detail_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    localState: localReducer(state.localState, action),
    navigationState: navigationReducer(state.navigationState, action),
    homeState: homeReducer(state.homeState, action),
    pollDetailState: pollDetailReducer(state.pollDetailState, action),
  );
}