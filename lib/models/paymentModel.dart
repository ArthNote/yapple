import 'package:cloud_firestore/cloud_firestore.dart';

class paymentModel {
  String id;
  String fullAmount;
  String payingAmount;
  DateTime dueDate;
  DateTime paidDate;
  bool isPaid;

  paymentModel({
    required this.id,
    required this.fullAmount,
    required this.payingAmount,
    required this.dueDate,
    required this.paidDate,
    required this.isPaid,
  });

  factory paymentModel.fromJson(Map<String, dynamic> json) {
    return paymentModel(
      id: json['id'],
      fullAmount: json['fullAmount'],
      payingAmount: json['payingAmouny'],
      dueDate: (json['dueDate'] as Timestamp).toDate(),
      paidDate: (json['paidDate'] as Timestamp).toDate(),
      isPaid: json['isPaid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullAmount': fullAmount,
      'payingAmouny': payingAmount,
      'dueDate': Timestamp.fromDate(dueDate),
      'paidDate': Timestamp.fromDate(paidDate),
      'isPaid': isPaid,
    };
  }

  factory paymentModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return paymentModel(
      id: document.id,
      fullAmount: data['fullAmount'],
      payingAmount: data['payingAmouny'],
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      paidDate: (data['paidDate'] as Timestamp).toDate(),
      isPaid: data['isPaid'],
    );
    //return something
  }

  
}