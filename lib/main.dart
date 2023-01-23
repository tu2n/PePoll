import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pepoll/redux/app_state.dart';
import 'package:pepoll/redux/store.dart';
import 'package:pepoll/screens/login/login_or_register.dart';
import 'package:pepoll/screens/poll/poll_detail_screen.dart';
import 'package:redux/redux.dart';
import 'redux/local/local_action.dart';
import 'redux/navigation/navigation_middleware.dart';
import 'screens/home/home_screen.dart';



Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final store = await createStore();

  runApp(PePoll(store: store));


  User user = FirebaseAuth.instance.currentUser;
  if(user != null)store.dispatch(SetUser(user: user));

}

class PePoll extends StatefulWidget {

  final Store<AppState> store;

  const PePoll({Key key, this.store}) : super(key: key);

  @override
  State<PePoll> createState() => _PePollState();
}

class _PePollState extends State<PePoll> {

  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: widget.store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "People's Choices Popularity Voting App",
        navigatorKey: navigatorKey,
        onGenerateRoute: (RouteSettings settings) => _getRoute(settings),
      ),
    );
  }
}

class Auth extends StatelessWidget {
  const Auth({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Store<AppState> store = StoreProvider.of<AppState>(context);
    return MaterialApp(
      home: Scaffold(
        body: StreamBuilder<User>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              store.dispatch(SetUser(user: FirebaseAuth.instance.currentUser));
              return const HomeScreen();
            }else {
              return const LoginOrRegisterScreen();
            }
          },
        ),
      ),
    );
  }
}

MaterialPageRoute _getRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
          settings: const RouteSettings(name: "/"),
          builder: (_) => const Auth());

    case '/login_or_register':
      return MaterialPageRoute(
          settings: const RouteSettings(name: "login_or_register"),
          builder: (_) => const LoginOrRegisterScreen());

    case '/home':
      return MaterialPageRoute(
          settings: const RouteSettings(name: "/home"),
          builder: (_) => const HomeScreen());

    case '/poll_detail_screen':
      return MaterialPageRoute(
          settings: const RouteSettings(name: "/poll_detail_screen"),
          builder: (_) => const PollDetailScreen());

    default:
      return MaterialPageRoute(
          settings: const RouteSettings(name: "/"),
          builder: (_) => const LoginOrRegisterScreen());
  }
}
