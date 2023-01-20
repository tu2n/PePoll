import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pepoll/core/colors.dart';
import 'package:pepoll/core/utils.dart';
import 'package:pepoll/provider/auth.dart';
import 'package:pepoll/redux/app_state.dart';
import 'package:pepoll/redux/local/local_action.dart';
import 'package:pepoll/screens/components/common_button.dart';
import 'package:pepoll/screens/components/common_textfield.dart';
import 'package:pepoll/screens/components/square_tile.dart';
import 'package:redux/redux.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onTap;
  const RegisterScreen({Key key, @required this.onTap}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  User user;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController?.dispose();
    _passwordController?.dispose();
    _confirmPasswordController?.dispose();
    super.dispose();
  }

  void singUp(
      BuildContext context,
      String email,
      String password,
      String confirmPassword) async{
    if(email == '' && password == '' && confirmPassword == '') {
      Utils().showErrorMessage(context, 'Please provide email and password!');
    } else if(email == '') {
      Utils().showErrorMessage(context, 'No email provided!');
    } else if (password == ''){
      Utils().showErrorMessage(context, 'No password provided!');
    } else if (confirmPassword == '') {
      Utils().showErrorMessage(context, 'No confirm password provided!');
    }else if(password != confirmPassword) {
      Utils().showErrorMessage(context, 'Password don\'t match!');
    } else if(password.length < 6) {
      Utils().showErrorMessage(context, 'Passwords should consist 6 or more characters!');
    }
    else {
      //show loading screen
      final bool isSuccess = await Auth().signUpWithEmailAndPassword(
          context,
          email,
          confirmPassword
      );
      // pop loading screen if mounted
    }
  }

  @override
  Widget build(BuildContext context) {
    Store<AppState> store = StoreProvider.of<AppState>(context);
    return Scaffold(
      backgroundColor: kMatteViolet,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Icon(Icons.lock, size: 80, color: kLightMagenta,),
            const SizedBox(height: 30),
            Text(
              'Let\'s create an account for you!',
              style: TextStyle(color: Colors.grey[700], fontSize: 16,
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
            const SizedBox(height: 10),
            CommonTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: true,
            ),
            const SizedBox(height: 25),
            // sign in button
            CommonButton(
              btnTitle: 'Sign Up',
              onTap: () async{
                singUp(
                    context,
                    _emailController.text,
                    _passwordController.text,
                    _confirmPasswordController.text
                );
              },
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
                  'Already have an account?',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    'Sign in now',
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
    );
  }
}
