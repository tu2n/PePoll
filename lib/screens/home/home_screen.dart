import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pepoll/redux/app_state.dart';
import 'package:pepoll/screens/home/components/main_stream_widget.dart';
import 'package:redux/redux.dart';
import '../../core/colors.dart';
import '../../core/pop_exit.dart';
import '../../redux/navigation/navigation_action.dart';
import 'components/top_banner_widget.dart';

const FIRST_CHANNEL_UID = "ciJOX0OE1lEfocGv90Uy";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Store<AppState> store = StoreProvider.of<AppState>(context);
    final User user = store.state.localState.user;
    final String firstName = user.displayName.split((' '))[0];
    final String email = user.email;
    return Scaffold(
      backgroundColor: kMatteViolet,
      body: WillPopScope(
        onWillPop: () => showExitPopup(context),
        child: SafeArea(
          child: Column(
            children: [
              TopBannerWidget(firstName: firstName, email: email),
              MainStreamWidget(firestore: _firestore, store: store),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          store.dispatch(Navigation.pushCreatePollScreen);
        },
        child: const Icon(
            Icons.add
        ),
        foregroundColor: kWhite,
        backgroundColor: kLightMagenta,
      ),
    );
  }
}
