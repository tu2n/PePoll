import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pepoll/core/colors.dart';
import 'package:pepoll/model/poll_choice.dart';
import 'package:pepoll/provider/firestore.dart';

Widget buildChoiceItem(String pollDocId, PollChoice pollChoice, String userId, String expirationDate) {
  return InkWell(
    onTap: () async {
      if(expirationDate == DateFormat('yyyy-MM-dd').format(DateTime.now())) return;
      await addVote(pollDocId, pollChoice.uid, userId);
      await removeVote(pollDocId, pollChoice.uid, userId,);
    },
    child: Container(
      margin: const EdgeInsets.only(top: 15),
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: pollChoice.voted.contains(userId) ? kLightMagenta : kMatteViolet
          )
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                pollChoice.choice,
                style: const TextStyle(
                    color: Colors.white60,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                pollChoice.voted == null ? "0" : pollChoice.voted.length.toString(),
                style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}