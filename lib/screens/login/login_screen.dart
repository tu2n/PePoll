import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pepoll/redux/app_state.dart';
import 'package:pepoll/screens/home/home_screen.dart';
import 'package:redux/redux.dart';

import '../../core/colors.dart';
import '../../core/pop_exit.dart';
import '../../provider/auth.dart';
import '../../provider/firestore.dart';
import '../../redux/local/local_action.dart';
import '../../redux/navigation/navigation_action.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User user;
  @override
  Widget build(BuildContext context) {
    Store<AppState> store = StoreProvider.of<AppState>(context);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => showExitPopup(context),
        child: Scaffold(
          backgroundColor: kLightMagenta,
          body: StreamBuilder<Object>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(),);
              }
              else if(snapshot.hasData) {
                return const HomeScreen();
              }
              else if(snapshot.hasError) {
                return const Center(child: Text('Something went wrong!'));
              }
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Text("PePoll",
                        style: TextStyle(
                            color: kWhite,
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 5.0
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.center,
                      child: Text("People's Choices Popularity Voting App",
                        style: TextStyle(
                          color: kWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Login to continue:",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white
                          //fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        try{
                          final userCredentials = await signIn();
                          setState(() =>  user = userCredentials.user);
                          if(user != null) {
                            await store.dispatch(SetUser(user: user));
                            if(userCredentials.additionalUserInfo.isNewUser) {
                              await addUser(user);
                              await addMember(user);
                            }else {
                              debugPrint("[LoginScreen] User it not new user");
                            }
                            store.dispatch(Navigation.pushHomeScreen);
                            debugPrint("[LoginScreen] User: ${store.state.localState.user.displayName}");
                          } else {
                            debugPrint("[Login Screen] User is NULL");
                          }
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                      label: const Text('Sign In with Google'),
                      style: ElevatedButton.styleFrom(
                          primary: kWhite,
                          onPrimary: Colors.black,
                          minimumSize: const Size(double.infinity, 50)
                      ),
                      icon: const Icon(Icons.alternate_email),
                    ),
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
