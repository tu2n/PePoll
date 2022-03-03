import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';

import '../app_state.dart';
import 'local_action.dart';

class LocalMiddleware extends MiddlewareClass<AppState> {
  static final unSubscriber = PublishSubject<void>();

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {

    next(action);
  }
}