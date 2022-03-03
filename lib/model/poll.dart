import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Poll {
  String question;
  String expiration;
  String createdBy;
  String uid;

  Poll({
    @required this.question,
    @required this.expiration,
    @required this.createdBy,
    this.uid,
  });

  static String formatExpDateToString(DateTime date) {
    return DateFormat('yMMMMd').format(date);
  }

  static String formatExpDateToString2(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static DateTime formatStringDateToDateTime(String stringDate) {
    return DateTime.parse(stringDate);
  }
}