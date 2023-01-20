import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pepoll/core/colors.dart';
import 'package:pepoll/provider/auth.dart';
import 'package:pepoll/redux/app_state.dart';
import 'package:pepoll/redux/navigation/navigation_action.dart';
import 'package:redux/redux.dart';

class TopBannerWidget extends StatelessWidget {
  final String firstName;
  final String email;
  const TopBannerWidget({Key key, @required this.firstName, @required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Store<AppState> store = StoreProvider.of<AppState>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
      child: Row(
        children: [
          Text(
            "Hello, $firstName",
            style: const TextStyle(
                fontSize: 20,
                color: kLightMagenta,
                fontWeight: FontWeight.bold
            ),
          ),
          const Expanded(child: SizedBox()),
          ElevatedButton(
            onPressed: () async {
              try{
                await Auth().signOut();
              } catch (e) {
                debugPrint(e.toString());
              }
            },
            style: ElevatedButton.styleFrom(
                primary: kWhite,
                onPrimary: Colors.black,
                minimumSize: const Size(28, 35)
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              ),
            ),
          ),
        ],
      ),
    );
  }
}
