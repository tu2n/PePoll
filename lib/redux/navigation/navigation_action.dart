enum Navigation {
  pushLoginScreen,
  pushHomeScreen,
  pushCreatePollScreen
}

class SaveCurrentNavigation {
  final Navigation navigation;

  SaveCurrentNavigation({this.navigation});

  @override
  String toString() {
    return '${super.toString()} : $navigation';
  }
}