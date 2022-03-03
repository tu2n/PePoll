import 'package:firebase_auth/firebase_auth.dart';

class LocalState {
  final User user;

  LocalState({
    this.user,
  });

  factory LocalState.initial() => LocalState(
      user: null,
  );

  LocalState copyWith({
    User user,
  }) => LocalState(
      user: user ?? this.user,
  );
}