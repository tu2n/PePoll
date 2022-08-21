import 'package:flutter/material.dart';
import 'package:pepoll/core/colors.dart';

class TapBanner extends StatelessWidget {
  final bool visible;
  final bool isAllPollsTab;
  const TapBanner({Key key, @required this.visible, @required this.isAllPollsTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                isAllPollsTab ? "Polls" : "Your Polls",
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: kWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
