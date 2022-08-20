import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pepoll/core/colors.dart';
import 'package:pepoll/model/poll.dart';
import 'package:pepoll/model/poll_choice.dart';
import 'package:pepoll/provider/firestore.dart';
import 'package:pepoll/screens/home/components/choice_item_widget.dart';
import 'package:redux/redux.dart';
import 'package:pepoll/redux/app_state.dart';

class SecondSubStreamWidget extends StatelessWidget {
  final FirebaseFirestore firestore;
  final List<Poll> polls;
  final int index;
  final Store<AppState> store;
  const SecondSubStreamWidget({Key key,
    @required this.firestore,
    @required this.polls,
    @required this.index,
    @required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('channels').doc(FIRST_CHANNEL_UID)
            .collection('polls').doc(polls[index].uid).collection('choices').snapshots(),
        builder: (context, snapshot) {
          List<Widget> choicesWidgets = [];
          PollChoice pollChoice;
          String pollDocID = polls[index].uid;
          List<String> voted = <String>[];
          if(snapshot.hasData) {
            final dbPollChoices = snapshot.data.docs;
            for(var entry in dbPollChoices) {
              for(var voter in entry.data()['voted']) {
                voted.add(voter);
              }
              pollChoice = PollChoice(
                  choice: entry.data()['choice'],
                  uid: entry.reference.id,
                  voted: voted
              );
              choicesWidgets.add(buildChoiceItem(
                pollDocID,
                pollChoice,
                store.state.localState.user.uid,
              )
              );
              voted = [];
            }
          }
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: kLightMagenta,),);
          }
          else if(snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          } else {
            return Column(
              children: choicesWidgets,
            );
          }
        }
    );
  }
}
