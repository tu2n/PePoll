import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pepoll/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../core/colors.dart';
import '../../core/pop_exit.dart';
import '../../model/poll.dart';
import '../../model/poll_choice.dart';
import '../../provider/auth.dart';
import '../../provider/firestore.dart';
import '../../redux/navigation/navigation_action.dart';

const FIRST_CHANNEL_UID = "ciJOX0OE1lEfocGv90Uy";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Widget buildChoiceItem(
      String pollDocId,
      PollChoice pollChoice,
      String userId,
      ) {

    return InkWell(
      onTap: () async {

        await addVote(pollDocId, pollChoice.uid, userId);
        await removeVote(pollDocId, pollChoice.uid, userId,);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 7),
        height: 30,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
                color: pollChoice.voted.contains(userId) ? kLightMagenta : kMatteViolet
            )
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  pollChoice.choice,
                  style: const TextStyle(
                      color: Colors.white60
                  ),
                ),

              ),
            ),

            const Expanded(child: SizedBox()),

            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  pollChoice.voted == null ? "0" : pollChoice.voted.length.toString(),
                  style: const TextStyle(
                      color: Colors.white60
                  ),
                ),

              ),
            ),

          ],
        ),
      ),
    );
  }

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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                child: Row(
                  children: [

                    // name and email arrange vertically
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, $firstName",
                          style: const TextStyle(
                              fontSize: 22,
                              color: kLightMagenta,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          email,
                          style: const TextStyle(
                              fontSize: 15,
                              color: kWhite,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5
                          ),
                        ),
                      ],
                    ),

                    const Expanded(child: SizedBox()),

                    // logout button
                    ElevatedButton(
                      onPressed: () async {
                        try{
                          await signOut();
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: kWhite,
                          onPrimary: Colors.black,
                          minimumSize: const Size(35, 40)
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
              ),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('channels').doc(FIRST_CHANNEL_UID).collection('polls').snapshots(),
                    builder: (context, snapshot) {
                      Poll poll;
                      List<Poll> polls = <Poll>[];

                      if(snapshot.hasData) {

                        final dbPolls = snapshot.data.docs;

                        for(var entry in dbPolls) {

                          poll = Poll(
                              question: entry.data()['question'],
                              expiration: entry.data()['expiration'],
                              createdBy: entry.data()['createdBy'],
                              uid: entry.reference.id,

                          );

                          polls.add(poll);

                        }
                      }

                      if(snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: kLightMagenta,),);
                      }
                      else if(snapshot.hasError) {
                        return const Center(child: Text('Something went wrong!'));
                      }else {
                        return snapshot.hasData ? ListView.separated(
                          shrinkWrap: true,
                          itemCount: polls.length,
                          itemBuilder: (context, index) {

                            return Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                    color: kDarkMatteViolet
                                ),
                                child: Column(
                                  children: [

                                    // avatar, name, expiration and more icon
                                    StreamBuilder<DocumentSnapshot>(
                                      stream: _firestore.collection('users').doc(polls[index].createdBy).snapshots(),
                                      builder: (context, snapshot) {

                                        String photoURL;
                                        String displayName;
                                        String expiration;

                                        DateTime date =  DateTime.parse(polls[index].expiration);

                                        expiration = Poll.formatExpDateToString(date);

                                        if(snapshot.hasData) {
                                          photoURL = snapshot.data.get('photoURL');

                                          displayName = snapshot.data.get('displayName');

                                        }

                                        return snapshot.hasData ? Row(
                                          children: [

                                            // avatar
                                            CircleAvatar(
                                              radius: 15,
                                              backgroundImage: photoURL != null
                                                  ? NetworkImage(photoURL)
                                                  : const AssetImage('assets/svg/profile_avatar.svg'),
                                            ),

                                            const SizedBox(width: 5),

                                            // name and poll expiration
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                               Align(
                                                 alignment: Alignment.centerRight,
                                                   child: Text(
                                                     displayName,
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
                                                       'Expiration: $expiration',
                                                       style: const TextStyle(
                                                           color: Colors.white60,
                                                           fontSize: 12
                                                       )
                                                   )
                                               ),
                                             ],

                                            ),

                                            const Expanded(child: SizedBox()),

                                            // more icon
                                            InkWell(
                                              onTap: () {},
                                              child: const Icon(
                                                Icons.more_vert,
                                                color: kWhite,
                                                size: 25,
                                              ),
                                            ),
                                          ],
                                        ) : const Center(child: CircularProgressIndicator(color: kLightMagenta));
                                      }
                                    ),

                                    const SizedBox(height: 15),

                                    // poll question
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        polls[index].question,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: kWhite
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 15),

                                    // choices
                                    StreamBuilder<QuerySnapshot>(
                                      stream: _firestore.collection('channels').doc(FIRST_CHANNEL_UID)
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
                                    ),
                                  ],
                                )
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 5);
                          },
                        ) : const Text(
                          'Hello',
                          style: TextStyle(fontSize: 50),
                        );
                      }
                    }
                ),
              ),
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
