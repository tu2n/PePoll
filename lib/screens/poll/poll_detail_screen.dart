import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pepoll/core/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pepoll/model/local_user.dart';
import 'package:pepoll/model/poll.dart';
import 'package:pepoll/model/poll_choice.dart';
import 'package:pepoll/provider/firestore.dart';
import 'package:pepoll/redux/app_state.dart';
import 'package:pepoll/redux/navigation/navigation_action.dart';
import 'package:pepoll/screens/home/components/choice_item_widget.dart';
import 'package:redux/redux.dart';
import '../../core/colors.dart';

class PollDetailScreen extends StatelessWidget {
  const PollDetailScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Store<AppState> _store = StoreProvider.of<AppState>(context);
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kMatteViolet,
      body: WillPopScope(
        onWillPop: () {
          return _store.dispatch(Navigation.pushHomeScreen);
        },
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _store.dispatch(Navigation.pushHomeScreen);
                      },
                      child: const Icon(
                        Icons.chevron_left,
                        size: 30, color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Poll Details",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_left,
                      size: 30, color: Colors.transparent,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              StoreConnector<AppState, String> (
                converter: (store) => store.state.pollDetailState.pollId,
                builder: (context, vm) {
                  return StreamBuilder<DocumentSnapshot>(
                      stream: _firestore.collection('channels').doc(FIRST_CHANNEL_UID).collection('polls').doc(vm).snapshots(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                         Poll poll = Poll(
                             question: snapshot.data.get('question'),
                             expiration: snapshot.data.get('expiration'),
                             createdBy: snapshot.data.get('createdBy')
                         );
                         return Padding(
                           padding: const EdgeInsets.all(20),
                           child: Column(
                             children: [
                               Container(
                                 padding: const EdgeInsets.all(15),
                                 decoration: BoxDecoration(
                                   color: kDarkMatteViolet,
                                   borderRadius: BorderRadius.circular(10)
                                 ),
                                 child: Column(
                                   children: [
                                     StoreConnector<AppState, LocalUser>(
                                       converter: (store) => store.state.pollDetailState.user,
                                       builder: (context, user) {
                                         return Row(
                                           children: [
                                             CircleAvatar(
                                               radius: 20,
                                               backgroundImage: user.photoURL != ""
                                                   ? NetworkImage(user.photoURL)
                                                   : null,
                                               child: user.photoURL == ""
                                                   ? Text(user.email[0], style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),)
                                                   : const Text(''),
                                             ),
                                             const SizedBox(width: 5),
                                             Column(
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                 Align(
                                                     alignment: Alignment.centerRight,
                                                     child: Text(
                                                         user.displayName == "" ? user.email : user.displayName,
                                                         style: const TextStyle(
                                                             color: kWhite,
                                                             fontWeight: FontWeight.bold,
                                                             fontSize: 16
                                                         )
                                                     )
                                                 ),
                                                 const SizedBox(height: 1),
                                                 Align(
                                                     alignment: Alignment.centerRight,
                                                     child: Text(
                                                         'Expiration: ${Poll.formatExpDateToString(DateTime.parse(poll.expiration))}',
                                                         style: const TextStyle(
                                                             color: Colors.white60,
                                                             fontSize: 10
                                                         )
                                                     )
                                                 ),
                                               ],
                                             ),
                                           ],
                                         );
                                       },
                                     ),
                                     const SizedBox(height: 10,),
                                     Text(
                                       poll.question,
                                       style: const TextStyle(
                                           fontSize: 30,
                                           fontWeight: FontWeight.bold,
                                           color: kWhite
                                       ),
                                     ),
                                     const SizedBox(height: 10,),
                                     StreamBuilder<QuerySnapshot>(
                                         stream: _firestore.collection('channels').doc(FIRST_CHANNEL_UID)
                                             .collection('polls').doc(poll.uid).collection('choices').snapshots(),
                                         builder: (context, snapshot) {
                                           List<Widget> choicesWidgets = [];
                                           PollChoice pollChoice;
                                           String pollDocID = poll.uid;
                                           String expirationDate = poll.expiration;
                                           List<String> voted = <String>[];
                                           if(snapshot.hasData) {
                                             print("yyyyyyy");
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
                                                   _store.state.localState.user.uid,
                                                   expirationDate
                                               )
                                               );
                                               voted = [];
                                             }
                                             return Column(
                                               children: [
                                                 Text("asdaddadad")
                                               ]
                                             );
                                           } else {
                                             return const Center(child: CircularProgressIndicator(color: kLightMagenta));
                                           }
                                         }
                                     )
                                   ],
                                 ),
                               ),
                             ],
                           ),
                         );
                        } else {
                          return const Center(child: CircularProgressIndicator(color: kLightMagenta));
                        }
                      }
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
