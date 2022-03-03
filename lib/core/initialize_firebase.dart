import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Define an async function to initialize FlutterFire
void initializeFlutterFire() async {
  try {
    // Wait for Firebase to initialize and set `_initialized` state to true
    await Firebase.initializeApp();
    debugPrint("FIREBASE INITIALIZED!");

  } catch(e) {
    // Set `_error` state to true if Firebase initialization fails
    debugPrint(e.toString());
  }
}