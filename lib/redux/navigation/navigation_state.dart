import 'navigation_action.dart';

class NavigationState{
  final Navigation navigation;

  NavigationState({this.navigation});

  factory NavigationState.initial() => NavigationState(
      navigation: null
  );

  NavigationState copyWith({
    Navigation navigation
  }) => NavigationState(
      navigation: navigation ?? this.navigation
  );
}