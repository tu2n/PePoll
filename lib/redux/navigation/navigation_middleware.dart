import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';
import '../app_state.dart';
import 'navigation_action.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NavigationMiddleware extends MiddlewareClass<AppState> {
  final unSubscriber = PublishSubject<void>();

  @override
  Future<void> call(Store<AppState> store, action, NextDispatcher next) async {
    if (action is Navigation) {

      // save the current Navigation
      store.dispatch(SaveCurrentNavigation(navigation: action));

      switch (action) {

        case Navigation.pushLoginScreen:
          unSubscriber.add(null);
          navigatorKey.currentState.pushNamed("/login");
          debugPrint('Push Login Screen');
          break;

        case Navigation.pushHomeScreen:
          unSubscriber.add(null);
          navigatorKey.currentState.pushNamed("/home");
          debugPrint('Push Home Screen');
          break;

        case Navigation.pushCreatePollScreen:
          unSubscriber.add(null);
          navigatorKey.currentState.pushNamed("/create_poll");
          debugPrint('Push Create Poll Screen');
          break;

        default:
          break;
      }
    }
    next(action);
  }
}