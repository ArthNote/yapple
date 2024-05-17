// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last, must_be_immutable, prefer_const_constructors_in_immutables, use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:yapple/firebase/AssignmentService.dart';
import 'package:yapple/firebase/ChatService.dart';
import 'package:yapple/firebase/ModuleService.dart';
import 'package:yapple/firebase/QuizzService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/assignmentModel.dart';
import 'package:yapple/models/chatModel.dart';
import 'package:yapple/models/chatParticipantModel.dart';
import 'package:yapple/models/materialModel.dart';
import 'package:yapple/models/moduleModel.dart';
import 'package:yapple/models/quizzModel.dart';
import 'package:yapple/models/staticData.dart';
import 'package:yapple/models/studentModel.dart';
import 'package:yapple/models/teacherModel.dart';
import 'package:yapple/pages/global/chatPage.dart';
import 'package:yapple/pages/students/quizzPage.dart';
import 'package:yapple/pages/teachers/addAssignment.dart';
import 'package:yapple/pages/teachers/addQuizz.dart';
import 'package:yapple/pages/teachers/assignmentPage.dart';
import 'package:yapple/pages/teachers/quizzResults.dart';
import 'package:yapple/widgets/AssigmentItem.dart';
import 'package:yapple/widgets/ContentMaterialItem.dart';
import 'package:yapple/widgets/ProfileDialog.dart';
import 'package:yapple/widgets/QuizzItem.dart';
import 'package:yapple/widgets/SearchField.dart';
import 'package:yapple/widgets/StudentItem.dart';

class TeacherCourseDetailsPage extends StatefulWidget {
  final moduleModel module;
  TeacherCourseDetailsPage({super.key, required this.module});

  @override
  State<TeacherCourseDetailsPage> createState() =>
      _TeacherCourseDetailsPageState();
}

class _TeacherCourseDetailsPageState extends State<TeacherCourseDetailsPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final currentUser = FirebaseAuth.instance.currentUser;
  String uid = "";
  ModuleService moduleService = ModuleService();

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
    }
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(_handleTabIndex);
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController!.removeListener(_handleTabIndex);
    _tabController!.dispose();
    super.dispose();
  }

  void uploadFiles() async {
    await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'ppt',
        'pptx',
        'xls',
        'xlsx',
        'txt',
        'zip',
        'rar',
        '7z',
        'jpg',
        'jpeg',
        'png'
      ],
    ).then((value) async {
      if (value != null) {
        for (var file in value.files) {
          File mfile = File(file.path!);

          String fileName = file.path!.split('/').last;
          String fileExtension = fileName.split('.').last;
          String uniqueName =
              '${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

          var material = materialModel(
            id: uniqueName,
            name: fileName.split('.').first,
            url: "",
          );
          bool uploaded = await moduleService.uploadModuleMaterial(
              mfile, widget.module.classID, widget.module.id, material);
          if (uploaded == true) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("File uploaded successfully"),
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Failed to upload file"),
            ));
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            widget.module.name,
            style: TextStyle(fontSize: 17),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(
                text: "Details",
              ),
              Tab(
                text: "Resources",
              ),
              Tab(
                text: "Students",
              ),
            ],
          )),
      body: FutureBuilder(
        future: UserService().getTeacherData(uid, context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            teacherModel user = snapshot.data as teacherModel;
            return TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: BodyDetails(
                    module: widget.module,
                  ),
                ),
                BodyResources(
                  module: widget.module,
                ),
                BodyCircle(
                  module: widget.module,
                  uid: uid,
                  user: user,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: _tabController!.index == 1
          ? SpeedDial(
              foregroundColor: Colors.white,
              spacing: 20,
              spaceBetweenChildren: 10,
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                SpeedDialChild(
                  shape: CircleBorder(),
                  child: Icon(Icons.file_present_rounded),
                  label: "Add content",
                  onTap: () => uploadFiles(),
                ),
                SpeedDialChild(
                  shape: CircleBorder(),
                  child: Icon(Icons.assignment_rounded),
                  label: "Add assigment",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddAssignmentPage(
                                  module: widget.module,
                                )));
                  },
                ),
                SpeedDialChild(
                  shape: CircleBorder(),
                  child: Icon(Icons.quiz_rounded),
                  label: "Add quiz",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddQuizzPage(
                                  moduleID: widget.module.id,
                                  classID: widget.module.classID,
                                )));
                  },
                ),
              ],
            )
          : null,
    );
  }
}

