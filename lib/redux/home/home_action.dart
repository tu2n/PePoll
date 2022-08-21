class ChangeTabAction {
  final int tabIndex;

  ChangeTabAction(this.tabIndex);

  @override
  String toString() {
    return '${super.toString()} : $tabIndex';
  }
}