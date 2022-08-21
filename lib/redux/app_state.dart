import 'package:meta/meta.dart';
import 'package:pepoll/redux/home/home_state.dart';

import 'local/local_state.dart';
import 'navigation/navigation_state.dart';

@immutable
class AppState {
  final LocalState localState;
  final NavigationState navigationState;
  final HomeState homeState;

  const AppState({
    @required this.localState,
    @required this.navigationState,
    @required this.homeState,
  });

  factory AppState.initial() => AppState(
    localState: LocalState.initial(),
    navigationState: NavigationState.initial(),
    homeState: HomeState.initial(),
  );

  AppState copyWith({
    localState,
    navigationState,
    homeState,
  }) => AppState(
    localState: localState ?? this.localState,
    navigationState: navigationState ?? this.navigationState,
    homeState: homeState ?? this.homeState
  );
}