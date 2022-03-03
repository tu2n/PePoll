import 'package:redux/redux.dart';

import 'app_reducer.dart';
import 'app_state.dart';
import 'local/local_middleware.dart';
import 'logger/logger_middleware.dart';
import 'navigation/navigation_middleware.dart';


Future<Store<AppState>> createStore() async {
  return Store(appReducer,
      initialState: AppState.initial(),
      middleware: [
        LocalMiddleware(),
        LoggerMiddleware(),
        NavigationMiddleware()
      ]
  );
}