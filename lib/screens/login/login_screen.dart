import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pepoll/redux/app_state.dart';
import 'package:pepoll/screens/components/common_button.dart';
import 'package:pepoll/screens/components/common_textfield.dart';
import 'package:pepoll/screens/components/square_tile.dart';
import 'package:redux/redux.dart';

import '../../core/colors.dart';
import '../../core/pop_exit.dart';
import '../../provider/auth.dart';
import '../../redux/local/local_action.dart';
import '../../core/utils.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onTap;
  const LoginScreen({Key key, @required this.onTap}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User user;
  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController?.dispose();
    _passwordController?.dispose();
    super.dispose();
  }

  void signIn(BuildContext context, String email, String password,) async{
    if(email == '' && password == '') {
      Utils().showErrorMessage(context, 'Please provide email and password!');
    } else if(email == '') {
      Utils().showErrorMessage(context, 'No email provided!');
    } else if (password == ''){
      Utils().showErrorMessage(context, 'No password provided!');
    }
    else {
      // show loading screen
      final isSuccess = await Auth().signInWithEmailAndPassword(
          context,
          _emailController.text,
          _passwordController.text
      );
      // pop loading screen if mounted
    }
  }
  @override
  Widget build(BuildContext context) {
    Store<AppState> store = StoreProvider.of<AppState>(context);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => showExitPopup(context),
        child: Scaffold(
          backgroundColor: kMatteViolet,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(Icons.lock, size: 100, color: kLightMagenta,),
                const SizedBox(height: 50),
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                CommonTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                CommonTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                CommonButton(
                  btnTitle: 'Sign In',
                  onTap: () async => signIn(context, _emailController.text, _passwordController.text),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(
                      onTap: () async{
                        showDialog(
                          useRootNavigator: false,
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                        try {
                          user = await Auth().signInWithGoogle(context);
                          store.dispatch(SetUser(user: user));
                          Navigator.of(context).pop(const CircularProgressIndicator());
                        } catch (e) {
                          Navigator.of(context).pop(const CircularProgressIndicator());
                        }
                      },
                      imagePath: 'assets/images/google.png',
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Sign up now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}
