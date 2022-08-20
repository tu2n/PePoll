import 'package:flutter/material.dart';
import 'package:pepoll/core/colors.dart';
import 'package:pepoll/model/poll_choice.dart';
import 'package:pepoll/provider/firestore.dart';

Widget buildChoiceItem(String pollDocId, PollChoice pollChoice, String userId) {
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