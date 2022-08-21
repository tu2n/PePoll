class HomeState {
  final int currentTabIndex;

  HomeState({
    this.currentTabIndex,
  });
  factory HomeState.initial() => HomeState(
    currentTabIndex: 0,
  );

  HomeState copyWith({
    int currentTabIndex,
  }) => HomeState(
    currentTabIndex : currentTabIndex ?? this.currentTabIndex,
  );
}