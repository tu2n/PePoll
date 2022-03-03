import 'package:flutter/material.dart';

class PollChoice {
  String choice;
  List<String> voted;
  String uid;

  PollChoice({
    @required this.choice,
    this.voted,
    this.uid
  });
}