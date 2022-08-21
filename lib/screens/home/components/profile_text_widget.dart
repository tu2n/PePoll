import 'package:flutter/material.dart';
import 'package:pepoll/core/colors.dart';

class ProfileTextWidget extends StatelessWidget {
  final String text;
  const ProfileTextWidget({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              stops: [0.02, 0.02],
              colors: [kLightMagenta, kDarkMatteViolet]),
          borderRadius: BorderRadius.all(Radius.circular(6.0)
          )
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, color: kWhite),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
