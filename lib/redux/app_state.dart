import 'package:meta/meta.dart';

import 'local/local_state.dart';
import 'navigation/navigation_state.dart';

@immutable
class AppState {
  final LocalState localState;
  final NavigationState navigationState;

  const AppState({
    @required this.localState,
    @required this.navigationState
  });

  factory AppState.initial() => AppState(
    localState: LocalState.initial(),
    navigationState: NavigationState.initial()
  );


  AppState copyWith({
    localState,
    navigationState
  }) => AppState(
    localState: localState ?? this.localState,
    navigationState: navigationState ?? this.navigationState
  );
}