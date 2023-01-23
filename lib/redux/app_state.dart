import 'package:meta/meta.dart';
import 'package:pepoll/redux/home/home_state.dart';
import 'package:pepoll/redux/poll_detail/poll_detail_state.dart';

import 'local/local_state.dart';
import 'navigation/navigation_state.dart';

@immutable
class AppState {
  final LocalState localState;
  final NavigationState navigationState;
  final HomeState homeState;
  final PollDetailState pollDetailState;

  const AppState({
    @required this.localState,
    @required this.navigationState,
    @required this.homeState,
    @required this.pollDetailState,
  });

  factory AppState.initial() => AppState(
    localState: LocalState.initial(),
    navigationState: NavigationState.initial(),
    homeState: HomeState.initial(),
    pollDetailState: PollDetailState.initial(),
  );

  AppState copyWith({
    localState,
    navigationState,
    homeState,
    pollDetailState
  }) => AppState(
    localState: localState ?? this.localState,
    navigationState: navigationState ?? this.navigationState,
    homeState: homeState ?? this.homeState,
    pollDetailState: pollDetailState ?? this.pollDetailState
  );
}