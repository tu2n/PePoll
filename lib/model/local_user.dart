import 'package:flutter/material.dart';

class LocalUser {
  String displayName;
  String email;
  String phoneNumber;
  String photoURL;
  String uid;

  LocalUser({
    @required this.displayName,
    @required this.email,
    @required this.phoneNumber,
    @required this.photoURL,
    @required this.uid
  });
}