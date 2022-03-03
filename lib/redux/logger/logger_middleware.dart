import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';
import '../app_state.dart';

//* logging redux action
class LoggerMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    debugPrint("DISPATCHED ACTION: ${action.toString()}");
    next(action);
  }
}