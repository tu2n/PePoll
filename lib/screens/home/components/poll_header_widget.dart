import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pepoll/core/colors.dart';
import 'package:pepoll/model/local_user.dart';
import 'package:pepoll/model/poll.dart';

class PollHeaderWidget extends StatelessWidget {
  final Poll poll;
  final LocalUser user;
  const PollHeaderWidget({Key key, @required this.poll, this.user,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final String expDate = Poll.formatExpDateToString(DateTime.parse(poll.expiration));
    return Row(
      children: [
        // avatar
        CircleAvatar(
          radius: 20,
          backgroundImage: user.photoURL != ""
              ? NetworkImage(user.photoURL)
              : null,
          child: user.photoURL == ""
              ? Text(user.email[0], style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),)
              : const Text(''),
        ),
        const SizedBox(width: 7),
        // name and poll expiration
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
                        fontSize: 20
                    )
                )
            ),
            const SizedBox(height: 1),
            Align(
                alignment: Alignment.centerRight,
                child: Text(
                    'Expiration: $expDate',
                    style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 14
                    )
                )
            ),
          ],
        ),
      ],
    );
  }
}
