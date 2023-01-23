enum Navigation {
  pushAuthWall,
  pushLoginOrRegister,
  pushHomeScreen,
  pushPollDetailScreen
}

class SaveCurrentNavigation {
  final Navigation navigation;

  SaveCurrentNavigation({this.navigation});

  @override
  String toString() {
    return '${super.toString()} : $navigation';
  }
}