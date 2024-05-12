// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/utils/imagePicker.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.name;
  }

  Uint8List? image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
  }

  void updateProfile() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Name cannot be empty', textAlign: TextAlign.center),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    } else {
      String name = nameController.text;
      String profilePicUrl = widget.profilePicUrl;
      bool isUpdated = await UserService()
          .updateUserInfo(widget.uid, widget.role, name, profilePicUrl);

      if (isUpdated) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Profile Updated',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ));
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
                        child: image != null
                            ? CircleAvatar(
                                radius: 100,
                                backgroundImage: MemoryImage(image!),
                              )
                            : CircleAvatar(
                                radius: 100,
                                child: Icon(Icons.person),
                                backgroundColor: Colors.blue,
                              ),
                      )),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => selectImage(),
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
