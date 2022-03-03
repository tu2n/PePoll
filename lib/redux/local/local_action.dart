import 'package:firebase_auth/firebase_auth.dart';

class SetUser {
  final User user;

  SetUser({this.user});

  @override
  String toString() {
    return '${super.toString()} : {User email address: ${user.email}}';
  }
}