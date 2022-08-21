import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pepoll/core/colors.dart';
import 'package:pepoll/redux/app_state.dart';
import 'package:pepoll/redux/home/home_action.dart';
import 'package:pepoll/redux/navigation/navigation_action.dart';
import 'package:redux/redux.dart';

class TabBarWidget extends StatelessWidget {
  final int currentIndex;
  const TabBarWidget({Key key, @required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Store<AppState> store = StoreProvider.of<AppState>(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.08,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildTab(context, Icons.poll, currentIndex == 0, 0, store),
              buildTab(context, Icons.my_library_books, currentIndex == 1, 1, store),
              buildTab(context, Icons.add, currentIndex == 2, 2, store, isAddTab: true),
              buildTab(context, Icons.person, currentIndex == 3, 3, store),
            ],
          ),
          Container(
            color: kLightMagenta,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.01,
          ),
        ],
      ),
    );
  }

  Widget buildTab(BuildContext context,
      IconData icon,
      bool active,
      int index,
      Store<AppState> store,
      {bool isAddTab = false}
      ) {

    void changeTab(int index) {
      store.dispatch(ChangeTabAction(index));
    }

    return GestureDetector(
      onTap: () => changeTab(index),
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.height * 0.07,
        color: active ? kMatteViolet : kLightMagenta,
        child: Icon(icon, color: active ? kWhite : null,),
      ),
    );
  }
}
