import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pepoll/core/colors.dart';
import 'package:pepoll/model/local_user.dart';
import 'package:pepoll/model/poll.dart';
import 'package:pepoll/redux/app_state.dart';
import 'package:pepoll/redux/navigation/navigation_action.dart';
import 'package:pepoll/redux/poll_detail/poll_detail_action.dart';
import 'package:redux/redux.dart';
import 'package:pepoll/screens/home/components/poll_header_widget.dart';
import 'package:pepoll/screens/home/components/question_text_widget.dart';

class PollPreviewWidget extends StatelessWidget {
  final Poll poll;
  const PollPreviewWidget(this.poll, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Store<AppState> _store = StoreProvider.of<AppState>(context);
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(poll.createdBy).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            LocalUser user = LocalUser(
                displayName: snapshot.data.get('displayName'),
                email: snapshot.data.get('email'),
                phoneNumber: snapshot.data.get('phoneNumber'),
                photoURL: snapshot.data.get('photoURL'),
                uid: snapshot.data.get('uid')
            );
            return GestureDetector(
              onTap: () {
                _store.dispatch(SelectPollToViewAction(poll.uid, user, poll.createdBy == _store.state.localState.user.uid));
                _store.dispatch(Navigation.pushPollDetailScreen);
              },
              child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: kDarkMatteViolet,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    children: [
                      PollHeaderWidget(poll: poll, user: user,),
                      const SizedBox(height: 10),
                      QuestionTextWidget(question: poll.question),
                    ],
                  )
              ),
            );
          } else {
            return  Center(child: CircularProgressIndicator(color: kLightMagenta.withOpacity(0.3)));
          }
        }
    );
  }
}