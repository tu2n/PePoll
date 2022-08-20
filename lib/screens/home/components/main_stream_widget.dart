import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pepoll/core/colors.dart';
import 'package:pepoll/model/poll.dart';
import 'package:pepoll/redux/app_state.dart';
import 'package:pepoll/screens/home/components/question_text_widget.dart';
import 'package:pepoll/screens/home/components/second_sub_stream_widget.dart';
import 'package:pepoll/screens/home/home_screen.dart';
import 'package:redux/redux.dart';
import 'first_sub_stream_widget.dart';

class MainStreamWidget extends StatelessWidget {
  final FirebaseFirestore firestore;
  final Store<AppState> store;
  const MainStreamWidget({Key key, @required this.firestore, @required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection('channels').doc(FIRST_CHANNEL_UID).collection('polls').snapshots(),
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
              return polls.isNotEmpty ? ListView.separated(
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
                          FirstSubStreamWidget(firestore: firestore, polls: polls, index: index, store: store),
                          const SizedBox(height: 15),
                          // poll question
                          QuestionTextWidget(question: polls[index].question),
                          const SizedBox(height: 15),
                          // choices
                          SecondSubStreamWidget(firestore: firestore, polls: polls, index: index, store: store)
                        ],
                      )
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 5);
                },
              ) : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/empty.svg',
                    height: 200,
                  ),
                  const SizedBox(height: 10,),
                  const Text('No poll available', style: TextStyle(color: Colors.grey),),
                ],
              );
            }
          }
      ),
    );
  }
}
