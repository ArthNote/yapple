// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:yapple/firebase/AssignmentService.dart';
import 'package:yapple/firebase/ChatService.dart';
import 'package:yapple/firebase/FeedbackService.dart';
import 'package:yapple/firebase/ModuleService.dart';
import 'package:yapple/firebase/QuizzService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/MyTextField.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage(
      {super.key,
      required this.name,
      required this.profilePicUrl,
      required this.uid,
      required this.role});
  final String name;
  final String profilePicUrl;
  final String uid;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
          child: Body(
        name: name,
        profilePicUrl: profilePicUrl,
        uid: uid,
        role: role,
      )),
    );
  }
}

class Body extends StatefulWidget {
  Body(
      {super.key,
      required this.name,
      required this.profilePicUrl,
      required this.uid,
      required this.role});
  final String name;
  final String profilePicUrl;
  final String uid;
  final String role;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController nameController = TextEditingController();
  TextEditingController picUrlController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.name;
    picUrlController.text = widget.profilePicUrl;
  }

  // void uploadProfilePic() async {
  //   final image = await ImagePicker()
  //       .pickImage(source: ImageSource.gallery, imageQuality: 70);
  //   if (image != null) {
  //     String imageUrl = await UserService().uploadProfilePic(widget.uid, image);
  //     setState(() {
  //       newImageUrl = imageUrl;
  //     });
  //   }
  // }

  void updateProfile() async {
    if (nameController.text.isEmpty || picUrlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('All fiels must be filled', textAlign: TextAlign.center),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    } else {
      String name = nameController.text;
      String profilePicUrl = picUrlController.text;
      bool isUpdated = await UserService()
          .updateUserInfo(widget.uid, widget.role, name, profilePicUrl);

      if (isUpdated) {
        await ChatService()
            .updateChatProfile(widget.uid, profilePicUrl, context, name);
        await FeedbackService()
            .updateFeedbackSender(widget.uid, profilePicUrl, context, name);
        if (widget.role == 'students') {
          await QuizzService()
              .updateStudentInfo(widget.uid, profilePicUrl, context, name);
          await AssignmentService()
              .updateStudentInfo(widget.uid, profilePicUrl, context, name);
        }
        if (widget.role == 'teachers') {
          await ModuleService()
              .updateTeacherInfo(widget.uid, profilePicUrl, context, name);
        }
        print('dasdasdasd');
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Failed to update profile', textAlign: TextAlign.center),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: Stack(
                children: [
                  SizedBox(
                      height: 120,
                      width: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: widget.profilePicUrl == "null"
                            ? CircleAvatar(
                                radius: 100,
                                child: Icon(Icons.person),
                                backgroundColor: Colors.blue,
                              )
                            : CircleAvatar(
                                radius: 100,
                                backgroundImage:
                                    NetworkImage(widget.profilePicUrl),
                              ),
                      )),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Theme.of(context).appBarTheme.backgroundColor!,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          MyTextField(
            myController: nameController,
            isPass: false,
            hintText: 'Name',
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 20),
          MyTextField(
            myController: picUrlController,
            isPass: false,
            hintText: 'Profile Picture URL',
            keyboardType: TextInputType.url,
          ),
          SizedBox(height: 20),
          MyButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).appBarTheme.backgroundColor!,
            label: 'Save',
            onPressed: () => updateProfile(),
          ),
        ],
      ),
    );
  }
}