class BodyDetails extends StatelessWidget {
  BodyDetails({super.key, required this.module});
  final moduleModel module;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            child: Icon(
              module.icon,
              size: 80,
              color: Theme.of(context).appBarTheme.backgroundColor,
            ),
            decoration: BoxDecoration(
              color: module.color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 30),
          Text(
            module.name,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Divider(
            color: Theme.of(context).colorScheme.tertiary,
            height: 1,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "About the module:",
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            module.about,
            textAlign: TextAlign.justify,
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          )
        ],
      ),
    );
  }
}

class BodyCircle extends StatefulWidget {
  final moduleModel module;
  final String uid;
  final teacherModel user;
  BodyCircle(
      {super.key, required this.module, required this.uid, required this.user});

  @override
  State<BodyCircle> createState() => _BodyCircleState();
}

class _BodyCircleState extends State<BodyCircle> {
  TextEditingController searchController = TextEditingController();

  UserService userService = UserService();

  List<studentModel> foundStudents = [];

  String searchTerm = "";

  Future<List<studentModel>> runFilter(String enteredKeyword) async {
    this.searchTerm = enteredKeyword;
    final students = await userService.getCircleStudents(widget.module.classID);
    List<studentModel> results = [];
    if (enteredKeyword.isEmpty) {
      return results = students;
    } else {
      results = students
          .where((student) =>
              student.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    return foundStudents = results;
  }

  void startChat(BuildContext context, studentModel student) async {
    try {
      List<String> ids = [student.id, widget.uid];
      ids.sort();
      String uniqueID = ids.join('_');
      bool check = await ChatService().checkChat(uniqueID);
      if (check == true) {
        String chatID = await ChatService().getChatID(uniqueID);
        if (chatID == null || chatID.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Failed to open chat"),
          ));
        }
        var studentt = chatParticipantModel(
          id: student.id,
          name: student.name,
          email: student.email,
          profilePicUrl: student.profilePicUrl,
          role: student.role,
        );
        var me = chatParticipantModel(
          id: widget.uid,
          name: widget.user.name,
          email: widget.user.email,
          profilePicUrl: widget.user.profilePicUrl,
          role: widget.user.role,
        );
        final chat = chatModel(
            id: chatID,
            lastMessage: '',
            timeSent: DateTime.now(),
            unreadMessages: 0,
            type: 'teacher',
            members: [me, studentt],
            singleChatId: uniqueID,
            membersId: [
              widget.uid,
              student.id,
            ]);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                      chatName: studentt.name,
                      isGroup: false,
                      type: 'teacher',
                      profilePic: studentt.profilePicUrl,
                      chat: chat,
                    )));
      } else {
        var studentt = chatParticipantModel(
          id: student.id,
          name: student.name,
          email: student.email,
          profilePicUrl: student.profilePicUrl,
          role: student.role,
        );
        var me = chatParticipantModel(
          id: widget.uid,
          name: widget.user.name,
          email: widget.user.email,
          profilePicUrl: widget.user.profilePicUrl,
          role: widget.user.role,
        );
        final newChat = chatModel(
            id: '',
            lastMessage: '',
            timeSent: DateTime.now(),
            unreadMessages: 0,
            type: 'teacher',
            members: [me, studentt],
            singleChatId: uniqueID,
            membersId: [
              widget.uid,
              student.id,
            ]);
        bool r = await ChatService().startChat(newChat, context);
        if (r == true) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Chat created successfully"),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Failed to create chat"),
          ));
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          MySearchField(
            onchanged: (value) {
              setState(() {
                searchTerm = value;
              });
            },
            myController: searchController,
            hintText: "Search",
            icon: Icons.search,
            bgColor: Theme.of(context).appBarTheme.backgroundColor!,
          ),
          SizedBox(
            height: 15,
          ),
          FutureBuilder<List<studentModel>>(
              future: runFilter(searchTerm),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List<studentModel> students =
                        snapshot.data! as List<studentModel>;
                    return Expanded(
                      child: ListView(
                        children: students
                            .map((student) => GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ProfileDialog(
                                        name: student.name,
                                        email: student.email,
                                        profilePicUrl: student.profilePicUrl,
                                        role: "Student",
                                        onPressed: () =>
                                            startChat(context, student),
                                      ),
                                    );
                                  },
                                  child: StudentItem(
                                    name: student.name,
                                    email: student.email,
                                    profilePicUrl: student.profilePicUrl,
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
        ],
      ),
    );
  }
}

