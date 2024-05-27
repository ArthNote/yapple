// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, empty_catches

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:yapple/models/eventModel.dart';
import 'package:yapple/widgets/MyButton.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  File image = File('');

  void uploadFiles() async {
    await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    ).then((value) async {
      if (value != null) {
        setState(() {
          image = File(value.files.single.path!);
        });
      }
    });
  }

  void createEvent() async {
    if (image.path.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please upload an image"),
      ));
    } else {
      try {
        final evDoc =
            await FirebaseFirestore.instance.collection('events').doc();
        String evID = evDoc.id;
        var event = eventModel(
          id: evID,
          imageUrl: '',
          date: DateTime.now(),
        );
        await evDoc.set(event.toJson());
        UploadTask? task;
        final ref = FirebaseStorage.instance.ref('events/').child(evID);
        task = ref.putFile(image);
        final snapshot = await task.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('events').doc(evID).update({
          'image': urlDownload,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Event created successfully"),
        ));
        setState(() {
          image = File('');
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Create Event',
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            image.path.isNotEmpty
                ? SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                : SizedBox(),
            image.path.isNotEmpty
                ? SizedBox(
                    height: 20,
                  )
                : SizedBox(),
            image.path.isNotEmpty
                ? MyButton(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    textColor: Theme.of(context).colorScheme.primary,
                    label: 'Clear Image',
                    isOutlined: true,
                    onPressed: () {
                      setState(() {
                        image = File('');
                      });
                    },
                  )
                : SizedBox(),
            image.path.isNotEmpty
                ? SizedBox(
                    height: 20,
                  )
                : SizedBox(),
            MyButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).appBarTheme.backgroundColor!,
              label: image.path.isNotEmpty ? 'Add Event' : 'Add Image',
              onPressed: image.path.isEmpty
                  ? () => uploadFiles()
                  : () => createEvent(),
            ),
          ],
        ),
      ),
    );
  }
}
