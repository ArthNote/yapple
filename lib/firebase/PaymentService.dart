// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yapple/models/paymentModel.dart';

class PaymentService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool> addPayment(paymentModel payment, String parentID) async {
    try {
      final doc =
          db.collection('temporary').doc(parentID).collection('payments').doc();
      payment.id = doc.id;
      await doc.set(payment.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updatePayment(paymentModel payment, String parentID) async {
    try {
      await db
          .collection('parents')
          .doc(parentID)
          .collection('payments')
          .doc(payment.id)
          .update(payment.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //get payments where isPaid is false
  Future<List<paymentModel>> getUnpaidPayments(String parentID) async {
    try {
      final snapshot = await db
          .collection('parents')
          .doc(parentID)
          .collection('payments')
          .where('isPaid', isEqualTo: false)
          .get();
      return snapshot.docs.map((e) => paymentModel.fromSnapshot(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<int> getUnpaidPaymentsCount() async {
    try {
      int count = 0;
      final snapshot = await db.collection('parents').get();
      for (var doc in snapshot.docs) {
        final payments = await db
            .collection('parents')
            .doc(doc.id)
            .collection('payments')
            .where('isPaid', isEqualTo: false)
            .get();
        if (payments.docs.isNotEmpty) {
          for (var doc in payments.docs) {
            count += 1;
          }
        } else {
          continue;
        }
      }
      return count;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<int> getPaidPaymentsCount() async {
    try {
      int count = 0;
      final snapshot = await db.collection('parents').get();
      for (var doc in snapshot.docs) {
        final payments = await db
            .collection('parents')
            .doc(doc.id)
            .collection('payments')
            .where('isPaid', isEqualTo: true)
            .get();
        if (payments.docs.isNotEmpty) {
          for (var doc in payments.docs) {
            count += 1;
          }
        } else {
          continue;
        }
      }
      return count;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  //get payments where isPaid is true
  Future<List<paymentModel>> getPaidPayments(String parentID) async {
    try {
      final snapshot = await db
          .collection('parents')
          .doc(parentID)
          .collection('payments')
          .where('isPaid', isEqualTo: true)
          .get();
      return snapshot.docs.map((e) => paymentModel.fromSnapshot(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
