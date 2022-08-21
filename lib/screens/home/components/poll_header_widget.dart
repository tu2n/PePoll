import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pepoll/core/colors.dart';
import 'package:pepoll/model/poll.dart';
import 'package:pepoll/provider/firestore.dart';
import 'package:redux/redux.dart';
import 'package:pepoll/redux/app_state.dart';

class PollHeaderWidget extends StatelessWidget {
  final FirebaseFirestore firestore;
  final List<Poll> polls;
  final int index;
  final Store<AppState> store;
  const PollHeaderWidget({Key key,
    @required this.firestore,
    @required this.polls,
    @required this.index,
    @required this.store
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: firestore.collection('users').doc(polls[index].createdBy).snapshots(),
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
              Visibility(
                visible: store.state.localState.user.uid == polls[index].createdBy,
                child: InkWell(
                  onTap: () {
                    showCupertinoDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (_) {
                          return CupertinoAlertDialog(
                            title: const Text("Delete Poll"),
                            content: const Text("Are you sure you want to delete this poll?"),
                            actions: [
                              CupertinoDialogAction(
                                child: const Text("No"),
                                textStyle: const TextStyle(
                                    color: kLightMagenta
                                ),
                                onPressed: () => Navigator.pop(_),
                              ),
                              CupertinoDialogAction(
                                child: const Text("Yes"),
                                textStyle: const TextStyle(
                                    color: kMatteOrange
                                ),
                                onPressed: () async {
                                  await deletePoll(polls[index].uid);
                                  Navigator.pop(_);
                                },
                              ),
                            ],
                          );
                        }
                    );
                  },
                  child: const Icon(
                    Icons.delete,
                    color: kWhite,
                    size: 25,
                  ),
                ),
              ),
            ],
          ) : const Center(child: CircularProgressIndicator(color: kLightMagenta));
        }
    );
  }
}
