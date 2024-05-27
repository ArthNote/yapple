// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:yapple/firebase/PaymentService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/parentModel.dart';
import 'package:yapple/models/paymentModel.dart';
import 'package:yapple/models/studentModel.dart';
import 'package:yapple/widgets/DropdownList.dart';
import 'package:yapple/widgets/GroupChatStudentItem.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/MyTextField.dart';

class AddParent extends StatelessWidget {
  const AddParent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            'Add Parent',
            style: TextStyle(fontSize: 17),
          ),
        ),
        body: Body());
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  studentModel? selectedStudent;
  bool isSelected = true;
  String selectedPayment = 'Select Payment';

  void createParentRecord() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        selectedStudent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all fields',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } else {
      var parent = parentModel(
        id: '',
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        profilePicUrl: 'null',
        role: 'Parent',
        studentId: selectedStudent!.id,
        student: selectedStudent!,
      );

      Map<String, dynamic> isCreated =
          await UserService().createParentRecord(parent);
      if (isCreated['result'] as bool) {
        if (selectedPayment == 'One time') {
          var payment = paymentModel(
            id: '',
            fullAmount: '60000dh',
            payingAmount: '60000dh',
            dueDate: DateTime(DateTime.now().year, 5, 27),
            paidDate: DateTime.now(),
            isPaid: false,
          );
          bool isAdded = await PaymentService()
              .addPayment(payment, isCreated['id'] as String);
          if (isAdded) {
            print('Payment added successfully');
          } else {
            print('Failed to add payment');
          }
        } else if (selectedPayment == 'Per Semester') {
          var payment1 = paymentModel(
            id: '',
            fullAmount: '60000dh',
            payingAmount: '30000dh',
            dueDate: DateTime(DateTime.now().year, 1, 27),
            paidDate: DateTime.now(),
            isPaid: false,
          );
          await PaymentService()
              .addPayment(payment1, isCreated['id'] as String);
          var payment2 = paymentModel(
            id: '',
            fullAmount: '60000dh',
            payingAmount: '30000dh',
            dueDate: DateTime(DateTime.now().year, 5, 27),
            paidDate: DateTime.now(),
            isPaid: false,
          );
          await PaymentService()
              .addPayment(payment2, isCreated['id'] as String);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Parent created successfully',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        setState(() {
          nameController.clear();
          emailController.clear();
          passwordController.clear();
          searchController.clear();
          selectedStudent = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to create parent',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            MyTextField(
              myController: nameController,
              isPass: false,
              hintText: 'Enter parent name',
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            MyTextField(
              myController: emailController,
              isPass: false,
              hintText: 'Enter parent email',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            MyTextField(
              myController: passwordController,
              isPass: true,
              hintText: 'Enter parent password',
              keyboardType: TextInputType.visiblePassword,
            ),
            SizedBox(height: 20),
            FutureBuilder<List<studentModel>>(
                future: UserService().getAllActiveStudents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<studentModel> students =
                          snapshot.data! as List<studentModel>;
                      return SearchField(
                        enabled: isSelected,
                        controller: searchController,
                        searchInputDecoration: InputDecoration(
                          hintText: 'Search for students',
                          filled: true,
                          hintStyle: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .tertiary
                                .withOpacity(0.5),
                          ),
                          fillColor:
                              Theme.of(context).appBarTheme.backgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 1,
                            ),
                          ),
                        ),
                        itemHeight: 73,
                        maxSuggestionsInViewPort: 6,
                        onSuggestionTap: (p0) {
                          setState(() {
                            selectedStudent = p0.item as studentModel;
                            isSelected = false;
                          });
                        },
                        suggestionsDecoration: SuggestionDecoration(
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 1,
                          ),
                        ),
                        suggestions: List.generate(students.length, (index) {
                          var student = students[index];
                          return SearchFieldListItem(student.name,
                              item: student,
                              child: SearchClassItem(
                                name: student.name,
                                icon: Icons.add,
                              ));
                        }),
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
            SizedBox(height: 20),
            DropdownList(
              selectedItem: selectedPayment,
              title: 'Select Payment',
              selectedType: selectedPayment,
              onPressed: (String value) {
                setState(() {
                  selectedPayment = value;
                });
              },
              items: [
                DropdownMenuItem(
                  enabled: false,
                  child: Text('Select Payment',
                      style: TextStyle(color: Colors.grey)),
                  value: 'Select Payment',
                ),
                DropdownMenuItem(
                  child: Text('One time'),
                  value: 'One time',
                ),
                DropdownMenuItem(
                  child: Text('Per Semester'),
                  value: 'Per Semester',
                ),
              ],
            ),
            SizedBox(height: 20),
            MyButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).appBarTheme.backgroundColor!,
              label: 'Create Parent',
              onPressed: () => createParentRecord(),
            ),
          ],
        ),
      ),
    );
  }
}
