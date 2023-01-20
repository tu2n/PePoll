import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pepoll/redux/app_state.dart';
import 'package:pepoll/screens/home/components/all_polls_tab.dart';
import 'package:pepoll/screens/home/components/explore_banner.dart';
import 'package:redux/redux.dart';
import '../../core/colors.dart';
import '../../core/pop_exit.dart';
import '../../redux/navigation/navigation_action.dart';
import 'components/create_poll_tab.dart';
import 'components/profile_tab.dart';
import 'components/tab_bar_widget.dart';
import 'components/user_polls_tab.dart';

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

    final tabContents = [
      AllPollsTab(firestore: _firestore, store: store),
      UserPollsTab(firestore: _firestore, store: store),
      const CreatePollTab(),
      ProfileTab(user: user,),
      //ProfileTab(user: user,),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kMatteViolet,
      body: WillPopScope(
        onWillPop: () => showExitPopup(context),
        child: SafeArea(
          child: StoreConnector<AppState, Map<String, dynamic>>(
            converter: (store) => {
              'currentTabIndex' : store.state.homeState.currentTabIndex,
            },
            builder: (context, vm) {
              return Column(
                children: [
                  TapBanner(
                    visible: vm['currentTabIndex'] == 0 || vm['currentTabIndex'] == 1,
                    isAllPollsTab: vm['currentTabIndex'] == 0,
                  ),
                  tabContents[vm['currentTabIndex']],
                  KeyboardVisibilityBuilder(
                    builder: (context, isKeyboardVisible) {
                      return Visibility(
                          visible: !isKeyboardVisible,
                          child: TabBarWidget(currentIndex: vm['currentTabIndex'])
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: false,
        child: FloatingActionButton(
          onPressed: () {
            store.dispatch(Navigation.pushCreatePollScreen);
          },
          child: const Icon(
              Icons.add
          ),
          foregroundColor: kWhite,
          backgroundColor: kLightMagenta,
        ),
      ),
    );
  }
}
