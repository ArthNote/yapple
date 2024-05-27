// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, empty_catches, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:yapple/firebase/PaymentService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/parentModel.dart';
import 'package:yapple/models/paymentModel.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/MyTextField.dart';

class MakePayment extends StatelessWidget {
  const MakePayment({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            'Payments',
            style: TextStyle(fontSize: 17),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Unpaid',
              ),
              Tab(
                text: 'Paid',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Body(),
            Body1(),
          ],
        ),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  parentModel? parent;
  final currentUser = FirebaseAuth.instance.currentUser;
  String uid = "";
  late final LocalAuthentication authlocal;

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
    }
    authlocal = LocalAuthentication();
    getParent();
  }

  Future<void> getParent() async {
    var p = await UserService().getParent(uid, context);
    setState(() {
      parent = p;
    });
  }

  void showPaymentSheet(paymentModel payment) async {
    bool loading = false;
    bool paid = false;
    bool isAuthenticated = await authlocal.authenticate(
      localizedReason: 'Please authenticate to make the payment',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: false,
      ),
    );
    if (isAuthenticated) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: PaymentSheet(paid, loading, payment, parent!.id),
                );
              });
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Authentication failed',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          getParent();
        });
      },
      child: Padding(
        padding: EdgeInsets.all(20),
        child: FutureBuilder<List<paymentModel>>(
            future: parent != null
                ? PaymentService().getUnpaidPayments(parent!.id)
                : null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<paymentModel> payments =
                      snapshot.data! as List<paymentModel>;
                  if (payments.isEmpty) {
                    return Center(
                      child: Text('No payments due'),
                    );
                  }
                  return Expanded(
                    child: ListView(
                      children: payments
                          .map((payment) => Container(
                                margin: EdgeInsets.only(bottom: 20),
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(
                                        Icons.payment,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 30,
                                      ),
                                      title: Text(
                                        'Payment for ${payment.payingAmount}',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 17,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Due on ${DateFormat('MMMM dd yyyy').format(payment.dueDate)}',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 18),
                                      child: MyButton(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        textColor: Theme.of(context)
                                            .appBarTheme
                                            .backgroundColor!,
                                        label: 'Pay Now',
                                        onPressed: () {
                                          var newPayment = paymentModel(
                                            id: payment.id,
                                            payingAmount: payment.payingAmount,
                                            dueDate: payment.dueDate,
                                            fullAmount: payment.fullAmount,
                                            paidDate: DateTime.now(),
                                            isPaid: true,
                                          );
                                          showPaymentSheet(newPayment);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return Center(child: Text("Something went wrong"));
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}

class PaymentSheet extends StatefulWidget {
  PaymentSheet(this.paid, this.loading, this.payment, this.parentID);
  bool paid;
  bool loading;
  final paymentModel payment;
  final String parentID;

  @override
  State<PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<PaymentSheet> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
              top: -15,
              child: Container(
                width: 60,
                height: 7,
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: widget.paid
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                          size: 100,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Payment Successful',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add your payment information',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        MyTextField(
                          myController: cardNumberController,
                          isPass: false,
                          hintText: 'Card Number',
                          keyboardType: TextInputType.number,
                          suffixIcon: IconButton(
                            onPressed: () => cardNumberController.clear(),
                            icon: Icon(Icons.payment),
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: MyTextField(
                                myController: expiryDateController,
                                isPass: false,
                                hintText: 'MM/YY',
                                keyboardType: TextInputType.datetime,
                                suffixIcon: IconButton(
                                  onPressed: () {},
                                  color: Colors.grey,
                                  icon: Icon(Icons.calendar_today),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: MyTextField(
                                myController: cvvController,
                                isPass: false,
                                hintText: 'CVV',
                                keyboardType: TextInputType.number,
                                formatters: [LengthLimitingTextInputFormatter(3), FilteringTextInputFormatter.digitsOnly],
                                suffixIcon: IconButton(
                                  onPressed: () => cardNumberController.clear(),
                                  icon: Icon(Icons.lock),
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        MyButton(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          textColor:
                              Theme.of(context).appBarTheme.backgroundColor!,
                          label: 'Pay Now',
                          loading: widget.loading
                              ? CircularProgressIndicator(
                                  color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor!,
                                )
                              : null,
                          onPressed: () async {
                            if (cardNumberController.text.isEmpty ||
                                expiryDateController.text.isEmpty ||
                                cvvController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please fill all the fields',
                                    style: TextStyle(fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                ),
                              );
                            } else{
                              setState(() {
                              widget.loading = true;
                            });
                            await Future.delayed(Duration(seconds: 5),
                                () async {
                              await PaymentService().updatePayment(
                                  widget.payment, widget.parentID);
                            });
                            setState(() {
                              widget.loading = false;
                              widget.paid = true;
                            });
                            }
                          },
                        ),
                        SizedBox(height: 20),
                        MyButton(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.primary,
                          label: 'Cancel',
                          isOutlined: true,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
            ),
          ),
        ]);
  }
}



class Body1 extends StatefulWidget {
  const Body1({super.key});

  @override
  State<Body1> createState() => _Body1State();
}

class _Body1State extends State<Body1> {
  parentModel? parent;
  final currentUser = FirebaseAuth.instance.currentUser;
  String uid = "";

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
    }
    getParent();
  }

  Future<void> getParent() async {
    var p = await UserService().getParent(uid, context);
    setState(() {
      parent = p;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          getParent();
        });
      },
      child: Padding(
        padding: EdgeInsets.all(20),
        child: FutureBuilder<List<paymentModel>>(
            future: parent != null
                ? PaymentService().getPaidPayments(parent!.id)
                : null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<paymentModel> payments =
                      snapshot.data! as List<paymentModel>;
                  if (payments.isEmpty) {
                    return Center(
                      child: Text('No payment history found.'),
                    );
                  }
                  return Expanded(
                    child: ListView(
                      children: payments
                          .map((payment) => Container(
                                margin: EdgeInsets.only(bottom: 20),
                                width: double.infinity,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(
                                        Icons.payment,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 30,
                                      ),
                                      title: Text(
                                        'Payment for ${payment.payingAmount}',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 17,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Paid on ${DateFormat('MMMM dd yyyy').format(payment.paidDate)}',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return Center(child: Text("Something went wrong"));
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
