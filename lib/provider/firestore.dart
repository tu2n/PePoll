import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/local_user.dart';
import '../model/poll.dart';
import '../model/poll_choice.dart';

const FIRST_CHANNEL_UID = "ciJOX0OE1lEfocGv90Uy";

// <<<<<<<<<<<<<<<<<<<<<<<<<<<< POST >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Future<void> addUser(User user) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  users.doc(user.uid).set({
    'uid' : user.uid,
    'displayName' : user.displayName,
    'email' : user.email,
    'phoneNumber' : user.phoneNumber,
    'photoURL' : user.photoURL
  }).then((value) {
    debugPrint('[addUser] added user: ${user.displayName}');


  }).catchError((e) => debugPrint("[addUser] error adding user, Error: $e"));
}

Future<void> addMember(User user) async {
  CollectionReference members = FirebaseFirestore.instance.collection('channels').doc(FIRST_CHANNEL_UID).collection('members');

  members.doc(user.uid).set({
    'uid' : user.uid,
    'displayName' : user.displayName,
    'email' : user.email,
    'phoneNumber' : user.phoneNumber,
    'photoURL' : user.photoURL
  }).then((value) => debugPrint('[addUser] added member: ${user.displayName}'))
      .catchError((e) => debugPrint("[addUser] error adding member $e"));
}

Future<void> createPoll(Poll poll, List<PollChoice> pollChoices) async {
  CollectionReference polls =
    FirebaseFirestore.instance.collection('channels').doc(FIRST_CHANNEL_UID).collection('polls');

  polls.add({
    'question': poll.question,
    'expiration' : poll.expiration,
    'createdBy' : poll.createdBy,
  }).then((value) async {
    debugPrint("[createPoll] Newly added poll: ${value.id}");

    for(var pollChoice in pollChoices) {
      await createChoices(value.id, pollChoice);
    }



  }).catchError((e) => debugPrint("[createPoll] error adding new poll entry"));
}

Future<void> createChoices(String pollDoIc, PollChoice choice) async {
  CollectionReference polls = FirebaseFirestore.instance.collection('channels').doc(FIRST_CHANNEL_UID).collection('polls');
  CollectionReference choices = polls.doc(pollDoIc).collection('choices');

  List<String> voted = [];

  choices.add({
    'choice' : choice.choice,
    'voted' : voted,
  }).then((value) {
    debugPrint('[createChoices] success adding choices in poll[$pollDoIc]');

  }).catchError((e) => debugPrint('[createChoices] error adding choices in poll[$pollDoIc]: $e'));
}

// <<<<<<<<<<<<<<<<<<<<<<<<<<<< GET >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Future<LocalUser> getUserInfo(String userId) async {
  DocumentReference user = FirebaseFirestore.instance.collection('users').doc(userId);

  LocalUser localUser;

  await user.get().then((value) {
    if(value.exists) {
      debugPrint("[getUserInfo] Success fetch from user[$userId]");

      localUser = LocalUser(
          displayName: value.data()['displayName'],
          email: value.data()['email'],
          phoneNumber: value.data()['phoneNumber'],
          photoURL: value.data()['photoURL'],
          uid: value.data()['uid']
      );

    }else {
      debugPrint("[getUserInfo] No data fetch from user[$userId]");
    }
  }).catchError((e)=> debugPrint("[getUserInfo] Error fetching user[$userId] info: $e"));

  return localUser;
}


// <<<<<<<<<<<<<<<<<<<<<<<<<<<< UPDATE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Future<void> userVoted(String pollDocId, String userId) async {
  DocumentReference poll =
  FirebaseFirestore.instance.collection('channels').doc(FIRST_CHANNEL_UID).collection('polls').doc(pollDocId);

  await poll.get().then((value) {
    if(value.exists) {
      poll.update({
        'voted' : FieldValue.arrayUnion([userId])
      });
    }else {
      debugPrint("[userVoted] No data fetch from poll[$pollDocId]");
    }
  }).catchError((e) => debugPrint("[userVoted]: error updating voted list: $e"));

}

Future<void> addVote(String pollDocId, String pollChoiceDocId, String userId) async {
  DocumentReference pollChoice =
    FirebaseFirestore.instance.collection('channels')
        .doc(FIRST_CHANNEL_UID).collection('polls')
        .doc(pollDocId).collection('choices').doc(pollChoiceDocId);

  await pollChoice.get().then((value) {
    if(value.exists) {
      debugPrint("[addVote] Success fetch from poll choice [$pollChoiceDocId]");

      pollChoice.update({
        'voted' : FieldValue.arrayUnion([userId])
      });
    }else{
      debugPrint("[addVote] No data fetch from poll choice [$pollChoiceDocId]]");
    }

  }).catchError((e) => debugPrint("[addVote] error adding vote: $e"));
}

Future<void> removeVote(String pollDocId, String pollChoiceDocId, String userId) async {
  CollectionReference pollChoice =
    FirebaseFirestore.instance.collection('channels')
      .doc(FIRST_CHANNEL_UID).collection('polls')
      .doc(pollDocId).collection('choices');

  await pollChoice.get().then((value) async {
    if(value.docs.isNotEmpty) {
      debugPrint("[removeVote] Success fetch from poll [$pollDocId]");

      var choices = value.docs;

      for(var choice in choices) {
        if(choice.reference.id != pollChoiceDocId) {
          pollChoice.doc(choice.reference.id).update({
            'voted' : FieldValue.arrayRemove([userId])
          });
        }
      }

    }else{
      debugPrint("[addVote] No data fetch from poll choice [$pollChoiceDocId]]");
    }

  }).catchError((e) => debugPrint("[addVote] error adding vote: $e"));
}

// <<<<<<<<<<<<<<<<<<<<<<<<<<<< Delete >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Future<void> deletePoll(String pollDocId) async {
  DocumentReference poll =
  FirebaseFirestore.instance.collection('channels').doc(FIRST_CHANNEL_UID).collection('polls').doc(pollDocId);

  await poll.delete().then((value) {
    debugPrint("Poll[$pollDocId] deleted!");
  }).catchError((e) => debugPrint("Error: $e"));
}