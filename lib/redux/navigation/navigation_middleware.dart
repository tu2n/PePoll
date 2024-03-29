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

        case Navigation.pushAuthWall:
          unSubscriber.add(null);
          navigatorKey.currentState.pushNamed("/");
          debugPrint('Push Auth Wall');
          break;

        case Navigation.pushLoginOrRegister:
          unSubscriber.add(null);
          navigatorKey.currentState.pushNamed("/login_or_register");
          debugPrint('Push Auth Wall');
          break;

        case Navigation.pushHomeScreen:
          unSubscriber.add(null);
          navigatorKey.currentState.pushNamed("/home");
          debugPrint('Push Home Screen');
          break;

        case Navigation.pushPollDetailScreen:
          unSubscriber.add(null);
          navigatorKey.currentState.pushNamed("/poll_detail_screen");
          debugPrint('Push Poll Detail Screen');
          break;

        default:
          break;
      }
    }
    next(action);
  }
}