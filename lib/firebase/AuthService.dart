// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yapple/pages/global/login.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> signUpWithEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return {'user': credential.user!.uid, 'success': true};
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("The email address is already in use")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An error occurred: ${e.code}")));
      }
      return {'user': null, 'success': false, 'error': e.code};
    }
  }

  Future<Map<String, dynamic>> signInWithEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      return {'user': credential.user, 'success': true};
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("No user found with the provided email and password")));
      } else {
        print(e.code);
      }
      return {'user': null, 'success': false, 'error': e.code};
    }
  }

  Future<Map<String, dynamic>> findRecordWithEmailAndPassword(
      String email, String password) async {
    try {
      final docStudent = db
          .collection('temporary')
          .where("email", isEqualTo: email)
          .where("password", isEqualTo: password);
      final snapshot = await docStudent.get();
      if (snapshot.docs.isNotEmpty) {
        return {'recordID': snapshot.docs[0].id, 'success': true};
      } else {
        return {'recordID': null, 'success': false};
      }
    } on FirebaseAuthException catch (e) {
      return {'recordID': null, 'success': false, 'error': e.code};
    }
  }

  Future<bool> changeDocumentId(String oldId, String newId, String name) async {
    try {
      final temporaryCollection = db.collection('temporary');

      final oldDocument = await temporaryCollection.doc(oldId).get();

      final collection = db.collection(name);

      await collection.doc(newId).set(oldDocument.data()!);

      await temporaryCollection.doc(oldId).delete();
      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }

  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