class BodyResources extends StatefulWidget {
  final moduleModel module;
  BodyResources({super.key, required this.module});

  @override
  State<BodyResources> createState() => _BodyResourcesState();
}

class _BodyResourcesState extends State<BodyResources> {
  bool customIcon = false;

  void deleteMaterial(String materialID) async {
    bool deleted = await ModuleService().deleteModuleMaterial(
        widget.module.classID, widget.module.id, materialID);
    if (deleted == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Material deleted successfully"),
      ));
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to delete material"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            FutureBuilder<List<materialModel>>(
              future: ModuleService()
                  .getModuleMaterials(widget.module.classID, widget.module.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<materialModel> materials =
                      snapshot.data as List<materialModel>;
                  return ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      "Content Material",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    childrenPadding: EdgeInsets.fromLTRB(20, 0, 12, 15),
                    expandedAlignment: Alignment.centerLeft,
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    collapsedBackgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    //add a collapsed shape
                    collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1,
                        )),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1,
                        )),
                    children: List.generate(materials.length, (index) {
                      var material = materials[index];
                      return ContentMaterialItem(
                        name: material.name,
                        icon: Icons.delete,
                        onPressed: () => deleteMaterial(material.id),
                      );
                    }),
                    onExpansionChanged: (bool expanded) {
                      setState(() => customIcon = expanded);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error${snapshot.error}"));
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
            SizedBox(
              height: 30,
            ),
            FutureBuilder<List<assignmentModel>>(
              future: AssignmentService()
                  .getModuleAssignment(widget.module.classID, widget.module.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<assignmentModel> assignments =
                      snapshot.data as List<assignmentModel>;
                  return ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      "Assigments",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    childrenPadding: EdgeInsets.fromLTRB(20, 0, 12, 15),
                    expandedAlignment: Alignment.centerLeft,
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    collapsedBackgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    //add a collapsed shape
                    collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1,
                        )),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1,
                        )),
                    children: List.generate(assignments.length, (index) {
                      var assignment = assignments[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TeacherAssignmentPage(
                                        assignment: assignment,
                                        classID: widget.module.classID,
                                        moduleID: widget.module.id,
                                      )));
                        },
                        child: AssigmentItem(
                          name: assignment.title,
                        ),
                      );
                    }),
                    onExpansionChanged: (bool expanded) {
                      setState(() => customIcon = expanded);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error${snapshot.error}"));
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
            SizedBox(
              height: 30,
            ),
            FutureBuilder<List<quizzModel>>(
              future: QuizzService()
                  .getQuizzes(context, widget.module.classID, widget.module.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<quizzModel> quizzes = snapshot.data as List<quizzModel>;
                  return ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      "Quizzes",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    childrenPadding: EdgeInsets.fromLTRB(20, 0, 12, 15),
                    expandedAlignment: Alignment.centerLeft,
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    collapsedBackgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    //add a collapsed shape
                    collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1,
                        )),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1,
                        )),
                    children: List.generate(quizzes.length, (index) {
                      var quizz = quizzes[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeacherQuizzResults(
                                quizz: quizz,
                                classID: widget.module.classID,
                                moduleID: widget.module.id,
                              ),
                            ),
                          );
                        },
                        child: QuizzItem(
                          name: quizz.title,
                          iconButton: IconButton(
                            color: Theme.of(context).colorScheme.primary,
                            icon: Icon(
                              Icons.delete_rounded,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      );
                    }),
                    onExpansionChanged: (bool expanded) {
                      setState(() => customIcon = expanded);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error${snapshot.error}"));
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
