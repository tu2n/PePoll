import 'package:flutter/material.dart';
import 'package:pepoll/core/colors.dart';

class QuestionTextWidget extends StatelessWidget {
  final String question;
  const QuestionTextWidget({Key key, @required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(question,
        style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kWhite
        ),
      ),
    );
  }
}
